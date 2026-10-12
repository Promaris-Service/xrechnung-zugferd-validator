//! Fehlerarten der Crate. Siehe fehler.md.

use std::fmt;

/// Alles, was eine Pruefung verhindert (nicht: Befunde am Beleg, die stehen im Bericht).
///
/// `#[non_exhaustive]`: neue Varianten sind kein SemVer-Bruch; abhaengige Crates
/// muessen beim Matchen einen Wildcard-Arm (`_`) vorsehen.
#[derive(Debug, Clone, PartialEq, Eq)]
#[non_exhaustive]
pub enum Fehler {
    /// Der Beleg ist kein wohlgeformtes XML oder kein bekannter Rechnungstyp.
    Dokument(String),
    /// Kein KoSIT-Szenario passt zur CustomizationID / Guideline-ID (wie KoSIT: Ablehnung).
    KeinSzenario(String),
    /// Mustang kennt das Profil nicht (z. B. ZUGFeRD 1.0, Order-X).
    UnbekanntesProfil(String),
    /// Ein Artefakt liess sich nicht kompilieren oder ausfuehren (Engine-Fehler).
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
