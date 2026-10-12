// Der Pruef-Motor: haelt die EINMAL kompilierte WASI-Component und erzeugt pro Request
// einen FRISCHEN `Store` + eine frische Instanz. Nach dem Request wird der `Store`
// gedroppt -> Instanz und lineares Memory sind weg, kein Zustand bleibt.
//
// Die Instanz bekommt NULL Faehigkeiten: der `WasiCtx` wird mit `WasiCtxBuilder::new()`
// ohne preopened-Verzeichnis, ohne Netz, ohne Env, ohne Stdio gebaut. Die Component
// importiert ausserdem gar kein `wasi:sockets` -> Netzzugriff ist nicht nur verboten,
// sondern technisch unmoeglich. `filesystem/preopens` liefert ohne preopen eine leere
// Liste -> kein erreichbarer Pfad. So KANN die Component nichts speichern oder senden.

use std::time::Duration;

use anyhow::{Context, Result, anyhow};
use wasmtime::component::{Component, Linker, ResourceTable};
use wasmtime::{Config, Engine, ResourceLimiter, Store};
use wasmtime_wasi::{WasiCtx, WasiCtxBuilder, WasiCtxView, WasiView};

use crate::antwort::{
    Befund, Bericht, EngineBericht, Fachfehler, Grenzfehler, Urteil, Xsd, Zusammenfassung,
};

// Harte Obergrenze fuer die Tabellen-Elemente einer Instanz. Jedes Element kostet einen
// Zeiger (8 B) -> 8 Mio. Elemente ~ 64 MiB. Grosszuegig genug fuer die Funktionstabellen
// der Component, aber eine Decke gegen eine entartete table.grow-Flut.
const MAX_TABLE_ELEMENTE: usize = 8 * 1024 * 1024;

// Typisierte Bindings aus der WIT der Component (world `validator`).
wasmtime::component::bindgen!({
    world: "validator",
    path: "../component/wit",
});

use exports::promaris::erechnung::pruefung as wit;

// Waechter ueber die Ressourcen einer EINZELNEN Instanz. wasmtime erlaubt je Instanz bis
// ~4 GiB lineares Memory; eine Entity-Bombe oder eine tief verschachtelte XML koennte das
// ausreizen und den Host-RAM auffressen. Der Waechter deckelt das harte Maximum: wird es
// ueberschritten, liefert `memory_growing` ein `Err` -> die Allokation trappt sofort
// (sauberer Abbruch mit praezisem Backtrace), der Lauf endet als Fehler, die Instanz wird
// verworfen. Kein Host-OOM. `grund` haelt fest, WELCHE Grenze gegriffen hat, damit der
// Aufrufer einen klaren 422 statt eines generischen 500 liefern kann.
struct Grenzwaechter {
    max_memory: usize,
    grund: Option<&'static str>,
}

impl ResourceLimiter for Grenzwaechter {
    fn memory_growing(
        &mut self,
        _current: usize,
        desired: usize,
        _maximum: Option<usize>,
    ) -> wasmtime::Result<bool> {
        if desired > self.max_memory {
            self.grund = Some("speicher-limit");
            // Err -> memory.grow trappt sofort statt -1 zurueckzugeben: deterministischer
            // Abbruch, der Gast kann nicht in einem halb-allozierten Zustand weiterlaufen.
            return Err(wasmtime::Error::msg(format!(
                "Speichergrenze erreicht: {desired} > {} Byte",
                self.max_memory
            )));
        }
        Ok(true)
    }

    fn table_growing(
        &mut self,
        _current: usize,
        desired: usize,
        _maximum: Option<usize>,
    ) -> wasmtime::Result<bool> {
        if desired > MAX_TABLE_ELEMENTE {
            self.grund = Some("tabelle-limit");
            return Err(wasmtime::Error::msg(format!(
                "Tabellengrenze erreicht: {desired} > {MAX_TABLE_ELEMENTE} Elemente"
            )));
        }
        Ok(true)
    }
}

// Host-Zustand einer Instanz: der (leere) WASI-Kontext, seine Ressourcentabelle und der
// Ressourcen-Waechter.
struct Host {
    wasi: WasiCtx,
    table: ResourceTable,
    waechter: Grenzwaechter,
}

impl WasiView for Host {
    fn ctx(&mut self) -> WasiCtxView<'_> {
        WasiCtxView { ctx: &mut self.wasi, table: &mut self.table }
    }
}

pub struct Motor {
    engine: Engine,
    component: Component,
    thread_stack: usize,
    timeout_s: u64,
    max_memory: usize,
}

impl Motor {
    // Baut Engine und Component einmalig. Startet einen Epoch-Ticker als harte
    // Zeitgrenze je Pruefung.
    pub fn neu(
        wasm: &str,
        wasm_stack: usize,
        thread_stack: usize,
        timeout_s: u64,
        max_memory: usize,
    ) -> Result<Self> {
        let mut config = Config::new();
        config.wasm_component_model(true);
        // Die EN-16931-Stylesheets rekursieren tief: Wasm-Stack anheben (Standard 512 KiB).
        config.max_wasm_stack(wasm_stack);
        // wasmtime verlangt async_stack_size >= max_wasm_stack, auch im sync-Betrieb.
        config.async_stack_size(wasm_stack.saturating_add(wasm_stack));
        // Zeitgrenze je Pruefung ueber Epoch-Interruption (eine Erhoehung je Sekunde).
        config.epoch_interruption(true);
        let engine = Engine::new(&config).map_err(|e| anyhow!("wasmtime-Engine: {e}"))?;
        let component = Component::from_file(&engine, wasm)
            .map_err(|e| anyhow!("Component laden ({wasm}): {e}"))?;

        // Ticker: erhoeht die Epoch einmal pro Sekunde. Pro Store ist die Deadline
        // `timeout_s` Ticks; wird sie erreicht, trappt der laufende Aufruf.
        let takt = engine.clone();
        std::thread::Builder::new()
            .name("epoch-takt".into())
            .spawn(move || {
                loop {
                    std::thread::sleep(Duration::from_secs(1));
                    takt.increment_epoch();
                }
            })
            .context("Epoch-Ticker")?;

        Ok(Self { engine, component, thread_stack, timeout_s, max_memory })
    }

    // Prueft rohes XML (CII/UBL). Laeuft auf einem frischen Thread mit grossem nativem
    // Stack, weil die in Wasm kompilierte Schematron-Rekursion tiefe native Frames erzeugt.
    pub fn pruefe(&self, xml: String) -> Result<Urteil> {
        self.auf_thread(move |engine, component, timeout, max_memory| {
            lauf_xml(engine, component, timeout, max_memory, xml)
        })
    }

    // Prueft eine ZUGFeRD/Factur-X-PDF. Das PDF-Parsing UND die Pruefung laufen in der
    // rechtlosen Wegwerf-Instanz: eine praeparierte PDF kann den Host nicht erreichen.
    pub fn pruefe_pdf(&self, pdf: Vec<u8>) -> Result<Urteil> {
        self.auf_thread(move |engine, component, timeout, max_memory| {
            lauf_pdf(engine, component, timeout, max_memory, pdf)
        })
    }

    // Gemeinsamer Rahmen: frischer Thread mit grossem nativem Stack, auf dem der Lauf
    // ausgefuehrt wird.
    fn auf_thread<F>(&self, f: F) -> Result<Urteil>
    where
        F: FnOnce(Engine, Component, u64, usize) -> Result<Urteil> + Send + 'static,
    {
        let engine = self.engine.clone();
        let component = self.component.clone();
        let timeout = self.timeout_s.max(1);
        let max_memory = self.max_memory;
        std::thread::Builder::new()
            .name("pruefung".into())
            .stack_size(self.thread_stack)
            .spawn(move || f(engine, component, timeout, max_memory))
            .context("Pruef-Thread starten")?
            .join()
            .map_err(|_| anyhow!("Pruef-Thread abgebrochen"))?
    }
}

// Ergebnis der Instanziierung: entweder die bereite Instanz (Store + Bindings) oder eine
// bereits an der Instanziierung gegriffene Ressourcengrenze (sauberer 422 statt 500).
enum Aufbau {
    Bereit(Store<Host>, Validator),
    Grenze(Grenzfehler),
}

// Baut eine FRISCHE, RECHTLOSE Instanz: kein preopen (kein FS), kein Netz, keine Env, kein
// Stdio; mit hartem Speicher-/Tabellenlimit und Epoch-Zeitgrenze. Gemeinsam fuer XML und PDF.
fn aufbau(engine: &Engine, component: &Component, timeout: u64, max_memory: usize) -> Result<Aufbau> {
    let mut linker: Linker<Host> = Linker::new(engine);
    wasmtime_wasi::p2::add_to_linker_sync(&mut linker).map_err(|e| anyhow!("WASI-Linker: {e}"))?;

    let host = Host {
        wasi: WasiCtxBuilder::new().build(),
        table: ResourceTable::new(),
        waechter: Grenzwaechter { max_memory, grund: None },
    };
    let mut store = Store::new(engine, host);
    // Hartes Speicher-/Tabellenlimit je Instanz: ueberzieht die Component, trappt die
    // Allokation (siehe Grenzwaechter) statt den Host-RAM aufzufressen.
    store.limiter(|h| &mut h.waechter);
    // Harte Zeitgrenze: nach `timeout` Epoch-Ticks trappt der Aufruf.
    store.set_epoch_deadline(timeout);

    // Auch die Instanziierung kann schon an der Speichergrenze scheitern (die Component
    // bringt ihre Pruefartefakte ins lineare Memory). Diesen Trap ebenfalls als
    // Ressourcengrenze (422) melden statt als internen Fehler (500).
    match Validator::instantiate(&mut store, component, &linker) {
        Ok(v) => Ok(Aufbau::Bereit(store, v)),
        Err(e) => {
            if let Some(g) = grenze_erkennen(&e, store.data().waechter.grund) {
                Ok(Aufbau::Grenze(g))
            } else {
                Err(anyhow!("Instanziierung: {e}"))
            }
        }
    }
}

// Ergebnis eines Pruefers aus der Component: Bericht oder Fachfehler.
type WitErgebnis = std::result::Result<wit::Bericht, wit::Fehler>;

// Pruefung von rohem XML in einer frischen, rechtlosen Instanz: beide Pruefer (KoSIT und
// Mustang) auf dem einmal geparsten Beleg.
fn lauf_xml(engine: Engine, component: Component, timeout: u64, max_memory: usize, xml: String) -> Result<Urteil> {
    let (mut store, validator) = match aufbau(&engine, &component, timeout, max_memory)? {
        Aufbau::Bereit(s, v) => (s, v),
        Aufbau::Grenze(g) => return Ok(Urteil::Grenze(g)),
    };
    let pruefung = validator.promaris_erechnung_pruefung();

    // Beide Werkzeuge mit automatischer Szenarienwahl (offizielles XRechnung-Szenario,
    // sonst EN-16931-Kernregeln). Aeusseres Result = Host-/Trap-Fehler, inneres je Pruefer.
    let (kosit, mustang) = match pruefung.call_beide(&mut store, &xml, wit::Szenarien::Automatisch) {
        Ok(t) => t,
        Err(e) => return trap_urteil(&e, &store).map(Ok).unwrap_or_else(|| Err(anyhow!("Aufruf beide: {e}"))),
    };
    // `store` wird nach dem Bauen gedroppt: Instanz + lineares Memory sind weg.
    Ok(urteil_bauen("xml", None, kosit, mustang))
}

// Pruefung einer ZUGFeRD/Factur-X-PDF in einer frischen, rechtlosen Instanz. Das
// PDF-Parsing UND beide Pruefer laufen IN der Component (call_beide_pdf) -- eine
// praeparierte PDF ist dort gegen FS/Netz abgeschnitten und bleibt vom Per-Instanz-
// Limit/Timeout gedeckelt. Die PDF wird EINMAL extrahiert und beiden Pruefern gereicht.
fn lauf_pdf(engine: Engine, component: Component, timeout: u64, max_memory: usize, pdf: Vec<u8>) -> Result<Urteil> {
    let (mut store, validator) = match aufbau(&engine, &component, timeout, max_memory)? {
        Aufbau::Bereit(s, v) => (s, v),
        Aufbau::Grenze(g) => return Ok(Urteil::Grenze(g)),
    };
    let pruefung = validator.promaris_erechnung_pruefung();

    let ergebnis = match pruefung.call_beide_pdf(&mut store, &pdf, wit::Szenarien::Automatisch) {
        Ok(e) => e,
        Err(e) => return trap_urteil(&e, &store).map(Ok).unwrap_or_else(|| Err(anyhow!("Aufruf beide-pdf: {e}"))),
    };

    // Aeusserer Fehler = PDF-Extraktion gescheitert (kaputte PDF / kein Rechnungs-XML):
    // sauberer fachlicher 422, kein 500.
    let pb = match ergebnis {
        Ok(pb) => pb,
        Err(e) => return Ok(Urteil::Fach(fach_bauen(e))),
    };
    let pdf_a = (!pb.pdf_a.is_empty()).then_some(pb.pdf_a);
    let mut urteil = urteil_bauen("pdf", Some(pb.eingebettet), pb.kosit, pb.mustang);
    if let Urteil::Bericht(ref mut b) = urteil {
        b.pdf_a = pdf_a;
    }
    Ok(urteil)
}

// Aus den beiden Pruefer-Ergebnissen die Antwort bauen. GATE-REGEL: KoSIT ist das Tor.
// Liefert KoSIT keinen Bericht (Dokument/kein-Szenario/Engine), wird daraus der fachliche
// 422 -- die ganze Pruefung gilt als abgelehnt. Mustang ist ergaenzend: kennt es den Beleg
// nicht, wird `mustang` weggelassen und `mustang_hinweis` gesetzt, ohne 422.
fn urteil_bauen(
    eingabe: &str,
    eingebettet: Option<String>,
    kosit: WitErgebnis,
    mustang: WitErgebnis,
) -> Urteil {
    let kbericht = match kosit {
        Ok(b) => b,
        Err(e) => return Urteil::Fach(fach_bauen(e)),
    };
    let artefakte = kbericht.artefakte.clone();
    let kosit_dauer = kbericht.dauer_ms;
    let kosit_eb = engine_bericht_bauen("kosit", kbericht);

    let (mustang_eb, mustang_hinweis, mustang_dauer) = match mustang {
        Ok(mb) => {
            let d = mb.dauer_ms;
            (Some(engine_bericht_bauen("mustang", mb)), None, d)
        }
        Err(e) => (None, Some(mustang_hinweis(e)), 0),
    };

    Urteil::Bericht(Bericht {
        eingabe: eingabe.to_string(),
        eingebettet,
        pdf_a: None,
        dauer_ms: kosit_dauer + mustang_dauer,
        artefakte,
        kosit: kosit_eb,
        mustang: mustang_eb,
        mustang_hinweis,
    })
}

// Grund, warum Mustang keinen Bericht lieferte -- in einen knappen Hinweis fuer die
// Erfolgsantwort uebersetzt. KoSIT hat hier bereits bestanden, also ist der Beleg wohlgeformt.
fn mustang_hinweis(e: wit::Fehler) -> String {
    match e {
        wit::Fehler::UnbekanntesProfil(k) => format!("ZUGFeRD/Factur-X-Profil nicht erkannt ({k})"),
        wit::Fehler::Dokument(m) => format!("Mustang: {m}"),
        wit::Fehler::KeinSzenario(m) => format!("Mustang: {m}"),
        wit::Fehler::Engine(m) => format!("Mustang-Engine: {m}"),
    }
}

// Trap eines Aufrufs auswerten: hat eine Ressourcengrenze gegriffen (Speicher/Tabelle/
// Zeit/Stack), ein sauberes Grenz-Urteil (422) liefern; sonst None (echter 500).
fn trap_urteil(e: &wasmtime::Error, store: &Store<Host>) -> Option<Urteil> {
    grenze_erkennen(e, store.data().waechter.grund).map(Urteil::Grenze)
}

// Ordnet einen Trap einer Ressourcengrenze zu. `grund` kommt aus dem Grenzwaechter
// (Speicher/Tabelle), sonst wird der Trap-Code gelesen: Interrupt = Epoch-Zeitgrenze,
// StackOverflow = zu tiefe (Wasm-)Rekursion. Alles andere ist kein Grenzfall -> None.
fn grenze_erkennen(e: &wasmtime::Error, grund: Option<&'static str>) -> Option<Grenzfehler> {
    let (art, meldung): (&str, &str) = if let Some(g) = grund {
        (g, "Beleg zu gross: Speicher-/Tabellengrenze der Pruefinstanz erreicht")
    } else {
        match e.downcast_ref::<wasmtime::Trap>() {
            Some(wasmtime::Trap::Interrupt) => ("zeit-limit", "Pruefung ueberschritt die Zeitgrenze"),
            Some(wasmtime::Trap::StackOverflow) => ("zu-komplex", "Beleg zu tief verschachtelt (Stack erschoepft)"),
            _ => return None,
        }
    };
    Some(Grenzfehler { fehler: art.to_string(), meldung: meldung.to_string() })
}

fn stufe_text(s: wit::Stufe) -> &'static str {
    match s {
        wit::Stufe::Information => "information",
        wit::Stufe::Warnung => "warnung",
        wit::Stufe::Fehler => "fehler",
    }
}

fn syntax_text(s: wit::Syntax) -> &'static str {
    match s {
        wit::Syntax::Cii => "cii",
        wit::Syntax::UblInvoice => "ubl-invoice",
        wit::Syntax::UblCreditnote => "ubl-creditnote",
    }
}

fn engine_bericht_bauen(werkzeug: &str, b: wit::Bericht) -> EngineBericht {
    let mut z = Zusammenfassung { fehler: 0, warnungen: 0, informationen: 0 };
    let befunde: Vec<Befund> = b
        .befunde
        .into_iter()
        .map(|f| {
            match f.stufe {
                wit::Stufe::Fehler => z.fehler += 1,
                wit::Stufe::Warnung => z.warnungen += 1,
                wit::Stufe::Information => z.informationen += 1,
            }
            Befund {
                regel: f.regel,
                stufe: stufe_text(f.stufe).to_string(),
                flag: f.flag,
                ort: f.ort,
                text: f.text,
                quelle: f.quelle,
            }
        })
        .collect();

    EngineBericht {
        angenommen: b.angenommen,
        werkzeug: werkzeug.to_string(),
        szenario: b.szenario,
        syntax: syntax_text(b.syntax).to_string(),
        kennung: b.kennung,
        xsd: Xsd { gueltig: b.xsd_gueltig, fehler: b.xsd_fehler },
        zusammenfassung: z,
        befunde,
    }
}

fn fach_bauen(f: wit::Fehler) -> Fachfehler {
    let (art, meldung) = match f {
        wit::Fehler::Dokument(m) => ("dokument", m),
        wit::Fehler::KeinSzenario(m) => ("kein-szenario", m),
        wit::Fehler::UnbekanntesProfil(m) => ("unbekanntes-profil", m),
        wit::Fehler::Engine(m) => ("engine", m),
    };
    Fachfehler { fehler: art.to_string(), meldung }
}
