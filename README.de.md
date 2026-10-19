# erechnung-validator

**EN-16931-Rechnungsprüfung als WASI-Component — XRechnung, ZUGFeRD und Factur-X
in reinem Rust, mit den originalen KoSIT- und Mustang-Artefakten, ohne JVM.**

> 🇬🇧 An English version of this README is in [README.md](https://github.com/Promaris-Service/xrechnung-zugferd-validator/blob/main/README.md).

KoSIT- und Mustang-Validierung für E-Rechnungen nach EN 16931 (CII und UBL) in **reinem
Rust** — nativ als Cargo-Crate und CLI, und als **WASI-Component** (`wasm32-wasip2`) mit
typisierter WIT-Schnittstelle. Keine JVM, keine C-Bibliothek, nichts nachzuladen: die
originalen Prüfartefakte (Schematron-XSLTs, XSDs, Codelisten) sind eingebettet.

Die Regeln sind **nicht nachgebaut**. Ausgeführt werden die originalen Artefakte mit der
Rust-Engine [oxixml](https://github.com/cool-japan/oxixml): die EN-16931-Kernregeln als
Schematron-Quelle (CEN 1.3.16, dieselbe Fassung, die KoSITs XSLT zugrunde liegt), alles
andere als die kompilierten XSLTs, die auch Saxon im KoSIT-Validator und in Mustang
ausführt.

Belegt ist das an zwei Beständen. Auf 255 echten Eingangsrechnungen (250 CII, 5 UBL, alle
Factur-X-Profile plus XRechnung) sind die Befunde — Regel-IDs, Schweregrade, XSD-Urteil —
zu **255/255 identisch** mit dem KoSIT-Validator 1.6.1, und die Mustang-Urteile zu
**255/255 identisch** mit Mustang 2.24.0. Auf einem zweiten, größeren Bestand von **8.357
echten Ausgangsrechnungen** (XRechnung 3.0, CII) wurde der KoSIT-Pfad Beleg für Beleg gegen
den KoSIT-Validator 1.6.3 mit Konfiguration 2026-08-31 geprüft: 1.443 Belege tragen Befunde,
1.505 Befunde insgesamt, und Regel-IDs wie Schweregrade stimmen auf **8.357/8.357** Belegen
überein — kein einziger Unterschied.

**Bei den Mustang-Regeln ist es deutlich schneller. Bei den KoSIT-Regeln hängt die Antwort
davon ab, wie man Java betreibt.** Über dieselben 8.357 Belege führt es die Mustang-Regeln
rund **10× schneller** aus als Mustang-Java 2.26.0 (8,3 s gegen 81,6 s). Gegen den
KoSIT-Validator gewinnt es den einmaligen Stapellauf (6,3 s gegen 8,6 s inklusive Start),
verliert aber gegen einen warmgelaufenen KoSIT-Daemon (3,6 s). Zahlen, Methode und der
Grund für die Aufspaltung unter [Leistung](#leistung).

## Was drin ist

| Crate | Was | Ziel |
|---|---|---|
| `crates/core` (`erechnung-validator`) | Bibliothek: `Validator::kosit`, `::mustang`, `::beide` | nativ und wasm32 |
| `crates/component` (`erechnung-validator-wasi`) | WASI-Component, exportiert `promaris:erechnung/pruefung` | wasm32-wasip2 |
| `crates/cli` (`erechnung-validator`) | Kommandozeile, nativ alle Kerne, oder als WASI-Command | beides |
| `examples/host-wasmtime` | Beispiel-Host, lädt die Component mit wasmtime | nativ |

Eingebettete Artefakte (`crates/core/artefakte/`, Herkunft und Lizenzen in `NOTICE.md`):

- **KoSIT** `validator-configuration-xrechnung` Stand 2026-08-31: XRechnung 3.0.2
  (CII, UBL Invoice, UBL CreditNote, Extension, CVD), EN 16931 CII/UBL, Szenarien
  mit `customLevel`. Zusätzlich die Promaris-Szenarien „EN16931 für jeden Beleg".
- **CEN** EN 16931 Schematron-Quellen, Release validation-1.3.16 (vorverarbeitet:
  Includes eingebettet, abstrakte Muster instanziiert).
- **Mustang 2.26.0**: Factur-X 1.09.2 (ZF_250) MINIMUM, BASIC WL, BASIC, EN16931,
  EXTENDED mit Codelisten, XRechnung 1.2 bis 3.0 (CII/UBL), EN 16931 CII/UBL, XSDs je Profil.

## Nativ (Rust)

```toml
[dependencies]
erechnung-validator = "0.1"
```

```rust
use erechnung_validator::{Szenarien, Validator};

// Ein Validator je Thread; der Thread braucht 64 MiB Stack (Validator::STACK_BYTES).
let v = Validator::new();
let xml = std::fs::read_to_string("rechnung.xml")?;

let kosit = v.kosit(&xml, Szenarien::Automatisch)?;   // wie KoSIT
let mustang = v.mustang(&xml)?;                        // wie Mustang (XML-Teil)
println!("{} {}", kosit.angenommen, kosit.json());
for f in kosit.fehler() { println!("{} {}", f.regel, f.text); }
```

`Szenarien::XRechnung302` verhält sich wie die offizielle KoSIT-Konfiguration (Factur-X
hat dort **kein** Szenario → `Fehler::KeinSzenario`), `En16931Alle` prüft jeden Beleg
gegen die EN-16931-Kernregeln, `Automatisch` (Standard) nimmt das offizielle Szenario, wenn
es eines gibt.

`vorwaermen()` kompiliert alle Artefakte vorab. XSLT- und Schematron-Artefakte liegen
**prozessweit** nur einmal im Speicher (`Arc`), also kostet ein zweiter Worker sie nicht
erneut; nur das XSD-Schema liegt je Validator (es ist nicht `Send`). Siehe
`crates/core/src/engine/cache.md`.

### CLI

```
cargo build --release -p erechnung-validator-cli
./target/release/erechnung-validator [--kosit|--mustang|--beide] [--szenarien xrechnung|alle|auto]
                                     [--threads N] [--json|--kurz] <datei.xml|verzeichnis>...
```

Eine JSON-Zeile je Beleg und Werkzeug (Standard) oder `--kurz`. Rückgabe 0, wenn alle
Belege angenommen wurden. Nativ laufen so viele Worker wie Kerne.

## WASI-Component

```
rustup target add wasm32-wasip2
cargo build --release --target wasm32-wasip2 -p erechnung-validator-wasi -p erechnung-validator-cli
```

Ergebnis: `target/wasm32-wasip2/release/erechnung_validator_wasi.wasm` (Bibliothek,
World `validator`) und `erechnung-validator.wasm` (Command). Beide liegen auch als
Release-Artefakt bei, zusammen mit `validator.wit`.

Schnittstelle (`crates/component/wit/validator.wit`):

```wit
interface pruefung {
    kosit:      func(xml: string, szenarien: szenarien) -> result<bericht, fehler>;
    mustang:    func(xml: string) -> result<bericht, fehler>;
    beide:      func(xml: string, szenarien: szenarien) -> tuple<result<bericht, fehler>, result<bericht, fehler>>;
    vorwaermen: func() -> result<_, fehler>;
    artefakte:  func() -> string;
}
```

`bericht` trägt Szenario/Profil, Syntax, Kennung, XSD-Urteil mit Fehlertexten, die
Befunde (Regel-ID, Stufe, Original-Flag, XPath-Ort, Wortlaut, Artefakt) und das
Gesamturteil `angenommen`.

**Host-Pflicht:** Die EN-16931-Stylesheets rekursieren tief. Der Host muss den Wasm-Stack
auf 64 MiB anheben (wasmtime: `Config::max_wasm_stack(64 << 20)` bzw.
`-W max-wasm-stack=67108864`); der Shadow-Stack der Component ist bereits 64 MiB
(`.cargo/config.toml`). Eine Component-Instanz ist ein Thread: kompilierte Artefakte
bleiben über Aufrufe erhalten, also eine Instanz je Worker anlegen und `vorwaermen`.

Command-Component mit wasmtime:

```
wasmtime run -W max-wasm-stack=67108864 --dir ./belege::/belege \
  target/wasm32-wasip2/release/erechnung-validator.wasm -- --kurz /belege
```

Beispiel-Host in Rust: `examples/host-wasmtime` (typisierte Bindings per
`wasmtime::component::bindgen!`).

## Leistung

Gemessen an **8.357 echten Ausgangsrechnungen** (XRechnung 3.0, CII; 87 MB) auf einem AMD
Ryzen Threadripper PRO 5975WX (32 Kerne, 64 Threads, 125 GB RAM), Release-Build mit Fat-LTO
und `-C target-cpu=native`. Beide Seiten fahren **dieselben Artefakte**: KoSIT-Konfiguration
2026-08-31 mit KoSIT-Validator 1.6.3 und Mustang 2.26.0. Jeder Wert ist der beste aus drei
Läufen; die Streuung blieb unter 4 %.

### Durchsatz

| Regelsatz | Wandzeit | je Beleg | Belege/s | Spitzenspeicher |
|---|---|---|---|---|
| KoSIT | **6,30 s** | 0,75 ms | 1.327 | 0,98 GB |
| Mustang | **8,32 s** | 1,00 ms | 1.004 | 1,28 GB |
| beide | **14,03 s** | 1,68 ms | 596 | 1,59 GB |

### Gegen die Java-Validatoren

| | diese Crate | Java | |
|---|---|---|---|
| **Mustang** — 64 JVMs, je ein Verzeichnis | **8,32 s** | 81,56 s | **9,8× schneller** |
| KoSIT — einmaliger Stapellauf, Start inbegriffen | **6,30 s** | 8,55 s | 1,36× schneller |
| KoSIT — warmgelaufener Daemon (`-T 64`) | 6,30 s | **3,63 s** | 1,7× **langsamer** |
| KoSIT — 64 JVMs im Stapelbetrieb | **6,30 s** | 98,44 s | 15,6× schneller |

Der KoSIT-Vergleich spaltet sich, weil die Startkosten nicht symmetrisch sind. Diese Crate
braucht 0,10 s (KoSIT) bzw. 0,34 s (Mustang) für Prozessstart und Artefaktaufbau — in den
Stapelwerten ist das enthalten. Der KoSIT-Daemon braucht **4,06 s** einmalig und ist danach
schnell: 3,63 s reine Prüfung, und das bei zusätzlich 28 KB HTML-Visualisierung je Beleg, die
diese Crate gar nicht erzeugt. Für den einmaligen Lauf liegt die Crate vorn, für den
Dauerbetrieb eine warme JVM mit Saxon.

Frühere Fassungen dieser README nannten weit größere Faktoren. Die stammten aus einem
255-Beleg-Bestand mit KoSIT-Java in einer deutlich schwächeren Aufstellung (zwei parallele
JVMs); der Daemon ist rund 40× besser als das. Mustang-Java ist, je Verzeichnis statt je Datei
aufgerufen, etwa doppelt so schnell wie die früher genannten 324 ms je Beleg. Die Werte oben
ersetzen die alten.

### Skalierung über die Threadzahl

3.998 Belege, beide Regelsätze:

| Threads | Wandzeit | Faktor | Effizienz | RSS |
|---|---|---|---|---|
| 1 | 196,88 s | 1,00 | 100 % | 0,52 GB |
| 2 | 99,77 s | 1,97 | 99 % | 0,52 GB |
| 4 | 46,97 s | 4,19 | 105 % | 0,57 GB |
| 8 | 24,07 s | 8,18 | 102 % | 0,66 GB |
| 16 | 13,92 s | 14,14 | 88 % | 0,80 GB |
| 32 | 9,52 s | 20,68 | 65 % | 1,01 GB |
| 64 | 7,11 s | 27,69 | 43 % | 1,53 GB |

Bis 8 Threads nahezu ideal. Die Maschine hat 32 physische Kerne, 64 Threads sind also SMT;
die 43 % Effizienz dort sind die normale Ausbeute, kein Mangel — **32 Threads sind der
Arbeitspunkt**. Werte über 100 % sind Cache- und Turbo-Verhalten, also Messrauschen und kein
Ergebnis.

Der Speicher wächst von 1 auf 64 Threads nur von 0,52 auf 1,53 GB: Der geteilte
Artefakt-Cache tut, was er soll. Mit Cache je Thread waren es 12 bis 49 GB für dieselbe Arbeit.

### Rechenzeit je Beleg auf einem Kern

| Regelsatz | Median | p90 | p99 | Maximum |
|---|---|---|---|---|
| KoSIT | 37 ms | 50 ms | 127 ms | 639 ms |
| Mustang | 49 ms | 65 ms | 286 ms | 914 ms |
| *Mustang-Java 2.26.0* | *174 ms* | *1.132 ms* | *2.513 ms* | *30.187 ms* |

Die Verteilung ist eng — p90 liegt beim 1,35-Fachen des Medians —, sodass wenige langsame
Belege die Gesamtlaufzeit nicht bestimmen, sobald genug davon da sind.

Die Zeit skaliert linear mit der Dokumentgröße (r = 0,915, rund 4,6 ms je KB), sie ist also
keine Fixkost je Beleg. Innerhalb der Schematron-Stufe gehen etwa **48 %** in die Auswertung
der 806 Asserts, **35 %** in das Treffen der 113 Regelkontexte — jeder davon ein vollständiger
Baumdurchlauf ab Wurzel — und 17 % in den Aufbau. Die XSD-Prüfung macht 2 % des Ganzen aus.

**Woher die Beschleunigung kommt:** Der XSLT-Weg (die kompilierten Schematron-XSLTs von
KoSIT und Mustang in oxixml) brauchte 40,7 s (KoSIT) bzw. 77 s (Factur-X) Rechenzeit für
den 255-Beleg-Bestand und 0,5 bis 2,5 s Kompilierung je Artefakt; Saxon ist auf diesem Weg je
Dokument rund zwölfmal schneller. Die Schematron-Quellen direkt auszuführen
(`oxixml-schematron`, jede Regel ein XPath) senkt die Rechenzeit auf 18 s (KoSIT) bzw. 11 s
(Factur-X) und die Kompilierung auf Millisekunden — bei identischen Befunden. Dafür werden
die Quellen vorverarbeitet (Includes, abstrakte Muster, Codelisten statt `document()`), siehe
`crates/core/scripts/` und `crates/core/src/engine/schematron.md`. Nur das
XRechnung-Schematron (eigene `xsl:function`) und Mustangs CEN-Lauf für XRechnung laufen noch
als XSLT.

## Was bewusst nicht enthalten ist

- Mustangs PDF-Teil (veraPDF-PDF/A-3-Prüfung, XMP, Einbettung) und seine Java-seitige
  Arithmetikprobe. Beides ist kein Schematron.
- ZUGFeRD 1.0, Order-X, XRechnung 1.x/2.x, das französische Flux-2-Schematron.
- KoSITs HTML-Report und `rep:`-XML; der `Bericht` trägt dieselben Informationen.

## Tests

```
cargo test --workspace --release
# Regression gegen einen eigenen Bestand mit KoSIT-Referenz (Kundenbelege bleiben lokal):
ERECHNUNG_BESTAND=/pfad/zu/xml ERECHNUNG_KOSIT_CODES=/pfad/kosit-codes.tsv cargo test --release -p erechnung-validator --test bestand
```

Die Beispiele unter `crates/core/tests/belege` stammen aus der XRechnung-Testsuite
(Apache-2.0).

## Artefakte aktuell halten

Die eingebetteten Artefakte sind in `docs/artefakte-quellen.toml` festgenagelt.
`scripts/pruefe-artefakt-updates.py` vergleicht diese Pins mit den Upstream-Releases von
KoSIT, EN 16931 und Mustang und endet mit 10, wenn es eine neuere Fassung gibt; wie man sie
übernimmt, steht in `docs/artefakte-aktualisieren.md`.

`crates/core/build.rs` erzeugt die Tabelle der eingebetteten Artefakte bei jeder Änderung
unter `artefakte/` neu; eine Datei mehr oder weniger braucht also keinen Handgriff. Es
verweigert außerdem den Bau, wenn eine Schematron-Quelle noch roh von upstream ist
(`<include>` oder `abstract="true"` darin) — ein solches Artefakt würde zur Laufzeit still
zu wenig prüfen.

## Aufbau

Jedes Modul ist nach Belang in Dateien getrennt; zu jeder `.rs` liegt eine gleichnamige
`.md` mit Zweck, Norm, Fallen und dem, was bewusst nicht gebaut wurde. Einstieg:
`crates/core/src/lib.rs`.

## Lizenz

Code: MIT OR Apache-2.0. Eingebettete Artefakte Dritter: siehe `NOTICE.md`.
