//! Belege verteilen und pruefen. Siehe lauf.md.

use crate::aufruf::{self, Ausgabe, Optionen, Werkzeug};
use erechnung_validator::{Bericht, Fehler, Validator};
use std::path::{Path, PathBuf};

/// Prueft alle Belege; liefert `true`, wenn jeder Bericht angenommen wurde.
pub fn starte(o: Optionen) -> Result<bool, String> {
    let dateien = aufruf::dateien(&o.pfade);
    if dateien.is_empty() {
        return Err("keine XML-Dateien gefunden".into());
    }
    let threads = worker(o.threads, dateien.len());
    let zeilen = verteile(&o, dateien, threads);
    // Gepufferte Ausgabe: bei grossen Batches spart ein einziger Lock + Puffer gegenueber
    // `println!` je Zeile (das jedes Mal sperrt und spuelt) spuerbar Zeit.
    use std::io::Write;
    let stdout = std::io::stdout();
    let mut aus = std::io::BufWriter::new(stdout.lock());
    let mut alle = true;
    for (zeile, angenommen) in zeilen {
        let _ = writeln!(aus, "{zeile}");
        alle &= angenommen;
    }
    let _ = aus.flush();
    Ok(alle)
}

#[cfg(target_family = "wasm")]
fn worker(_gewuenscht: usize, _n: usize) -> usize {
    1
}

#[cfg(not(target_family = "wasm"))]
fn worker(gewuenscht: usize, n: usize) -> usize {
    let kerne = std::thread::available_parallelism()
        .map(|k| k.get())
        .unwrap_or(1);
    let t = if gewuenscht == 0 { kerne } else { gewuenscht };
    t.clamp(1, n.max(1))
}

/// Ein Beleg mit einem Validator: Zeilen (JSON oder kurz) und ob alles angenommen wurde.
fn pruefe(v: &Validator, o: &Optionen, pfad: &Path) -> Vec<(String, bool)> {
    let name = pfad.display().to_string();
    let xml = match std::fs::read_to_string(pfad) {
        Ok(x) => x,
        Err(e) => return vec![(zeile_fehler(o, &name, "lesen", &e.to_string()), false)],
    };
    let ergebnisse: Vec<(&str, Result<Bericht, Fehler>)> = match o.werkzeug {
        Werkzeug::Kosit => vec![("kosit", v.kosit(&xml, o.szenarien))],
        Werkzeug::Mustang => vec![("mustang", v.mustang(&xml))],
        Werkzeug::Beide => match v.beide(&xml, o.szenarien) {
            Ok((k, m)) => vec![("kosit", k), ("mustang", m)],
            Err(e) => vec![("kosit", Err(e.clone())), ("mustang", Err(e))],
        },
    };
    ergebnisse
        .into_iter()
        .map(|(w, r)| match r {
            Ok(b) => (zeile(o, &name, &b), b.angenommen),
            Err(e) => (zeile_fehler(o, &name, w, &e.to_string()), false),
        })
        .collect()
}

fn zeile(o: &Optionen, name: &str, b: &Bericht) -> String {
    match o.ausgabe {
        Ausgabe::Json => format!(
            "{{\"datei\":{},\"bericht\":{}}}",
            serde_json::to_string(name).unwrap_or_default(),
            b.json()
        ),
        Ausgabe::Kurz => {
            let fehler = b
                .fehler()
                .map(|f| f.regel.as_str())
                .collect::<Vec<_>>()
                .join(",");
            let warnungen = b.warnungen().count();
            format!(
                "{name}\t{:?}\t{}\txsd={}\tangenommen={}\tfehler=[{fehler}]\twarnungen={warnungen}\t{}ms",
                b.werkzeug, b.szenario, b.xsd_gueltig, b.angenommen, b.dauer_ms
            )
        }
    }
}

fn zeile_fehler(o: &Optionen, name: &str, werkzeug: &str, m: &str) -> String {
    match o.ausgabe {
        Ausgabe::Json => format!(
            "{{\"datei\":{},\"werkzeug\":{},\"fehler\":{}}}",
            serde_json::to_string(name).unwrap_or_default(),
            serde_json::to_string(werkzeug).unwrap_or_default(),
            serde_json::to_string(m).unwrap_or_default()
        ),
        Ausgabe::Kurz => format!("{name}\t{werkzeug}\tFEHLER\t{m}"),
    }
}

#[cfg(target_family = "wasm")]
fn verteile(o: &Optionen, dateien: Vec<PathBuf>, _threads: usize) -> Vec<(String, bool)> {
    let v = Validator::new();
    dateien.iter().flat_map(|p| pruefe(&v, o, p)).collect()
}

/// Nativ: N Worker, jeder mit eigenem Validator und 64-MiB-Stack, Dateien im Reissverschluss.
#[cfg(not(target_family = "wasm"))]
fn verteile(o: &Optionen, dateien: Vec<PathBuf>, threads: usize) -> Vec<(String, bool)> {
    let n = dateien.len();
    let mut ergebnisse: Vec<Option<Vec<(String, bool)>>> = (0..n).map(|_| None).collect();
    std::thread::scope(|sc| {
        let handles: Vec<_> = (0..threads)
            .map(|i| {
                let meine: Vec<(usize, &PathBuf)> = dateien
                    .iter()
                    .enumerate()
                    .skip(i)
                    .step_by(threads)
                    .collect();
                std::thread::Builder::new()
                    .stack_size(erechnung_validator::Validator::STACK_BYTES)
                    .spawn_scoped(sc, move || {
                        let v = Validator::new();
                        meine
                            .into_iter()
                            .map(|(idx, p)| (idx, pruefe(&v, o, p)))
                            .collect::<Vec<_>>()
                    })
                    .expect("Worker-Thread")
            })
            .collect();
        for h in handles {
            for (idx, z) in h.join().expect("Worker beendet") {
                ergebnisse[idx] = Some(z);
            }
        }
    });
    ergebnisse.into_iter().flatten().flatten().collect()
}
