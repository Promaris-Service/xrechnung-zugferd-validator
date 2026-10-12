//! XSD-Satz aus dem Speicher kompilieren und pruefen. Siehe schema.md.

use crate::artefakte;
use crate::fehler::Fehler;
use oxixml_schema::{ResolvedSchema, Schema, SchemaError, SchemaResolver, SchemaSet};

/// Loest `schemaLocation`-Verweise gegen die eingebetteten Artefakte auf.
#[derive(Debug)]
struct SpeicherResolver;

impl SchemaResolver for SpeicherResolver {
    fn resolve(
        &mut self,
        location: &str,
        base: Option<&str>,
    ) -> Result<Option<ResolvedSchema>, SchemaError> {
        let uri = oxixml_xslt::resolve_uri(location, base);
        Ok(artefakte::finde_uri(&uri).map(|text| ResolvedSchema {
            uri,
            text: text.to_owned(),
        }))
    }
}

pub struct Kompiliert {
    pub schema: Schema,
}

pub fn kompiliere(pfad: &'static str) -> Result<Kompiliert, Fehler> {
    let text =
        artefakte::finde(pfad).ok_or_else(|| Fehler::Engine(format!("Artefakt fehlt: {pfad}")))?;
    let mut satz = SchemaSet::new().with_resolver(Box::new(SpeicherResolver));
    satz.add_document(Some(&artefakte::uri(pfad)), text)
        .map_err(|e| Fehler::Engine(format!("{pfad}: {e}")))?;
    let schema = satz
        .compile()
        .map_err(|e| Fehler::Engine(format!("{pfad}: {e}")))?;
    Ok(Kompiliert { schema })
}

impl Kompiliert {
    /// Prueft den Beleg; liefert (gueltig, Fehlertexte).
    pub fn pruefe(&self, xml: &str) -> (bool, Vec<String>) {
        let ergebnis = self.schema.validate_str(xml);
        let fehler = ergebnis
            .errors
            .iter()
            .map(|e| format!("{} {} @ {}", e.code(), e.message(), e.path()))
            .collect();
        (ergebnis.valid, fehler)
    }
}
