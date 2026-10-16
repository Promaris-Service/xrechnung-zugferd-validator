//! WASI-ready KoSIT and Mustang validation for EN 16931 e-invoices (CII and UBL) in pure Rust.
//!
//! The crate executes the **original** validation artifacts (the compiled Schematron XSLTs
//! and XSDs of the KoSIT XRechnung configuration and of the Mustang validator) with the
//! pure-Rust engine `oxixml`. The rules are not reimplemented. No JVM, no C dependency;
//! builds natively and for `wasm32-wasip2`, where it is exposed as a WASI component with a
//! typed WIT interface.
//!
//! Layout (one file per concern, its documentation in the `.md` file of the same name):
//!   artefakte/    embedded XSLT/XSD files and their resolution from memory
//!   engine/       oxixml binding: document, stylesheet, schema, cache
//!   svrl.rs       translate the SVRL output of the Schematron XSLTs into findings
//!   bericht.rs    shared result format (serde, JSON)
//!   kosit/        scenario selection, levels (customLevel), validation as the KoSIT validator
//!   mustang/      profile selection and validation as Mustang's XMLValidator
//!   validator.rs  entry point: `Validator` holds the compiled artifacts (one per thread)

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

/// Version of the embedded artifacts, for reports and logs.
pub const ARTEFAKTE: &str = artefakte::VERSION;
