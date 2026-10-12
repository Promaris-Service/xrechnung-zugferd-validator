// Das Antwortformat des Dienstes. Reine Datenstruktur plus serde-Ableitung; hier liegt
// kein Zustand und keine Logik ausser der JSON-Form, damit das Schema fuer die Web-UI
// an einer Stelle steht. Der Motor fuellt diese Typen aus dem WIT-Bericht.

use serde::Serialize;

#[derive(Serialize)]
pub struct Befund {
    // Regel-ID (BR-S-05, CII-SR-013, BR-DE-1 ...), leer wenn das Artefakt keine liefert.
    pub regel: String,
    // "information" | "warnung" | "fehler".
    pub stufe: String,
    // Unveraenderter SVRL-flag (fatal, warning, leer ...).
    pub flag: String,
    // XPath-Ort im Beleg.
    pub ort: String,
    pub text: String,
    // Artefakt-Dateiname, aus dem der Befund stammt.
    pub quelle: String,
}

#[derive(Serialize)]
pub struct Xsd {
    pub gueltig: bool,
    pub fehler: Vec<String>,
}

#[derive(Serialize)]
pub struct Zusammenfassung {
    pub fehler: u32,
    pub warnungen: u32,
    pub informationen: u32,
}

// Urteil EINES Pruefers (KoSIT bzw. Mustang) ueber denselben Beleg.
#[derive(Serialize)]
pub struct EngineBericht {
    // Gesamturteil: XSD bestanden UND kein Befund der Stufe "fehler".
    pub angenommen: bool,
    // "kosit" | "mustang".
    pub werkzeug: String,
    // KoSIT: Szenarioname; Mustang: Profilname.
    pub szenario: String,
    // "cii" | "ubl-invoice" | "ubl-creditnote".
    pub syntax: String,
    // CustomizationID (UBL) bzw. Guideline-ID (CII).
    pub kennung: String,
    pub xsd: Xsd,
    pub zusammenfassung: Zusammenfassung,
    pub befunde: Vec<Befund>,
}

// Erfolgsantwort: beide Pruefer auf einem Beleg. KoSIT ist das Tor und immer da; Mustang
// ist ergaenzend und faellt weg, wenn es den Beleg nicht kennt (dann `mustang_hinweis`).
#[derive(Serialize)]
pub struct Bericht {
    // Art der Eingabe: "xml" (rohes CII/UBL) oder "pdf" (ZUGFeRD/Factur-X-Container).
    pub eingabe: String,
    // Nur bei PDF: Dateiname des aus der PDF extrahierten eingebetteten Rechnungs-XML.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub eingebettet: Option<String>,
    // Nur bei PDF, falls geprueft: PDF/A-Konformitaetsurteil (sonst weggelassen).
    #[serde(skip_serializing_if = "Option::is_none")]
    pub pdf_a: Option<String>,
    // Gesamtdauer beider Laeufe in Millisekunden.
    pub dauer_ms: u64,
    // Stand der eingebetteten Artefakte (fuer beide Pruefer derselbe).
    pub artefakte: String,
    // KoSIT-Urteil (immer vorhanden).
    pub kosit: EngineBericht,
    // Mustang-Urteil, oder weggelassen, wenn Mustang den Beleg nicht kennt.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub mustang: Option<EngineBericht>,
    // Nur gesetzt, wenn `mustang` weggelassen wurde: Grund dafuer.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub mustang_hinweis: Option<String>,
}

// Fachlicher Fehler (kein Beleg-Befund): Nicht-XML, kein Rechnungstyp, Engine-Fehler.
#[derive(Serialize)]
pub struct Fachfehler {
    // "dokument" | "kein-szenario" | "unbekanntes-profil" | "engine".
    pub fehler: String,
    pub meldung: String,
}

// Ressourcengrenze gegriffen: der Beleg hat Speicher/Tabelle/Zeit ueberzogen und der
// Lauf wurde sauber abgebrochen (Trap). Kein Host-Fehler, kein OOM -- der Beleg ist
// schlicht zu gross/komplex. Traegt wie Fachfehler die Statuszeile des 422-Weges.
#[derive(Serialize)]
pub struct Grenzfehler {
    // "speicher-limit" | "tabelle-limit" | "zeit-limit" | "zu-komplex".
    pub fehler: String,
    pub meldung: String,
}

pub enum Urteil {
    Bericht(Bericht),
    Fach(Fachfehler),
    Grenze(Grenzfehler),
}
