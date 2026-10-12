//! Ablauf: XSD -> Schematron-XSLTs -> Stufen -> Annahme. Siehe pruefung.md.

use super::stufen::Stufen;
use super::szenario::{self, Szenarien};
use crate::bericht::{Bericht, Stufe, Werkzeug};
use crate::engine::{cache::Cache, dokument::Dokument};
use crate::fehler::Fehler;
use crate::svrl;
use std::time::Instant;

pub fn pruefe(
    cache: &Cache,
    stufen: &Stufen,
    stack_bytes: usize,
    dok: &Dokument,
    modus: Szenarien,
) -> Result<Bericht, Fehler> {
    let start = Instant::now();
    let sz = szenario::waehle(modus, dok.syntax, &dok.kennung)
        .ok_or_else(|| Fehler::KeinSzenario(dok.kennung.clone()))?;

    let (xsd_gueltig, xsd_fehler) = cache.schema(sz.xsd)?.pruefe(dok.xml);

    let mut befunde = Vec::new();
    // KoSIT prueft Schematron auch bei XSD-Fehlern nicht weiter; wir halten es genauso.
    if xsd_gueltig {
        for pfad in sz.xslt {
            let roh = if pfad.ends_with(".sch") {
                cache
                    .schematron(pfad)?
                    .befunde(&dok.baum, Stufe::Fehler, true)?
            } else {
                let ausgabe = cache.stylesheet(pfad)?.svrl(&dok.baum, stack_bytes)?;
                svrl::befunde(
                    &ausgabe,
                    pfad.rsplit('/').next().unwrap_or(pfad),
                    Stufe::Fehler,
                    true,
                )?
            };
            for mut b in roh {
                if let Some(s) = sz.stufen.and_then(|name| stufen.stufe(name, &b.regel)) {
                    b.stufe = s;
                }
                befunde.push(b);
            }
        }
    }
    let angenommen = xsd_gueltig && befunde.iter().all(|b| b.stufe != Stufe::Fehler);
    Ok(Bericht {
        werkzeug: Werkzeug::Kosit,
        szenario: sz.name.to_string(),
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
