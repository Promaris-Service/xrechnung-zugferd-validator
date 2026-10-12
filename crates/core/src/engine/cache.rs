//! Kompilierte Artefakte vorhalten. Siehe cache.md.
//!
//! Stylesheets (XSLT) und Schematrons sind `Send + Sync` und werden **prozessweit einmal**
//! kompiliert und per `Arc` an alle Threads/Validatoren geteilt — bei Batch-Laeufen spart
//! das den Speicher von N-1 Kopien und die wiederholte Kompilierung. Das XSD-`Schema` ist
//! nicht `Send` (haelt tief in `oxixml-regex` ein `Rc`) und bleibt daher pro
//! Validator-Exemplar (ein Cache je Thread).

use super::{schema, schematron, stylesheet};
use crate::fehler::Fehler;
use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;
use std::sync::{Arc, OnceLock, RwLock};

type Geteilt<K> = OnceLock<RwLock<HashMap<&'static str, Arc<K>>>>;

/// Prozessweit geteilte, einmal kompilierte XSLT-Stylesheets.
static STYLESHEETS: Geteilt<stylesheet::Kompiliert> = OnceLock::new();
/// Prozessweit geteilte, einmal kompilierte Schematron-Artefakte.
static SCHEMATRONS: Geteilt<schematron::Kompiliert> = OnceLock::new();

/// Aus dem geteilten Cache holen oder (genau einmal) kompilieren.
fn geteilt_holen<K>(
    geteilt: &Geteilt<K>,
    pfad: &'static str,
    kompiliere: impl FnOnce(&'static str) -> Result<K, Fehler>,
) -> Result<Arc<K>, Fehler> {
    let map = geteilt.get_or_init(|| RwLock::new(HashMap::new()));
    if let Some(s) = map.read().unwrap().get(pfad) {
        return Ok(Arc::clone(s));
    }
    // Unter Write-Lock mit Double-Check kompilieren: so entsteht je Artefakt GENAU EINE
    // Kompilierung statt einer je Thread (kein Thundering-Herd beim Batch-Start). Da das
    // nur den einmaligen Kaltstart serialisiert und der Dauerbetrieb reine Lese-Locks
    // nutzt, ist der Gesamtaufwand deutlich geringer.
    let mut w = map.write().unwrap();
    if let Some(s) = w.get(pfad) {
        return Ok(Arc::clone(s));
    }
    let s = Arc::new(kompiliere(pfad)?);
    w.insert(pfad, Arc::clone(&s));
    Ok(s)
}

/// Haelt die per-Thread-Artefakte (XSD); XSLT/Schematron liegen prozessweit geteilt.
#[derive(Default)]
pub struct Cache {
    schemata: RefCell<HashMap<&'static str, Rc<schema::Kompiliert>>>,
}

impl Cache {
    pub fn stylesheet(&self, pfad: &'static str) -> Result<Arc<stylesheet::Kompiliert>, Fehler> {
        geteilt_holen(&STYLESHEETS, pfad, stylesheet::kompiliere)
    }

    pub fn schematron(&self, pfad: &'static str) -> Result<Arc<schematron::Kompiliert>, Fehler> {
        geteilt_holen(&SCHEMATRONS, pfad, schematron::kompiliere)
    }

    pub fn schema(&self, pfad: &'static str) -> Result<Rc<schema::Kompiliert>, Fehler> {
        if let Some(s) = self.schemata.borrow().get(pfad) {
            return Ok(Rc::clone(s));
        }
        let s = Rc::new(schema::kompiliere(pfad)?);
        self.schemata.borrow_mut().insert(pfad, Rc::clone(&s));
        Ok(s)
    }

    /// Kompiliert die genannten Artefakte im Voraus (fuer Dienste, die Latenz beim ersten
    /// Beleg vermeiden wollen). XSLT/Schematron landen im geteilten, XSD im lokalen Cache.
    pub fn vorwaermen(
        &self,
        stylesheets: &[&'static str],
        schemata: &[&'static str],
    ) -> Result<(), Fehler> {
        for p in stylesheets {
            if p.ends_with(".sch") {
                self.schematron(p)?;
            } else {
                self.stylesheet(p)?;
            }
        }
        for p in schemata {
            self.schema(p)?;
        }
        Ok(())
    }
}
