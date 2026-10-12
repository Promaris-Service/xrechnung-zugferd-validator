//! Gemeinsames Ergebnisformat beider Werkzeuge. Siehe bericht.md.

use serde::{Deserialize, Serialize};

/// Welches Werkzeug den Bericht erzeugt hat.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Werkzeug {
    Kosit,
    Mustang,
}

/// Syntax des Belegs, aus dem Wurzelelement abgeleitet.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Syntax {
    Cii,
    UblInvoice,
    UblCreditNote,
}

impl Syntax {
    pub fn as_str(self) -> &'static str {
        match self {
            Syntax::Cii => "cii",
            Syntax::UblInvoice => "ubl-invoice",
            Syntax::UblCreditNote => "ubl-credit-note",
        }
    }
}

/// Schweregrad eines Befunds nach Anwendung der Werkzeugregeln (customLevel usw.).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Stufe {
    Information,
    Warnung,
    Fehler,
}

impl Stufe {
    /// SVRL-`flag` bzw. KoSIT-`level` in eine Stufe uebersetzen.
    /// `ohne_flag` sagt, was ein Befund ohne Angabe bedeutet (KoSIT: Fehler, Mustang: Fehler).
    pub fn aus_flag(flag: &str, ohne_flag: Stufe) -> Stufe {
        match flag.trim().to_ascii_lowercase().as_str() {
            "" => ohne_flag,
            "fatal" | "error" => Stufe::Fehler,
            "warning" | "warn" => Stufe::Warnung,
            "information" | "info" => Stufe::Information,
            _ => ohne_flag,
        }
    }
}

/// Ein einzelner Schematron-Befund (ein `svrl:failed-assert` bzw. `svrl:successful-report`).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Befund {
    /// Regel-ID (`BR-S-05`, `CII-SR-013`, `BR-DE-1` …), leer wenn das Artefakt keine liefert.
    pub regel: String,
    /// Stufe nach Werkzeugregeln.
    pub stufe: Stufe,
    /// Der unveraenderte `flag`-Wert aus dem SVRL (`fatal`, `warning`, leer …).
    pub flag: String,
    /// XPath-Ort im Beleg, wie das Artefakt ihn nennt.
    pub ort: String,
    /// Meldungstext im Wortlaut des Artefakts.
    pub text: String,
    /// Artefakt, aus dem der Befund stammt (Dateiname).
    pub quelle: String,
}

/// Ergebnis einer Pruefung.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Bericht {
    pub werkzeug: Werkzeug,
    /// KoSIT: Szenarioname; Mustang: Profilname.
    pub szenario: String,
    pub syntax: Syntax,
    /// CustomizationID (UBL) bzw. Guideline-ID (CII) des Belegs.
    pub kennung: String,
    /// XSD-Pruefung bestanden.
    pub xsd_gueltig: bool,
    /// XSD-Fehler im Wortlaut (Code, Meldung, Pfad).
    pub xsd_fehler: Vec<String>,
    /// Schematron-Befunde aller angewandten Artefakte.
    pub befunde: Vec<Befund>,
    /// Gesamturteil: XSD bestanden und kein Befund der Stufe `Fehler`.
    pub angenommen: bool,
    /// Reine Pruefdauer in Millisekunden (ohne Artefakt-Kompilierung).
    pub dauer_ms: u64,
    /// Version der eingebetteten Artefakte.
    pub artefakte: String,
}

impl Bericht {
    pub fn fehler(&self) -> impl Iterator<Item = &Befund> {
        self.befunde.iter().filter(|b| b.stufe == Stufe::Fehler)
    }
    pub fn warnungen(&self) -> impl Iterator<Item = &Befund> {
        self.befunde.iter().filter(|b| b.stufe == Stufe::Warnung)
    }
    pub fn json(&self) -> String {
        serde_json::to_string(self).unwrap_or_default()
    }
}
