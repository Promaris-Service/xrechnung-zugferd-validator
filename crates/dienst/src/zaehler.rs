//! Nutzungszaehler. Siehe zaehler.md.
//!
//! Zaehlt abgeschlossene Validierungen — **nur eine Zahl**, kein Beleg, keine Payload.
//! Persistiert (falls `ERECHNUNG_COUNTER_FILE` gesetzt) in eine Datei, damit der Stand
//! einen Neustart ueberlebt. Abrufbar ueber `GET /count` am Loopback-Dienst und daher
//! nicht oeffentlich.

use std::path::PathBuf;
use std::sync::Mutex;
use std::sync::atomic::{AtomicU64, Ordering};
use std::time::{SystemTime, UNIX_EPOCH};

/// Thread-sicherer Zaehler mit optionaler Datei-Persistenz.
pub struct Zaehler {
    stand: AtomicU64,
    datei: Option<Mutex<PathBuf>>,
    seit_epoch: u64,
}

fn jetzt_epoch() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|d| d.as_secs())
        .unwrap_or(0)
}

impl Zaehler {
    /// Beginnt bei 0 oder laedt den Stand aus `datei` (Zeile 1 = Zahl, Zeile 2 = Startzeit).
    pub fn neu(datei: Option<String>) -> Self {
        let mut stand = 0u64;
        let mut seit = jetzt_epoch();
        if let Some(p) = &datei {
            if let Ok(t) = std::fs::read_to_string(p) {
                let mut z = t.lines();
                stand = z.next().and_then(|s| s.trim().parse().ok()).unwrap_or(0);
                seit = z.next().and_then(|s| s.trim().parse().ok()).unwrap_or(seit);
            }
        }
        Zaehler {
            stand: AtomicU64::new(stand),
            datei: datei.map(|p| Mutex::new(PathBuf::from(p))),
            seit_epoch: seit,
        }
    }

    /// Eine abgeschlossene Validierung dazuzaehlen und (falls konfiguriert) persistieren.
    /// Der Dateiwert wird UNTER dem Lock aus dem aktuellen Atomic gelesen -> monoton,
    /// auch bei nebenlaeufigen Workern.
    pub fn plus(&self) {
        self.stand.fetch_add(1, Ordering::Relaxed);
        if let Some(m) = &self.datei {
            if let Ok(p) = m.lock() {
                let n = self.stand.load(Ordering::Relaxed);
                let _ = std::fs::write(&*p, format!("{n}\n{}\n", self.seit_epoch));
            }
        }
    }

    /// Aktueller Stand als JSON (`gesamt`, `seit_epoch`, `persistent`).
    pub fn json(&self) -> String {
        format!(
            "{{\"gesamt\":{},\"seit_epoch\":{},\"persistent\":{}}}",
            self.stand.load(Ordering::Relaxed),
            self.seit_epoch,
            self.datei.is_some()
        )
    }
}
