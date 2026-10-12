//! KoSIT- und Mustang-Validierung fuer EN-16931-E-Rechnungen (CII und UBL) in reinem Rust.
//!
//! Die Crate fuehrt die **originalen** Pruefartefakte aus (die kompilierten Schematron-XSLTs
//! und XSDs der KoSIT-XRechnung-Konfiguration und des Mustang-Validators) mit der reinen
//! Rust-Engine `oxixml`. Kein Regel-Nachbau, keine JVM, keine C-Abhaengigkeit; baut nativ
//! und fuer `wasm32-wasip2`.
//!
//! Aufbau (je Belang eine Datei, Doku in der gleichnamigen `.md`):
//!   artefakte/  eingebettete XSLT/XSD-Dateien und ihre Aufloesung aus dem Speicher
//!   engine/     oxixml-Anbindung: Dokument, Stylesheet, Schema, Cache
//!   svrl.rs     SVRL-Ausgabe der Schematron-XSLTs in Befunde uebersetzen
//!   bericht.rs  gemeinsames Ergebnisformat (serde, JSON)
//!   kosit/      Szenarienwahl, Stufen (customLevel), Pruefung wie der KoSIT-Validator
//!   mustang/    Profilwahl und Pruefung wie Mustangs XMLValidator
//!   validator.rs  Einstieg: `Validator` haelt die kompilierten Artefakte (ein Exemplar je Thread)

mod artefakte;
mod bericht;
mod engine;
mod fehler;
mod kosit;
mod mustang;
mod pdf;
mod svrl;
mod validator;

pub use bericht::{Befund, Bericht, Stufe, Syntax, Werkzeug};
pub use fehler::Fehler;
pub use kosit::Szenarien;
pub use validator::{Doppelergebnis, Validator};

/// Version der eingebetteten Artefakte, fuer Berichte und Protokolle.
pub const ARTEFAKTE: &str = artefakte::VERSION;
