//! Erzeugt die Artefakt-Tabelle aus `artefakte/` und prüft dabei die Invarianten,
//! die der Validator voraussetzt. Siehe build.md.
//!
//! Läuft bei jeder Änderung unter `artefakte/` neu, damit ein aktualisiertes
//! Upstream-Artefakt nicht still an der Tabelle vorbeigeht.

use std::collections::BTreeMap;
use std::path::{Path, PathBuf};
use std::{env, fs};

/// Endungen, die als Artefakt eingebettet werden.
const ENDUNGEN: &[&str] = &["xsl", "xslt", "xsd", "xml", "sch"];

fn main() {
    let wurzel = PathBuf::from(env::var("CARGO_MANIFEST_DIR").expect("CARGO_MANIFEST_DIR"));
    let artefakte = wurzel.join("artefakte");

    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-changed={}", artefakte.display());

    let kosit = sammle(&artefakte, "kosit");
    let mustang = sammle(&artefakte, "mustang");
    if kosit.is_empty() || mustang.is_empty() {
        panic!("artefakte/kosit oder artefakte/mustang ist leer — Artefaktbaum unvollständig");
    }

    pruefe_vorverarbeitet(&artefakte, kosit.iter().chain(&mustang));
    let gleiche = gleiche_regelsaetze(&artefakte, kosit.iter().chain(&mustang));

    let ziel = PathBuf::from(env::var("OUT_DIR").expect("OUT_DIR")).join("tabelle.rs");
    fs::write(&ziel, erzeuge(&artefakte, &kosit, &mustang, &gleiche))
        .unwrap_or_else(|e| panic!("{} nicht schreibbar: {e}", ziel.display()));
}

/// Alle Artefaktpfade unterhalb von `artefakte/<werkzeug>/`, relativ zu `artefakte/`, sortiert.
fn sammle(artefakte: &Path, werkzeug: &str) -> Vec<String> {
    let mut out = Vec::new();
    begehe(&artefakte.join(werkzeug), artefakte, &mut out);
    out.sort();
    out
}

fn begehe(verzeichnis: &Path, basis: &Path, out: &mut Vec<String>) {
    let Ok(eintraege) = fs::read_dir(verzeichnis) else {
        return;
    };
    for e in eintraege.flatten() {
        let p = e.path();
        if p.is_dir() {
            begehe(&p, basis, out);
        } else if p
            .extension()
            .and_then(|s| s.to_str())
            .is_some_and(|s| ENDUNGEN.contains(&s))
        {
            let rel = p.strip_prefix(basis).expect("unterhalb von artefakte/");
            out.push(rel.to_string_lossy().replace('\\', "/"));
        }
    }
}

/// Die Schematron-Quellen im Repo sind **vorverarbeitet** (`scripts/schematron-vorverarbeiten.py`):
/// `<include>` eingebettet, abstrakte Muster instanziiert. Ein roh eingespieltes Upstream-Artefakt
/// würde zur Laufzeit stillschweigend zu wenig prüfen — darum hier harter Abbruch.
fn pruefe_vorverarbeitet<'a>(artefakte: &Path, pfade: impl Iterator<Item = &'a String>) {
    for pfad in pfade {
        if !pfad.ends_with(".sch") {
            continue;
        }
        let text = lies(&artefakte.join(pfad));
        for (muster, hinweis) in [
            ("<include", "<include> ist nicht eingebettet"),
            ("abstract=\"true\"", "abstrakte Muster sind nicht instanziiert"),
        ] {
            if text.contains(muster) {
                panic!(
                    "artefakte/{pfad}: {hinweis}.\n\
                     Das Artefakt ist roh von upstream. Vor dem Einchecken vorverarbeiten:\n\
                     \x20 cd crates/core && python3 scripts/schematron-vorverarbeiten.py \
                     <roh.sch> artefakte/{pfad}"
                );
            }
        }
    }
}

/// Artefakte, die denselben Regelsatz tragen — gleiche Menge aus (Regel-ID, Testausdruck).
///
/// Trifft heute auf die EN-16931-Kernregeln zu: KoSIT führt sie als Schematron-Quelle,
/// Mustang als kompiliertes XSLT. Das Paar wird **berechnet, nicht angenommen** — ändert
/// upstream eine Seite, verschwindet es hier von selbst und die Laufzeit prüft wieder doppelt.
fn gleiche_regelsaetze<'a>(
    artefakte: &Path,
    pfade: impl Iterator<Item = &'a String>,
) -> Vec<(String, String)> {
    let mut nach_inventar: BTreeMap<Vec<(String, String)>, Vec<String>> = BTreeMap::new();
    for pfad in pfade {
        let text = lies(&artefakte.join(pfad));
        let inv = if pfad.ends_with(".sch") {
            inventar_quelle(&text)
        } else if pfad.ends_with(".xsl") || pfad.ends_with(".xslt") {
            inventar_kompiliert(&text)
        } else {
            continue;
        };
        // Ein leeres Inventar sagt nichts aus (XSD-Hilfsdateien, Codelisten).
        if inv.is_empty() {
            continue;
        }
        nach_inventar.entry(inv).or_default().push(pfad.clone());
    }
    let mut paare = Vec::new();
    for gruppe in nach_inventar.into_values() {
        if gruppe.len() < 2 {
            continue;
        }
        // Erster Eintrag ist der Vertreter; alle weiteren sind zu ihm gleichwertig.
        for weiterer in &gruppe[1..] {
            paare.push((gruppe[0].clone(), weiterer.clone()));
        }
    }
    paare
}

/// (ID, Test) je `<assert>` einer Schematron-Quelle. Die ID steht als `[BR-…]` im Meldungstext,
/// weil die Artefakte sie dort führen und SVRL sie genauso ausgibt.
fn inventar_quelle(text: &str) -> Vec<(String, String)> {
    let mut out = Vec::new();
    for stueck in text.split("<assert").skip(1) {
        let Some(ende) = tag_ende(stueck) else { continue };
        let (tag, rumpf) = stueck.split_at(ende);
        let (Some(test), Some(id)) = (attribut(tag, "test"), klammer_id(rumpf)) else {
            continue;
        };
        out.push((id, normiere(&test)));
    }
    out.sort();
    out
}

/// (ID, Test) je `<svrl:failed-assert>` eines vom Schematron-Skeleton erzeugten XSLT. Dort steht
/// der ursprüngliche XPath wörtlich im `test`-Attribut und die ID als `<xsl:attribute name="id">`.
fn inventar_kompiliert(text: &str) -> Vec<(String, String)> {
    let mut out = Vec::new();
    for stueck in text.split("<svrl:failed-assert").skip(1) {
        let Some(ende) = tag_ende(stueck) else { continue };
        let (tag, rumpf) = stueck.split_at(ende);
        let Some(test) = attribut(tag, "test") else {
            continue;
        };
        let id = rumpf
            .split_once("name=\"id\">")
            .and_then(|(_, r)| r.split_once('<'))
            .map(|(v, _)| v.trim().to_string())
            .filter(|v| !v.is_empty());
        let Some(id) = id else { continue };
        out.push((id, normiere(&test)));
    }
    out.sort();
    out
}

/// Index des `>`, das den Start-Tag schließt. Anführungszeichen werden respektiert: Ein rohes
/// `>` ist in einem XML-Attributwert erlaubt und kommt in 23 der EN-16931-XPath-Tests vor.
/// Ein naives `find('>')` schneidet dort mitten im Attribut.
fn tag_ende(s: &str) -> Option<usize> {
    let mut offen: Option<u8> = None;
    for (i, c) in s.bytes().enumerate() {
        match (offen, c) {
            (None, b'"' | b'\'') => offen = Some(c),
            (Some(q), c) if c == q => offen = None,
            (None, b'>') => return Some(i),
            _ => {}
        }
    }
    None
}

/// Wert eines Attributs aus einem Start-Tag, XML-Entitäten aufgelöst.
fn attribut(tag: &str, name: &str) -> Option<String> {
    let marke = format!("{name}=\"");
    let mut rest = tag;
    loop {
        let pos = rest.find(&marke)?;
        // Muss an einer Attributgrenze stehen, sonst trifft `test="` auch `subtest="`.
        let davor = rest[..pos].chars().next_back();
        let wert = rest[pos + marke.len()..].split_once('"')?.0;
        if davor.is_none_or(char::is_whitespace) {
            return Some(entitaeten(wert));
        }
        rest = &rest[pos + marke.len()..];
    }
}

/// Die Klammer-ID (`[BR-CO-10]`) aus einem Meldungstext.
fn klammer_id(rumpf: &str) -> Option<String> {
    let auf = rumpf.find('[')?;
    let zu = rumpf[auf + 1..].find(']')?;
    let id = &rumpf[auf + 1..auf + 1 + zu];
    let gueltig = !id.is_empty()
        && id.len() <= 40
        && id
            .chars()
            .all(|c| c.is_ascii_alphanumeric() || c == '-' || c == '.');
    gueltig.then(|| id.to_string())
}

fn entitaeten(s: &str) -> String {
    s.replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&quot;", "\"")
        .replace("&apos;", "'")
        .replace("&amp;", "&")
}

/// Whitespace vereinheitlichen, damit Zeilenumbrüche in der Quelle keinen Unterschied machen.
fn normiere(s: &str) -> String {
    s.split_whitespace().collect::<Vec<_>>().join(" ")
}

fn lies(pfad: &Path) -> String {
    fs::read_to_string(pfad).unwrap_or_else(|e| panic!("{} nicht lesbar: {e}", pfad.display()))
}

fn erzeuge(
    artefakte: &Path,
    kosit: &[String],
    mustang: &[String],
    gleiche: &[(String, String)],
) -> String {
    let mut s = String::new();
    s.push_str("// ERZEUGT von build.rs aus artefakte/ — nicht von Hand aendern.\n\n");
    for (name, liste) in [("KOSIT", kosit), ("MUSTANG", mustang)] {
        s.push_str(&format!("pub static {name}: &[Datei] = &[\n"));
        for pfad in liste {
            let voll = artefakte.join(pfad);
            s.push_str(&format!(
                "    Datei {{ pfad: {:?}, text: include_str!({:?}) }},\n",
                pfad,
                voll.to_string_lossy()
            ));
        }
        s.push_str("];\n\n");
    }
    s.push_str(
        "/// Artefaktpaare mit nachweislich gleichem Regelsatz (gleiche Menge aus ID und\n\
         /// Testausdruck), zur Bauzeit aus den Artefakten berechnet. Leer, sobald upstream\n\
         /// eine Seite aendert.\n",
    );
    s.push_str("pub static GLEICHE_REGELSAETZE: &[(&str, &str)] = &[\n");
    for (a, b) in gleiche {
        s.push_str(&format!("    ({a:?}, {b:?}),\n"));
    }
    s.push_str("];\n");
    s
}
