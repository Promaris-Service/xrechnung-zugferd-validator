//! Regressionstest gegen einen echten Bestand mit KoSIT-Referenz. Laeuft nur, wenn
//!   ERECHNUNG_BESTAND=<Verzeichnis mit *.xml>
//!   ERECHNUNG_KOSIT_CODES=<TSV: stamm \t xsd-urteil \t code/level,...>
//! gesetzt sind (Kundenbelege gehoeren nicht ins Repo). Erwartung: identische Regel-IDs
//! und Stufen je Beleg (fatal wird auf error abgebildet, wie KoSITs Report es tut).

use erechnung_validator::{Stufe, Szenarien, Validator};
use std::collections::BTreeMap;

#[test]
fn bestand_identisch_mit_kosit() {
    let (Ok(dir), Ok(tsv)) = (
        std::env::var("ERECHNUNG_BESTAND"),
        std::env::var("ERECHNUNG_KOSIT_CODES"),
    ) else {
        eprintln!("uebersprungen: ERECHNUNG_BESTAND / ERECHNUNG_KOSIT_CODES nicht gesetzt");
        return;
    };
    let referenz: BTreeMap<String, String> = std::fs::read_to_string(&tsv)
        .unwrap()
        .lines()
        .filter_map(|l| {
            let mut t = l.split('\t');
            Some((t.next()?.to_string(), t.nth(1).unwrap_or("").to_string()))
        })
        .collect();
    let ergebnis = std::thread::Builder::new()
        .stack_size(Validator::STACK_BYTES)
        .spawn(move || {
            let v = Validator::new();
            let mut abweichungen = Vec::new();
            let mut n = 0;
            for (stamm, erwartet) in &referenz {
                let pfad = format!("{dir}/{stamm}.xml");
                let Ok(xml) = std::fs::read_to_string(&pfad) else {
                    continue;
                };
                n += 1;
                let b = v.kosit(&xml, Szenarien::En16931Alle).unwrap();
                let mut codes: Vec<String> = b
                    .befunde
                    .iter()
                    .map(|f| {
                        let stufe = match f.stufe {
                            Stufe::Fehler => "error",
                            Stufe::Warnung => "warning",
                            Stufe::Information => "information",
                        };
                        format!("{}/{stufe}", f.regel)
                    })
                    .collect();
                codes.sort();
                let ist = codes.join(",");
                if &ist != erwartet {
                    abweichungen.push(format!("{stamm}\n  kosit: {erwartet}\n  rust:  {ist}"));
                }
            }
            (n, abweichungen)
        })
        .unwrap()
        .join()
        .unwrap();
    let (n, abweichungen) = ergebnis;
    assert!(n > 0, "keine Belege gefunden");
    assert!(
        abweichungen.is_empty(),
        "{} von {n} Belegen weichen ab:\n{}",
        abweichungen.len(),
        abweichungen.join("\n")
    );
}
