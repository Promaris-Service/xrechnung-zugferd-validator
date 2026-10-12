//! Argumente lesen. Siehe aufruf.md.

use erechnung_validator::Szenarien;
use std::collections::HashSet;
use std::path::PathBuf;

pub const HILFE: &str = "erechnung-validator [--kosit|--mustang|--beide] [--szenarien xrechnung|alle|auto] [--threads N] [--json|--kurz] <datei.xml|verzeichnis>...";

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Werkzeug {
    Kosit,
    Mustang,
    Beide,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Ausgabe {
    Json,
    Kurz,
}

#[derive(Debug)]
pub struct Optionen {
    pub werkzeug: Werkzeug,
    pub szenarien: Szenarien,
    pub threads: usize,
    pub ausgabe: Ausgabe,
    pub pfade: Vec<PathBuf>,
}

pub fn lese(args: impl Iterator<Item = String>) -> Result<Optionen, String> {
    let mut o = Optionen {
        werkzeug: Werkzeug::Beide,
        szenarien: Szenarien::Automatisch,
        threads: 0,
        ausgabe: Ausgabe::Json,
        pfade: Vec::new(),
    };
    let mut args = args.peekable();
    while let Some(a) = args.next() {
        match a.as_str() {
            "--kosit" => o.werkzeug = Werkzeug::Kosit,
            "--mustang" => o.werkzeug = Werkzeug::Mustang,
            "--beide" => o.werkzeug = Werkzeug::Beide,
            "--json" => o.ausgabe = Ausgabe::Json,
            "--kurz" => o.ausgabe = Ausgabe::Kurz,
            "--szenarien" => {
                o.szenarien = match args.next().as_deref() {
                    Some("xrechnung") => Szenarien::XRechnung302,
                    Some("alle") => Szenarien::En16931Alle,
                    Some("auto") => Szenarien::Automatisch,
                    other => return Err(format!("--szenarien: unbekannt {other:?}")),
                }
            }
            "--threads" => {
                o.threads = args
                    .next()
                    .and_then(|n| n.parse().ok())
                    .ok_or("--threads braucht eine Zahl")?;
            }
            "--" => {
                // Ende der Optionen: alles Weitere sind Pfade (auch mit `--`-Praefix).
                for rest in args.by_ref() {
                    o.pfade.push(PathBuf::from(rest));
                }
            }
            "-h" | "--help" => return Err(String::new()),
            p if p.starts_with("--") => return Err(format!("unbekannte Option {p}")),
            p => o.pfade.push(PathBuf::from(p)),
        }
    }
    if o.pfade.is_empty() {
        return Err("mindestens eine Datei oder ein Verzeichnis angeben".into());
    }
    Ok(o)
}

/// Alle XML-Dateien hinter den Pfaden (Verzeichnisse rekursiv), sortiert.
pub fn dateien(pfade: &[PathBuf]) -> Vec<PathBuf> {
    fn sammle(p: &PathBuf, out: &mut Vec<PathBuf>, besucht: &mut HashSet<PathBuf>) {
        if p.is_dir() {
            // Symlink-Zyklen abfangen: jeden Ordner (kanonisch) nur einmal betreten,
            // sonst fuehrt ein Link auf einen Vorfahren zu endloser Rekursion.
            let kanon = std::fs::canonicalize(p).unwrap_or_else(|_| p.clone());
            if !besucht.insert(kanon) {
                return;
            }
            if let Ok(rd) = std::fs::read_dir(p) {
                for e in rd.flatten() {
                    sammle(&e.path(), out, besucht);
                }
            }
        } else if p
            .extension()
            .map(|x| x.eq_ignore_ascii_case("xml"))
            .unwrap_or(false)
        {
            out.push(p.clone());
        }
    }
    let mut out = Vec::new();
    let mut besucht = HashSet::new();
    for p in pfade {
        sammle(p, &mut out, &mut besucht);
    }
    out.sort();
    out
}
