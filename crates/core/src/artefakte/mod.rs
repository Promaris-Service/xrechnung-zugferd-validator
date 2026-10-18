//! Eingebettete Pruefartefakte und ihre Aufloesung aus dem Speicher. Siehe mod.md.

mod tabelle {
    //! Von `build.rs` aus `artefakte/` erzeugt: die eingebetteten Dateien und die zur Bauzeit
    //! berechneten Paare gleicher Regelsaetze. Siehe ../../build.md.
    use super::Datei;
    include!(concat!(env!("OUT_DIR"), "/tabelle.rs"));
}

/// Ein eingebettetes Artefakt: Pfad unterhalb von `artefakte/` und sein Text.
pub struct Datei {
    pub pfad: &'static str,
    pub text: &'static str,
}

/// Stand der eingebetteten Artefakte (KoSIT-XRechnung-Konfiguration, Mustang-Fassung).
pub const VERSION: &str = "kosit-xrechnung-config-2026-08-31 (XRechnung 3.0.2, CEN EN16931 1.3.16 als Schematron) + mustang-2.26.0 (Factur-X 1.09.2 ZF_250 als Schematron, XRechnung 1.2-3.0)";

/// Basis-URI, unter der die Artefakte den Engines bekannt gemacht werden. Das `file:`-Schema
/// ist absichtlich: es loest relative Verweise (`document('…_codedb.xml')`, `schemaLocation`)
/// hierarchisch auf, ohne dass je eine Datei vom Datenträger gelesen wird.
pub const BASIS: &str = "file:///artefakte/";

pub fn uri(pfad: &str) -> String {
    format!("{BASIS}{pfad}")
}

/// Text eines Artefakts nach Pfad (`kosit/cii/EN16931-CII-validation.xsl`).
pub fn finde(pfad: &str) -> Option<&'static str> {
    tabelle::KOSIT
        .iter()
        .chain(tabelle::MUSTANG.iter())
        .find(|d| d.pfad == pfad)
        .map(|d| d.text)
}

/// Text eines Artefakts nach voller URI (`file:///artefakte/...`), mit Aliasen fuer die
/// Factur-X-Schemata, deren `schemaLocation`-Hinweise andere Dateinamen nennen als die
/// ausgelieferten Dateien tragen (`Factur-X_1.09_BASICWL_…` → `FACTUR-X_BASIC-WL_…`).
pub fn finde_uri(uri: &str) -> Option<&'static str> {
    let pfad = uri.strip_prefix(BASIS)?;
    if let Some(t) = finde(pfad) {
        return Some(t);
    }
    let (dir, name) = pfad.rsplit_once('/').unwrap_or(("", pfad));
    let alias = name
        .strip_prefix("Factur-X_1.09_")
        .map(|rest| rest.replacen("BASICWL", "BASIC-WL", 1))
        .map(|rest| format!("{dir}/FACTUR-X_{rest}"))?;
    finde(&alias)
}

/// Alle Mustang-Codelisten (`*_codedb.xml`), die `document()` in den Factur-X-XSLTs laedt.
pub fn mustang_codelisten() -> impl Iterator<Item = &'static Datei> {
    tabelle::MUSTANG
        .iter()
        .filter(|d| d.pfad.ends_with("_codedb.xml"))
}
