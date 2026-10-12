//! Anbindung der oxixml-Engine. Siehe mod.md.
//!   dokument.rs   Beleg einmal parsen, Syntax und Kennung bestimmen
//!   stylesheet.rs Schematron-XSLT aus dem Speicher kompilieren und ausfuehren
//!   schema.rs     XSD-Satz aus dem Speicher kompilieren und pruefen
//!   schematron.rs Schematron-Quelle direkt ausfuehren (schneller als der XSLT-Weg)
//!   cache.rs      kompilierte Artefakte je Validator-Exemplar vorhalten

pub mod cache;
pub mod dokument;
pub mod schema;
pub mod schematron;
pub mod stylesheet;
