//! Profil aus der Guideline-ID; XSD und XSLT-Ketten je Profil. Siehe profil.md.

use crate::bericht::Syntax;
use crate::fehler::Fehler;

/// Was Mustang fuer einen Beleg ausfuehrt.
pub struct Werkzeuge {
    pub name: &'static str,
    pub xsd: &'static str,
    /// Schematron-XSLTs, deren Befunde zaehlen (Mustang: `ESeverity.error`).
    pub xslt: &'static [&'static str],
    /// Schematron-XSLTs, deren Befunde nur Hinweise sind (Mustang: `ESeverity.notice`).
    pub hinweise: &'static [&'static str],
}

const XR_CII: &str = "mustang/xr/XR_30/XRechnung-CII-validation.xslt";
const XR_UBL: &str = "mustang/xr/XR_30/XRechnung-UBL-validation.xslt";
/// Aeltere XRechnung-Fassungen, wie `validateXR` sie an der Kennung erkennt.
const XR_ALT: &[(&str, &str, &str)] = &[
    (
        ":xrechnung_1.",
        "mustang/xr/XR_12/XRechnung-CII-validation.xslt",
        "mustang/xr/XR_12/XRechnung-UBL-validation.xslt",
    ),
    (
        ":xrechnung_2.0",
        "mustang/xr/XR_20/XRechnung-CII-validation.xslt",
        "mustang/xr/XR_20/XRechnung-UBL-validation.xslt",
    ),
    (
        ":xrechnung_2.1",
        "mustang/xr/XR_21/XRechnung-CII-validation.xslt",
        "mustang/xr/XR_21/XRechnung-UBL-validation.xslt",
    ),
    (
        ":xrechnung_2.2",
        "mustang/xr/XR_22/XRechnung-CII-validation.xslt",
        "mustang/xr/XR_22/XRechnung-UBL-validation.xslt",
    ),
    (
        ":xrechnung_2.3",
        "mustang/xr/XR_23/XRechnung-CII-validation.xslt",
        "mustang/xr/XR_23/XRechnung-UBL-validation.xslt",
    ),
];

/// XRechnung-XSLT (CII, UBL) fuer die Kennung; Standard ist 3.0 wie in Mustang.
fn xr_fassung(k: &str) -> (&'static str, &'static str) {
    XR_ALT
        .iter()
        .find(|(m, _, _)| k.contains(m))
        .map(|(_, c, u)| (*c, *u))
        .unwrap_or((XR_CII, XR_UBL))
}
const EN_UBL: &str = "mustang/ubl/EN16931-UBL-validation.xslt";
const CEN_CII: &str = "mustang/cii/EN16931-CII-validation.xslt";
const XSD_INV: &str = "kosit/ubl/maindoc/UBL-Invoice-2.1.xsd";
const XSD_CN: &str = "kosit/ubl/maindoc/UBL-CreditNote-2.1.xsd";

// Factur-X-Schematron als Quelle mit eingesetzten Codelisten (`scripts/facturx-codelisten-einsetzen.py`):
// siebenmal schneller als Mustangs kompilierte XSLTs bei identischen Befunden (219/219 Belege).
macro_rules! fx {
    ($p:literal) => {
        (
            concat!("mustang/schema/", $p, "/FACTUR-X_", $p, ".xsd"),
            concat!("mustang/sch/FACTUR-X_", $p, ".sch"),
        )
    };
}
const MINIMUM: (&str, &str) = fx!("MINIMUM");
const BASIC_WL: (&str, &str) = fx!("BASIC-WL");
const BASIC: (&str, &str) = fx!("BASIC");
const EN16931: (&str, &str) = fx!("EN16931");
const EXTENDED: (&str, &str) = fx!("EXTENDED");

pub const ALLE_XSLT: &[&str] = &[
    MINIMUM.1, BASIC_WL.1, BASIC.1, EN16931.1, EXTENDED.1, CEN_CII, XR_CII, XR_UBL, EN_UBL,
];
/// Aeltere XRechnung-XSLTs werden nicht vorgewaermt (selten, je 0,3 s bei Bedarf).
pub const ALLE_XSD: &[&str] = &[
    MINIMUM.0, BASIC_WL.0, BASIC.0, EN16931.0, EXTENDED.0, XSD_INV, XSD_CN,
];

/// Profilwahl wie `XMLValidator.validate` (Mustang 2.24): Guideline-ID (CII) bzw. CustomizationID (UBL).
pub fn waehle(syntax: Syntax, kennung: &str) -> Result<Werkzeuge, Fehler> {
    let k = kennung.to_ascii_lowercase();
    let xrechnung = k.contains("xrechnung");
    let (xr_cii, xr_ubl) = xr_fassung(&k);
    if syntax != Syntax::Cii {
        let xsd = if syntax == Syntax::UblCreditNote {
            XSD_CN
        } else {
            XSD_INV
        };
        return Ok(if xrechnung {
            Werkzeuge {
                name: "XRECHNUNG (UBL)",
                xsd,
                xslt: kette2(EN_UBL, xr_ubl),
                hinweise: &[],
            }
        } else {
            Werkzeuge {
                name: "EN 16931 (UBL)",
                xsd,
                xslt: &[EN_UBL],
                hinweise: &[],
            }
        });
    }
    if k.contains("zugferd:1p0") || k.contains("ferd:crossindustrydocument") {
        return Err(Fehler::UnbekanntesProfil(kennung.to_string()));
    }
    if xrechnung {
        // Kein Factur-X-Hauptschematron: CEN-Regeln plus XRechnung-Regeln, beide zaehlen.
        return Ok(Werkzeuge {
            name: "XRECHNUNG",
            xsd: EN16931.0,
            xslt: kette2(CEN_CII, xr_cii),
            hinweise: &[],
        });
    }
    // Reihenfolge ist Logik: `basicwl` enthaelt `basic`.
    let w = if k.contains("factur-x.eu:1p0:minimum") {
        Werkzeuge {
            name: "MINIMUM",
            xsd: MINIMUM.0,
            xslt: &[MINIMUM.1],
            hinweise: &[],
        }
    } else if k.contains("factur-x.eu:1p0:basicwl") {
        Werkzeuge {
            name: "BASIC WL",
            xsd: BASIC_WL.0,
            xslt: &[BASIC_WL.1],
            hinweise: &[],
        }
    } else if k.contains("factur-x.eu:1p0:basic") {
        Werkzeuge {
            name: "BASIC",
            xsd: BASIC.0,
            xslt: &[BASIC.1],
            hinweise: &[XR_CII],
        }
    } else if k.contains("extended") {
        Werkzeuge {
            name: "EXTENDED",
            xsd: EXTENDED.0,
            xslt: &[EXTENDED.1],
            hinweise: &[],
        }
    } else if k.starts_with("urn:cen.eu:en16931:2017") {
        Werkzeuge {
            name: "EN 16931",
            xsd: EN16931.0,
            xslt: &[EN16931.1],
            hinweise: &[XR_CII],
        }
    } else {
        return Err(Fehler::UnbekanntesProfil(kennung.to_string()));
    };
    Ok(w)
}

/// Zweierkette als `&'static` — die Kombinationen sind endlich, also eine Tabelle.
fn kette2(a: &'static str, b: &'static str) -> &'static [&'static str] {
    const PAARE: &[(&str, &str)] = &[
        (CEN_CII, XR_CII),
        (EN_UBL, XR_UBL),
        (CEN_CII, "mustang/xr/XR_12/XRechnung-CII-validation.xslt"),
        (EN_UBL, "mustang/xr/XR_12/XRechnung-UBL-validation.xslt"),
        (CEN_CII, "mustang/xr/XR_20/XRechnung-CII-validation.xslt"),
        (EN_UBL, "mustang/xr/XR_20/XRechnung-UBL-validation.xslt"),
        (CEN_CII, "mustang/xr/XR_21/XRechnung-CII-validation.xslt"),
        (EN_UBL, "mustang/xr/XR_21/XRechnung-UBL-validation.xslt"),
        (CEN_CII, "mustang/xr/XR_22/XRechnung-CII-validation.xslt"),
        (EN_UBL, "mustang/xr/XR_22/XRechnung-UBL-validation.xslt"),
        (CEN_CII, "mustang/xr/XR_23/XRechnung-CII-validation.xslt"),
        (EN_UBL, "mustang/xr/XR_23/XRechnung-UBL-validation.xslt"),
    ];
    // Zwei Slices aus einem Paar: das Paar liegt im statischen Speicher, `std::slice::from_ref`
    // reicht nicht fuer zwei Elemente, daher die Tabelle mit festen Arrays.
    static KETTEN: [[&str; 2]; 12] = [
        [CEN_CII, XR_CII],
        [EN_UBL, XR_UBL],
        [CEN_CII, "mustang/xr/XR_12/XRechnung-CII-validation.xslt"],
        [EN_UBL, "mustang/xr/XR_12/XRechnung-UBL-validation.xslt"],
        [CEN_CII, "mustang/xr/XR_20/XRechnung-CII-validation.xslt"],
        [EN_UBL, "mustang/xr/XR_20/XRechnung-UBL-validation.xslt"],
        [CEN_CII, "mustang/xr/XR_21/XRechnung-CII-validation.xslt"],
        [EN_UBL, "mustang/xr/XR_21/XRechnung-UBL-validation.xslt"],
        [CEN_CII, "mustang/xr/XR_22/XRechnung-CII-validation.xslt"],
        [EN_UBL, "mustang/xr/XR_22/XRechnung-UBL-validation.xslt"],
        [CEN_CII, "mustang/xr/XR_23/XRechnung-CII-validation.xslt"],
        [EN_UBL, "mustang/xr/XR_23/XRechnung-UBL-validation.xslt"],
    ];
    let i = PAARE
        .iter()
        .position(|(x, y)| *x == a && *y == b)
        .expect("bekannte XSLT-Kette");
    &KETTEN[i]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn profile() {
        let w = waehle(
            Syntax::Cii,
            "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended",
        )
        .unwrap();
        assert_eq!(
            (w.name, w.xsd, w.hinweise.len()),
            ("EXTENDED", EXTENDED.0, 0)
        );
        let w = waehle(
            Syntax::Cii,
            "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0",
        )
        .unwrap();
        assert_eq!((w.xsd, w.xslt), (EN16931.0, &[CEN_CII, XR_CII][..]));
        let w = waehle(Syntax::Cii, "urn:cen.eu:en16931:2017").unwrap();
        assert_eq!((w.xslt, w.hinweise), (&[EN16931.1][..], &[XR_CII][..]));
        assert!(
            waehle(
                Syntax::Cii,
                "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"
            )
            .is_err()
        );
        let w = waehle(
            Syntax::Cii,
            "urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_2.2",
        )
        .unwrap();
        assert_eq!(w.xslt[1], "mustang/xr/XR_22/XRechnung-CII-validation.xslt");
        assert_eq!(
            waehle(Syntax::UblCreditNote, "urn:cen.eu:en16931:2017")
                .unwrap()
                .xsd,
            XSD_CN
        );
    }
}
