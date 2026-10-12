//! customLevel aus scenarios.xml: Regel-ID -> Stufe je Szenario. Siehe stufen.md.

use crate::artefakte;
use crate::bericht::Stufe;
use std::collections::HashMap;

/// Stufenabbildung je Szenarioname, einmal aus der eingebetteten Szenariendatei gelesen.
#[derive(Debug, Default)]
pub struct Stufen {
    je_szenario: HashMap<String, HashMap<String, Stufe>>,
}

impl Stufen {
    pub fn laden() -> Stufen {
        let mut je_szenario = HashMap::new();
        let Some(text) = artefakte::finde("kosit/scenarios-xrechnung-3.0.2.xml") else {
            return Stufen::default();
        };
        let Ok(dok) = roxmltree::Document::parse(text) else {
            return Stufen::default();
        };
        for sz in dok
            .descendants()
            .filter(|n| n.is_element() && n.tag_name().name() == "scenario")
        {
            let name = sz
                .children()
                .find(|c| c.is_element() && c.tag_name().name() == "name")
                .and_then(|c| c.text())
                .unwrap_or("")
                .trim()
                .to_string();
            let mut tabelle = HashMap::new();
            for cl in sz
                .descendants()
                .filter(|n| n.is_element() && n.tag_name().name() == "customLevel")
            {
                let stufe = Stufe::aus_flag(cl.attribute("level").unwrap_or(""), Stufe::Fehler);
                for regel in cl.text().unwrap_or("").split_whitespace() {
                    tabelle.insert(regel.to_string(), stufe);
                }
            }
            je_szenario.insert(name, tabelle);
        }
        Stufen { je_szenario }
    }

    /// Stufe fuer `regel` im Szenario, falls ein customLevel greift.
    pub fn stufe(&self, szenario: &str, regel: &str) -> Option<Stufe> {
        self.je_szenario.get(szenario)?.get(regel).copied()
    }

    #[cfg(test)]
    pub fn anzahl(&self, szenario: &str) -> usize {
        self.je_szenario.get(szenario).map(|t| t.len()).unwrap_or(0)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn liest_customlevel_der_offiziellen_konfiguration() {
        let s = Stufen::laden();
        assert_eq!(s.anzahl("EN16931 XRechnung (CII)"), 9); // KoSIT 2026-08-31: 9 customLevel
        assert_eq!(
            s.stufe("EN16931 XRechnung (UBL Invoice)", "BR-CL-23"),
            Some(Stufe::Warnung)
        );
        assert_eq!(s.stufe("EN16931 (CII)", "BR-CL-23"), None);
    }
}
