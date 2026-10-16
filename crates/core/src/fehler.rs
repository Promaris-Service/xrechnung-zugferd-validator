//! Fehlerarten der Crate. Siehe fehler.md.

use std::fmt;

/// Anything that prevents a validation run (not: findings on the document, which go into the report).
///
/// `#[non_exhaustive]`: new variants are not a SemVer break; dependent crates
/// must provide a wildcard arm (`_`) when matching.
#[derive(Debug, Clone, PartialEq, Eq)]
#[non_exhaustive]
pub enum Fehler {
    /// The document is not well-formed XML, or not a known invoice type.
    Dokument(String),
    /// No KoSIT scenario matches the CustomizationID / Guideline ID (rejected, as KoSIT does).
    KeinSzenario(String),
    /// Mustang does not know this profile (e.g. ZUGFeRD 1.0, Order-X).
    UnbekanntesProfil(String),
    /// An artifact could not be compiled or executed (engine error).
    Engine(String),
}

impl fmt::Display for Fehler {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Fehler::Dokument(m) => write!(f, "Dokument: {m}"),
            Fehler::KeinSzenario(id) => write!(f, "kein Szenario fuer '{id}'"),
            Fehler::UnbekanntesProfil(id) => write!(f, "unbekanntes Profil '{id}'"),
            Fehler::Engine(m) => write!(f, "Engine: {m}"),
        }
    }
}

impl std::error::Error for Fehler {}
