//! Ablauf: XSD -> zaehlende XSLTs -> Hinweis-XSLTs -> Urteil. Siehe pruefung.md.
//! Nur `failed-assert` zaehlt (wie Mustang), `successful-report` nicht.

use super::profil;
use crate::bericht::{Bericht, Stufe, Werkzeug};
use crate::engine::{cache::Cache, dokument::Dokument};
use crate::fehler::Fehler;
use crate::svrl;
use std::time::Instant;

pub fn pruefe(cache: &Cache, stack_bytes: usize, dok: &Dokument) -> Result<Bericht, Fehler> {
    let start = Instant::now();
    let w = profil::waehle(dok.syntax, &dok.kennung)?;
    let (xsd_gueltig, xsd_fehler) = cache.schema(w.xsd)?.pruefe(dok.xml);
    let mut befunde = Vec::new();
    // Mustang fuehrt das Schematron auch nach XSD-Fehlern aus (getrennte Abschnitte im Report).
    for (kette, hinweis) in [(w.xslt, false), (w.hinweise, true)] {
        for pfad in kette {
            let roh = if pfad.ends_with(".sch") {
                cache
                    .schematron(pfad)?
                    .befunde(&dok.baum, Stufe::Fehler, false)?
            } else {
                let ausgabe = cache.stylesheet(pfad)?.svrl(&dok.baum, stack_bytes)?;
                svrl::befunde(
                    &ausgabe,
                    pfad.rsplit('/').next().unwrap_or(pfad),
                    Stufe::Fehler,
                    false,
                )?
            };
            for mut b in roh {
                if hinweis {
                    b.stufe = Stufe::Information;
                }
                befunde.push(b);
            }
        }
    }
    let angenommen = xsd_gueltig && befunde.iter().all(|b| b.stufe != Stufe::Fehler);
    Ok(Bericht {
        werkzeug: Werkzeug::Mustang,
        szenario: w.name.to_string(),
        syntax: dok.syntax,
        kennung: dok.kennung.clone(),
        xsd_gueltig,
        xsd_fehler,
        befunde,
        angenommen,
        dauer_ms: start.elapsed().as_millis() as u64,
        artefakte: crate::ARTEFAKTE.to_string(),
    })
}
