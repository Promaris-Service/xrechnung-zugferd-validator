//! WASI-Component ueber der nativen Crate `erechnung-validator`.
//! Die Schnittstelle steht in `wit/validator.wit`; hier wird nur uebersetzt.
//! Ein Component-Exemplar ist ein Thread: der `Validator` lebt in einem `thread_local`
//! und behaelt die kompilierten Artefakte ueber alle Aufrufe.

wit_bindgen::generate!({
    world: "validator",
    path: "wit",
});

use exports::promaris::erechnung::pruefung::{
    BeidePdfBericht, Befund, Bericht, Fehler, Guest, PdfBericht, Stufe, Syntax, Szenarien,
};
use std::cell::RefCell;

thread_local! {
    static VALIDATOR: RefCell<Option<erechnung_validator::Validator>> = const { RefCell::new(None) };
}

fn mit_validator<T>(f: impl FnOnce(&erechnung_validator::Validator) -> T) -> T {
    VALIDATOR.with(|v| {
        let mut v = v.borrow_mut();
        let val = v.get_or_insert_with(erechnung_validator::Validator::new);
        f(val)
    })
}

fn stufe(s: erechnung_validator::Stufe) -> Stufe {
    match s {
        erechnung_validator::Stufe::Information => Stufe::Information,
        erechnung_validator::Stufe::Warnung => Stufe::Warnung,
        erechnung_validator::Stufe::Fehler => Stufe::Fehler,
    }
}

fn syntax(s: erechnung_validator::Syntax) -> Syntax {
    match s {
        erechnung_validator::Syntax::Cii => Syntax::Cii,
        erechnung_validator::Syntax::UblInvoice => Syntax::UblInvoice,
        erechnung_validator::Syntax::UblCreditNote => Syntax::UblCreditnote,
    }
}

fn szenarien(s: Szenarien) -> erechnung_validator::Szenarien {
    match s {
        Szenarien::Xrechnung302 => erechnung_validator::Szenarien::XRechnung302,
        Szenarien::En16931Alle => erechnung_validator::Szenarien::En16931Alle,
        Szenarien::Automatisch => erechnung_validator::Szenarien::Automatisch,
    }
}

fn bericht(b: erechnung_validator::Bericht) -> Bericht {
    Bericht {
        szenario: b.szenario,
        syntax: syntax(b.syntax),
        kennung: b.kennung,
        xsd_gueltig: b.xsd_gueltig,
        xsd_fehler: b.xsd_fehler,
        befunde: b
            .befunde
            .into_iter()
            .map(|f| Befund {
                regel: f.regel,
                stufe: stufe(f.stufe),
                flag: f.flag,
                ort: f.ort,
                text: f.text,
                quelle: f.quelle,
            })
            .collect(),
        angenommen: b.angenommen,
        dauer_ms: b.dauer_ms,
        artefakte: b.artefakte,
    }
}

fn fehler(f: erechnung_validator::Fehler) -> Fehler {
    match f {
        erechnung_validator::Fehler::Dokument(m) => Fehler::Dokument(m),
        erechnung_validator::Fehler::KeinSzenario(m) => Fehler::KeinSzenario(m),
        erechnung_validator::Fehler::UnbekanntesProfil(m) => Fehler::UnbekanntesProfil(m),
        erechnung_validator::Fehler::Engine(m) => Fehler::Engine(m),
        // `Fehler` ist `#[non_exhaustive]`: eine kuenftige Variante des Kerns hat noch
        // keine Entsprechung in der WIT-Schnittstelle. Sie wird als `engine` mit ihrem
        // Display-Text gemeldet, damit der Grund nicht verloren geht. Beim Erweitern der
        // WIT-Variante gehoert hier ein eigener Arm dazu.
        andere => Fehler::Engine(andere.to_string()),
    }
}

fn ergebnis(
    r: Result<erechnung_validator::Bericht, erechnung_validator::Fehler>,
) -> Result<Bericht, Fehler> {
    r.map(bericht).map_err(fehler)
}

struct Component;

impl Guest for Component {
    fn kosit(xml: String, sz: Szenarien) -> Result<Bericht, Fehler> {
        mit_validator(|v| ergebnis(v.kosit(&xml, szenarien(sz))))
    }

    fn kosit_pdf(pdf: Vec<u8>, sz: Szenarien) -> Result<PdfBericht, Fehler> {
        mit_validator(|v| match v.kosit_pdf(&pdf, szenarien(sz)) {
            Ok((eingebettet, b)) => Ok(PdfBericht {
                eingebettet,
                // Der Core prueft das Rechnungs-XML, nicht die PDF/A-Konformitaet.
                pdf_a: String::new(),
                bericht: bericht(b),
            }),
            Err(e) => Err(fehler(e)),
        })
    }

    fn mustang(xml: String) -> Result<Bericht, Fehler> {
        mit_validator(|v| ergebnis(v.mustang(&xml)))
    }

    fn beide(xml: String, sz: Szenarien) -> (Result<Bericht, Fehler>, Result<Bericht, Fehler>) {
        mit_validator(|v| match v.beide(&xml, szenarien(sz)) {
            Ok((k, m)) => (ergebnis(k), ergebnis(m)),
            Err(e) => (Err(fehler(e.clone())), Err(fehler(e))),
        })
    }

    fn beide_pdf(pdf: Vec<u8>, sz: Szenarien) -> Result<BeidePdfBericht, Fehler> {
        mit_validator(|v| match v.beide_pdf(&pdf, szenarien(sz)) {
            Ok((eingebettet, (k, m))) => Ok(BeidePdfBericht {
                eingebettet,
                // Der Core prueft das Rechnungs-XML, nicht die PDF/A-Konformitaet.
                pdf_a: String::new(),
                kosit: ergebnis(k),
                mustang: ergebnis(m),
            }),
            Err(e) => Err(fehler(e)),
        })
    }

    fn vorwaermen() -> Result<(), Fehler> {
        mit_validator(|v| v.vorwaermen().map_err(fehler))
    }

    fn artefakte() -> String {
        erechnung_validator::ARTEFAKTE.to_string()
    }
}

export!(Component);
