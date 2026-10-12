//! Schematron-Quelle direkt ausfuehren (ohne XSLT-Umweg). Siehe schematron.md.

use crate::artefakte;
use crate::bericht::{Befund, Stufe};
use crate::fehler::Fehler;
use oxixml_infoset::Tree;
use oxixml_schematron::{CheckOutcome, Compiled, Schematron};

pub struct Kompiliert {
    pub pfad: &'static str,
    schema: Compiled,
}

/// Kompiliert eine vorverarbeitete Schematron-Datei (Includes eingebettet, abstrakte
/// Muster instanziiert — siehe `scripts/schematron-vorverarbeiten.py`).
pub fn kompiliere(pfad: &'static str) -> Result<Kompiliert, Fehler> {
    let text =
        artefakte::finde(pfad).ok_or_else(|| Fehler::Engine(format!("Artefakt fehlt: {pfad}")))?;
    let schema =
        Schematron::compile(text, None).map_err(|e| Fehler::Engine(format!("{pfad}: {e}")))?;
    Ok(Kompiliert { pfad, schema })
}

impl Kompiliert {
    /// Prueft den Baum; liefert Befunde direkt aus dem Report (kein SVRL-Text noetig).
    pub fn befunde(
        &self,
        baum: &Tree,
        ohne_flag: Stufe,
        mit_reports: bool,
    ) -> Result<Vec<Befund>, Fehler> {
        let report = self
            .schema
            .validate_tree(baum)
            .map_err(|e| Fehler::Engine(format!("{}: {e}", self.pfad)))?;
        let quelle = self.pfad.rsplit('/').next().unwrap_or(self.pfad);
        Ok(report
            .checks()
            .filter(|c| mit_reports || c.outcome == CheckOutcome::FailedAssert)
            .map(|c| {
                let flag = c.flag.clone().unwrap_or_default();
                Befund {
                    regel: c.id.clone().unwrap_or_default(),
                    stufe: Stufe::aus_flag(&flag, ohne_flag),
                    flag,
                    ort: c.location.clone(),
                    text: c.message.trim().to_string(),
                    quelle: quelle.to_string(),
                }
            })
            .collect())
    }
}
