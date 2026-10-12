//! Oeffentliche Beispiele der KoSIT-XRechnung-Testsuite (Apache-2.0) durch beide Werkzeuge.
//! Die Testsuite-Belege sind gueltige XRechnungen: KoSIT muss sie annehmen, das Szenario
//! muss das offizielle XRechnung-Szenario sein.

use erechnung_validator::{Syntax, Szenarien, Validator, Werkzeug};

fn lies(name: &str) -> String {
    std::fs::read_to_string(format!(
        "{}/tests/belege/{name}",
        env!("CARGO_MANIFEST_DIR")
    ))
    .unwrap()
}

fn mit_stack<T: Send>(f: impl FnOnce() -> T + Send) -> T {
    std::thread::Builder::new()
        .stack_size(Validator::STACK_BYTES)
        .spawn_scoped_fn(f)
}

trait SpawnScoped {
    fn spawn_scoped_fn<T: Send>(self, f: impl FnOnce() -> T + Send) -> T;
}
impl SpawnScoped for std::thread::Builder {
    fn spawn_scoped_fn<T: Send>(self, f: impl FnOnce() -> T + Send) -> T {
        std::thread::scope(|s| self.spawn_scoped(s, f).unwrap().join().unwrap())
    }
}

#[test]
fn xrechnung_cii_wird_von_beiden_angenommen() {
    mit_stack(|| {
        let v = Validator::new();
        let xml = lies("01.01a-INVOICE_uncefact.xml");
        let k = v.kosit(&xml, Szenarien::XRechnung302).unwrap();
        assert_eq!(
            (k.werkzeug, k.syntax, k.szenario.as_str()),
            (Werkzeug::Kosit, Syntax::Cii, "EN16931 XRechnung (CII)")
        );
        assert!(k.xsd_gueltig, "{:?}", k.xsd_fehler);
        assert!(k.angenommen, "Fehler: {:?}", k.fehler().collect::<Vec<_>>());
        let m = v.mustang(&xml).unwrap();
        assert_eq!(
            (m.werkzeug, m.szenario.as_str()),
            (Werkzeug::Mustang, "XRECHNUNG")
        );
        assert!(m.xsd_gueltig, "{:?}", m.xsd_fehler);
        assert!(m.angenommen, "Fehler: {:?}", m.fehler().collect::<Vec<_>>());
    });
}

#[test]
fn xrechnung_ubl_wird_angenommen() {
    mit_stack(|| {
        let v = Validator::new();
        for name in [
            "01.01a-INVOICE_ubl.xml",
            "01.15a-INVOICE_ubl.xml",
            "02.01a-INVOICE_ubl.xml",
        ] {
            let xml = lies(name);
            let (k, m) = v.beide(&xml, Szenarien::Automatisch).unwrap();
            let k = k.unwrap();
            assert_eq!(
                (k.syntax, k.szenario.as_str()),
                (Syntax::UblInvoice, "EN16931 XRechnung (UBL Invoice)"),
                "{name}"
            );
            assert!(k.angenommen, "{name}: {:?}", k.fehler().collect::<Vec<_>>());
            let m = m.unwrap();
            assert!(m.angenommen, "{name}: {:?}", m.fehler().collect::<Vec<_>>());
        }
    });
}

#[test]
fn kaputter_beleg_liefert_befunde_statt_bestanden() {
    mit_stack(|| {
        let v = Validator::new();
        // Steuersatz auf 0 bei Kategorie S: BR-S-05/BR-S-08-Umfeld muss anschlagen.
        let xml = lies("01.01a-INVOICE_ubl.xml").replace(
            "<cbc:Percent>7</cbc:Percent>",
            "<cbc:Percent>0</cbc:Percent>",
        );
        let k = v.kosit(&xml, Szenarien::Automatisch).unwrap();
        assert!(!k.angenommen);
        assert!(
            k.fehler().any(|f| f.regel.starts_with("BR-S-")),
            "{:?}",
            k.befunde
        );
        let m = v.mustang(&xml).unwrap();
        assert!(!m.angenommen);
    });
}

#[test]
fn facturx_offiziell_kein_szenario_automatisch_kernregeln() {
    mit_stack(|| {
        let v = Validator::new();
        let xml = lies("01.01a-INVOICE_uncefact.xml").replacen(
            "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0",
            "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended",
            1,
        );
        assert!(matches!(
            v.kosit(&xml, Szenarien::XRechnung302),
            Err(erechnung_validator::Fehler::KeinSzenario(_))
        ));
        let k = v.kosit(&xml, Szenarien::Automatisch).unwrap();
        assert_eq!(k.szenario, "EN16931 (CII, beliebiges Profil)");
        let m = v.mustang(&xml).unwrap();
        assert_eq!(m.szenario, "EXTENDED");
    });
}

#[test]
fn kein_xml_ist_ein_fehler() {
    let v = Validator::new();
    assert!(matches!(
        v.kosit("<html/>", Szenarien::Automatisch),
        Err(erechnung_validator::Fehler::Dokument(_))
    ));
    assert!(matches!(
        v.mustang("nicht xml"),
        Err(erechnung_validator::Fehler::Dokument(_))
    ));
}
