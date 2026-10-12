//! Kommandozeile. Nativ: alle Kerne, ein Validator je Worker mit grossem Stack.
//! Als WASI-Command-Component (wasm32-wasip2): ein Thread, gleiche Ausgabe.
//!
//! Aufruf:  erechnung-validator [--kosit|--mustang|--beide] [--szenarien xrechnung|alle|auto]
//!                              [--threads N] [--json|--kurz] <datei.xml|verzeichnis>...
//! Ausgabe: eine JSON-Zeile je Beleg und Werkzeug (--json, Standard) oder eine Kurzzeile.
//! Rueckgabe: 0 wenn alle Belege angenommen, 1 sonst, 2 bei Aufruffehlern.

#[cfg(not(target_family = "wasm"))]
#[global_allocator]
static GLOBAL: mimalloc::MiMalloc = mimalloc::MiMalloc;

mod aufruf;
mod lauf;

fn main() {
    let optionen = match aufruf::lese(std::env::args().skip(1)) {
        Ok(o) => o,
        Err(m) => {
            eprintln!("{m}\n{}", aufruf::HILFE);
            std::process::exit(2);
        }
    };
    match lauf::starte(optionen) {
        Ok(alle_angenommen) => std::process::exit(if alle_angenommen { 0 } else { 1 }),
        Err(m) => {
            eprintln!("{m}");
            std::process::exit(2);
        }
    }
}
