//! Gemeinsames Ergebnisformat beider Werkzeuge. Siehe bericht.md.

use serde::{Deserialize, Serialize};

/// Which tool produced the report.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Werkzeug {
    Kosit,
    Mustang,
}

/// Syntax of the document, derived from the root element.
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

/// Severity of a finding after the tool's own rules have been applied (customLevel etc.).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Stufe {
    Information,
    Warnung,
    Fehler,
}

impl Stufe {
    /// Translate an SVRL `flag` or a KoSIT `level` into a severity.
    /// `ohne_flag` states what a finding without any value means (KoSIT: error, Mustang: error).
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

/// A single Schematron finding (an `svrl:failed-assert` or `svrl:successful-report`).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Befund {
    /// Rule ID (`BR-S-05`, `CII-SR-013`, `BR-DE-1` …), empty if the artifact supplies none.
    pub regel: String,
    /// Severity according to the tool's rules.
    pub stufe: Stufe,
    /// The unchanged `flag` value from the SVRL (`fatal`, `warning`, empty …).
    pub flag: String,
    /// XPath location in the document, as the artifact names it.
    pub ort: String,
    /// Message text, verbatim from the artifact.
    pub text: String,
    /// Artifact the finding originates from (file name).
    pub quelle: String,
}

/// Result of a validation run.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Bericht {
    pub werkzeug: Werkzeug,
    /// KoSIT: scenario name; Mustang: profile name.
    pub szenario: String,
    pub syntax: Syntax,
    /// CustomizationID (UBL) or Guideline ID (CII) of the document.
    pub kennung: String,
    /// XSD validation passed.
    pub xsd_gueltig: bool,
    /// XSD errors verbatim (code, message, path).
    pub xsd_fehler: Vec<String>,
    /// Schematron findings from every applied artifact.
    pub befunde: Vec<Befund>,
    /// Overall verdict: XSD passed and no finding of severity `Fehler`.
    pub angenommen: bool,
    /// Pure validation time in milliseconds (excluding artifact compilation).
    pub dauer_ms: u64,
    /// Version of the embedded artifacts.
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
