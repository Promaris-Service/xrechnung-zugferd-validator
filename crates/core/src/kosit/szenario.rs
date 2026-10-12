//! Szenarienwahl nach Syntax und Kennung. Siehe szenario.md.

use crate::bericht::Syntax;

/// Welche Szenariendatei gilt.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum Szenarien {
    /// Offizielle KoSIT-Konfiguration XRechnung 3.0.2: nur exakte CustomizationIDs
    /// (XRechnung 3.0, Extension, CVD, reines EN16931). Alles andere: kein Szenario.
    XRechnung302,
    /// Promaris-Szenarien: EN16931-Regeln fuer jeden CII-/UBL-Beleg, gleich welches Profil.
    En16931Alle,
    /// Erst offiziell, bei „kein Szenario" die EN16931-Regeln (Standard).
    #[default]
    Automatisch,
}

/// Ein aufgeloestes Szenario: Name, XSD, Pruefkette (`.sch` direkt oder `.xsl`), Schluessel fuer customLevel.
pub struct Szenario {
    pub name: &'static str,
    pub xsd: &'static str,
    pub xslt: &'static [&'static str],
    /// Szenarioname in `scenarios-xrechnung-3.0.2.xml` fuer die customLevel-Tabelle, oder None.
    pub stufen: Option<&'static str>,
}

const XSD_CII: &str = "kosit/cii/CrossIndustryInvoice_100pD16B.xsd";
const XSD_INV: &str = "kosit/ubl/maindoc/UBL-Invoice-2.1.xsd";
const XSD_CN: &str = "kosit/ubl/maindoc/UBL-CreditNote-2.1.xsd";
// EN 16931 als Schematron-Quelle (CEN 1.3.16, vorverarbeitet): doppelt so schnell wie KoSITs
// kompilierte XSLTs bei identischen Befunden; die XSLTs bleiben als Referenz im Artefaktbestand.
const EN_CII: &str = "kosit/cen/EN16931-CII-validation-1.3.16.sch";
const EN_UBL: &str = "kosit/cen/EN16931-UBL-validation-1.3.16.sch";
const XR_CII: &str = "kosit/xrechnung/XRechnung-CII-validation.xsl";
const XR_UBL: &str = "kosit/xrechnung/XRechnung-UBL-validation.xsl";

const ID_EN: &str = "urn:cen.eu:en16931:2017";
const ID_XR: &str = "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0";
const ID_XR_EXT: &str = "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_3.0";
const ID_XR_CVD: &str = "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0#compliant#urn:xeinkauf.de:kosit:xrechnung:cvd_0.9";

/// Alle Artefaktpfade (fuer `vorwaermen`).
pub const ALLE_XSLT: &[&str] = &[EN_CII, EN_UBL, XR_CII, XR_UBL];
pub const ALLE_XSD: &[&str] = &[XSD_CII, XSD_INV, XSD_CN];

fn offiziell(syntax: Syntax, kennung: &str) -> Option<Szenario> {
    let xsd = match syntax {
        Syntax::Cii => XSD_CII,
        Syntax::UblInvoice => XSD_INV,
        Syntax::UblCreditNote => XSD_CN,
    };
    // Die Namen entsprechen wörtlich den <name>-Elementen in scenarios-xrechnung-3.0.2.xml.
    let (name, xslt): (&'static str, &'static [&'static str]) = match (kennung, syntax) {
        (ID_EN, Syntax::Cii) => ("EN16931 (CII)", &[EN_CII]),
        (ID_EN, Syntax::UblInvoice) => ("EN16931 (UBL Invoice)", &[EN_UBL]),
        (ID_EN, Syntax::UblCreditNote) => ("EN16931 (UBL CreditNote)", &[EN_UBL]),
        (ID_XR, Syntax::Cii) => ("EN16931 XRechnung (CII)", &[EN_CII, XR_CII]),
        (ID_XR, Syntax::UblInvoice) => ("EN16931 XRechnung (UBL Invoice)", &[EN_UBL, XR_UBL]),
        (ID_XR, Syntax::UblCreditNote) => ("EN16931 XRechnung (UBL CreditNote)", &[EN_UBL, XR_UBL]),
        (ID_XR_EXT, Syntax::Cii) => ("EN16931 XRechnung Extension (CII)", &[EN_CII, XR_CII]),
        (ID_XR_EXT, Syntax::UblInvoice) => (
            "EN16931 XRechnung Extension (UBL Invoice)",
            &[EN_UBL, XR_UBL],
        ),
        (ID_XR_CVD, Syntax::Cii) => ("EN16931 XRechnung CVD (CII)", &[EN_CII, XR_CII]),
        (ID_XR_CVD, Syntax::UblInvoice) => {
            ("EN16931 XRechnung CVD (UBL Invoice)", &[EN_UBL, XR_UBL])
        }
        (ID_XR_CVD, Syntax::UblCreditNote) => {
            ("EN16931 XRechnung CVD (UBL CreditNote)", &[EN_UBL, XR_UBL])
        }
        _ => return None,
    };
    Some(Szenario {
        name,
        xsd,
        xslt,
        stufen: Some(name),
    })
}

fn alle(syntax: Syntax) -> Szenario {
    match syntax {
        Syntax::Cii => Szenario {
            name: "EN16931 (CII, beliebiges Profil)",
            xsd: XSD_CII,
            xslt: &[EN_CII],
            stufen: None,
        },
        Syntax::UblInvoice => Szenario {
            name: "EN16931 (UBL Invoice, beliebiges Profil)",
            xsd: XSD_INV,
            xslt: &[EN_UBL],
            stufen: None,
        },
        Syntax::UblCreditNote => Szenario {
            name: "EN16931 (UBL CreditNote, beliebiges Profil)",
            xsd: XSD_CN,
            xslt: &[EN_UBL],
            stufen: None,
        },
    }
}

pub fn waehle(modus: Szenarien, syntax: Syntax, kennung: &str) -> Option<Szenario> {
    match modus {
        Szenarien::XRechnung302 => offiziell(syntax, kennung),
        Szenarien::En16931Alle => Some(alle(syntax)),
        Szenarien::Automatisch => offiziell(syntax, kennung).or_else(|| Some(alle(syntax))),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn xrechnung_cii_bekommt_beide_xslt() {
        let s = waehle(Szenarien::XRechnung302, Syntax::Cii, ID_XR).unwrap();
        assert_eq!(s.xslt, &[EN_CII, XR_CII]);
    }

    #[test]
    fn facturx_offiziell_ohne_szenario_automatisch_mit() {
        let id = "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended";
        assert!(waehle(Szenarien::XRechnung302, Syntax::Cii, id).is_none());
        assert_eq!(
            waehle(Szenarien::Automatisch, Syntax::Cii, id)
                .unwrap()
                .xslt,
            &[EN_CII]
        );
    }
}
