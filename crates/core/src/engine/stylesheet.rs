//! Schematron-XSLT aus dem Speicher kompilieren und ausfuehren. Siehe stylesheet.md.

use crate::artefakte;
use crate::fehler::Fehler;
use oxixml_infoset::Tree;
use oxixml_xslt::{CompiledStylesheet, MemoryResolver, Parameters, StaticOptions, Stylesheet};
use std::sync::Arc;

/// Ein kompiliertes Artefakt samt seinem Pfad (fuer `Befund::quelle`).
pub struct Kompiliert {
    pub pfad: &'static str,
    pub stylesheet: CompiledStylesheet,
}

/// Kompiliert das Artefakt `pfad`. Alle Mustang-Codelisten werden dem Resolver bekannt
/// gemacht, damit `document('FACTUR-X_…_codedb.xml')` aus dem Speicher bedient wird.
pub fn kompiliere(pfad: &'static str) -> Result<Kompiliert, Fehler> {
    let text =
        artefakte::finde(pfad).ok_or_else(|| Fehler::Engine(format!("Artefakt fehlt: {pfad}")))?;
    let mut resolver = MemoryResolver::new();
    if pfad.starts_with("mustang/") {
        for d in artefakte::mustang_codelisten() {
            resolver = resolver.with_document(artefakte::uri(d.pfad), d.text);
        }
    }
    let optionen = StaticOptions::new()
        .with_resolver(Arc::new(resolver))
        .with_base_uri(artefakte::uri(pfad));
    let stylesheet = Stylesheet::compile_str_with(text, optionen)
        .map_err(|e| Fehler::Engine(format!("{pfad}: {e}")))?;
    Ok(Kompiliert { pfad, stylesheet })
}

impl Kompiliert {
    /// Fuehrt das Stylesheet auf dem Beleg aus und liefert das SVRL als Text.
    pub fn svrl(&self, baum: &Tree, stack_bytes: usize) -> Result<String, Fehler> {
        let params = Parameters::new().with_stack_size(stack_bytes);
        let ergebnis = self
            .stylesheet
            .transform_with(&baum.root(), &params)
            .map_err(|e| Fehler::Engine(format!("{}: {e}", self.pfad)))?;
        Ok(ergebnis.into_string())
    }
}
