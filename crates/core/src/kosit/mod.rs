//! Pruefung wie der KoSIT-Validator mit der XRechnung-Konfiguration. Siehe mod.md.
//!   szenario.rs  Szenarienwahl nach Syntax und Kennung (scenarios.xml nachgebildet)
//!   stufen.rs    customLevel aus scenarios.xml: Regel-ID -> Stufe je Szenario
//!   pruefung.rs  Ablauf: XSD -> Schematron-XSLTs -> Stufen -> Annahme

mod pruefung;
mod stufen;
mod szenario;

pub use pruefung::pruefe;
pub use stufen::Stufen;
pub use szenario::{ALLE_XSD, ALLE_XSLT, Szenarien};
