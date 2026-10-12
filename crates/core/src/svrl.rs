//! SVRL-Ausgabe der Schematron-XSLTs in Befunde uebersetzen. Siehe svrl.md.

use crate::bericht::{Befund, Stufe};
use crate::fehler::Fehler;

const SVRL: &str = "http://purl.oclc.org/dsdl/svrl";

/// Liest alle `svrl:failed-assert` (und mit `mit_reports` auch `svrl:successful-report`)
/// aus `svrl`. `ohne_flag` bestimmt die Stufe eines Befunds ohne `flag`-Attribut.
pub fn befunde(
    svrl: &str,
    quelle: &str,
    ohne_flag: Stufe,
    mit_reports: bool,
) -> Result<Vec<Befund>, Fehler> {
    let dok = roxmltree::Document::parse(svrl)
        .map_err(|e| Fehler::Engine(format!("SVRL unlesbar ({quelle}): {e}")))?;
    let mut out = Vec::new();
    for n in dok
        .descendants()
        .filter(|n| n.is_element() && n.tag_name().namespace() == Some(SVRL))
    {
        let name = n.tag_name().name();
        if name != "failed-assert" && !(mit_reports && name == "successful-report") {
            continue;
        }
        let flag = n.attribute("flag").unwrap_or("").to_string();
        let text = n
            .children()
            .filter(|c| c.is_element() && c.tag_name().name() == "text")
            // ALLE Textknoten des <svrl:text> sammeln: bei gemischtem Inhalt (z. B.
            // eingebettete <svrl:value-of>) liefert node.text() nur den ersten Teil.
            .map(|c| {
                c.descendants()
                    .filter(|d| d.is_text())
                    .filter_map(|d| d.text())
                    .collect::<String>()
                    .trim()
                    .to_string()
            })
            .collect::<Vec<_>>()
            .join(" ");
        let regel = n
            .attribute("id")
            .map(str::to_string)
            .filter(|s| !s.is_empty())
            .unwrap_or_else(|| regel_aus_text(&text));
        out.push(Befund {
            regel,
            stufe: Stufe::aus_flag(&flag, ohne_flag),
            flag,
            ort: n.attribute("location").unwrap_or("").to_string(),
            text,
            quelle: quelle.to_string(),
        });
    }
    Ok(out)
}

/// Mustangs Factur-X-XSLTs liefern keine `id`; die Regel steht als `[BR-CO-14]` im Text.
fn regel_aus_text(text: &str) -> String {
    let t = text.trim_start();
    if let Some(rest) = t.strip_prefix('[')
        && let Some(ende) = rest.find(']')
    {
        let id = &rest[..ende];
        if !id.is_empty()
            && id.len() <= 32
            && id
                .chars()
                .all(|c| c.is_ascii_alphanumeric() || c == '-' || c == '_')
        {
            return id.to_string();
        }
    }
    String::new()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn liest_failed_assert() {
        let s = r#"<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"><svrl:failed-assert id="BR-01" flag="fatal" location="/a/b" test="x"><svrl:text> Text </svrl:text></svrl:failed-assert><svrl:failed-assert location="/c"><svrl:text>[CII-SR-013] - Name should not be present</svrl:text></svrl:failed-assert></svrl:schematron-output>"#;
        let b = befunde(s, "q", Stufe::Fehler, true).unwrap();
        assert_eq!(b.len(), 2);
        assert_eq!(
            (b[0].regel.as_str(), b[0].stufe, b[0].text.as_str()),
            ("BR-01", Stufe::Fehler, "Text")
        );
        assert_eq!(
            (b[1].regel.as_str(), b[1].flag.as_str()),
            ("CII-SR-013", "")
        );
    }
}
