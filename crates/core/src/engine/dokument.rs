//! Beleg einmal parsen, Syntax und Kennung bestimmen. Siehe dokument.md.

use crate::bericht::Syntax;
use crate::fehler::Fehler;
use oxixml_infoset::Tree;

/// Ein geparster Beleg. Der Baum wird von allen XSLTs eines Laufs geteilt.
pub struct Dokument<'a> {
    pub xml: &'a str,
    pub baum: Tree,
    pub syntax: Syntax,
    /// CustomizationID (UBL) bzw. Guideline-ID (CII), leer wenn nicht vorhanden.
    pub kennung: String,
}

impl<'a> Dokument<'a> {
    pub fn parse(xml: &'a str) -> Result<Self, Fehler> {
        let syntax = syntax(xml).ok_or_else(|| {
            Fehler::Dokument(
                "Wurzelelement ist weder CrossIndustryInvoice noch Invoice/CreditNote".into(),
            )
        })?;
        let baum = Tree::parse_str(xml).map_err(|e| Fehler::Dokument(format!("{e:?}")))?;
        let kennung = kennung(xml, syntax);
        Ok(Dokument {
            xml,
            baum,
            syntax,
            kennung,
        })
    }
}

/// Wurzelelement lesen: erstes Tag, das kein `<?`-, `<!`-Konstrukt ist.
fn wurzel(xml: &str) -> Option<&str> {
    let mut rest = xml;
    loop {
        let i = rest.find('<')?;
        let tag = &rest[i + 1..];
        if tag.starts_with('?') || tag.starts_with('!') {
            // Kommentar/PI/DOCTYPE ueberspringen
            let ende = tag.find('>')?;
            rest = &tag[ende + 1..];
            continue;
        }
        let ende = tag.find(|c: char| c.is_whitespace() || c == '>' || c == '/')?;
        let name = &tag[..ende];
        return Some(name.rsplit(':').next().unwrap_or(name));
    }
}

fn syntax(xml: &str) -> Option<Syntax> {
    match wurzel(xml)? {
        "CrossIndustryInvoice" => Some(Syntax::Cii),
        "Invoice" => Some(Syntax::UblInvoice),
        "CreditNote" => Some(Syntax::UblCreditNote),
        _ => None,
    }
}

/// Textinhalt des ersten Elements mit dem Lokalnamen `lokal` nach Position `ab`.
fn elementtext(xml: &str, ab: usize, lokal: &str) -> Option<String> {
    let s = &xml[ab..];
    let mut pos = 0;
    while let Some(i) = s[pos..].find('<') {
        let tag = &s[pos + i + 1..];
        let ende = tag.find(|c: char| c.is_whitespace() || c == '>')?;
        let name = &tag[..ende];
        let lokalname = name.rsplit(':').next().unwrap_or(name);
        if lokalname == lokal && !name.starts_with('/') {
            let inhalt_ab = tag.find('>')? + 1;
            let inhalt = &tag[inhalt_ab..];
            let inhalt_ende = inhalt.find('<')?;
            return Some(entschaerfe(inhalt[..inhalt_ende].trim()));
        }
        pos += i + 1;
    }
    None
}

fn entschaerfe(s: &str) -> String {
    // `&amp;` MUSS zuletzt dekodiert werden: sonst wird aus `&amp;lt;` (Literal `&lt;`)
    // erst `&lt;` und dann faelschlich `<` (Doppeldekodierung).
    s.replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&quot;", "\"")
        .replace("&apos;", "'")
        .replace("&amp;", "&")
}

fn kennung(xml: &str, syntax: Syntax) -> String {
    match syntax {
        Syntax::Cii => xml
            .find("GuidelineSpecifiedDocumentContextParameter")
            .and_then(|i| elementtext(xml, i, "ID"))
            .unwrap_or_default(),
        Syntax::UblInvoice | Syntax::UblCreditNote => {
            elementtext(xml, 0, "CustomizationID").unwrap_or_default()
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cii_kennung() {
        let xml = r#"<?xml version="1.0"?><!-- x --><rsm:CrossIndustryInvoice xmlns:rsm="u"><rsm:ExchangedDocumentContext><ram:GuidelineSpecifiedDocumentContextParameter><ram:ID>urn:cen.eu:en16931:2017</ram:ID></ram:GuidelineSpecifiedDocumentContextParameter></rsm:ExchangedDocumentContext></rsm:CrossIndustryInvoice>"#;
        assert_eq!(syntax(xml), Some(Syntax::Cii));
        assert_eq!(kennung(xml, Syntax::Cii), "urn:cen.eu:en16931:2017");
    }

    #[test]
    fn ubl_kennung() {
        let xml = r#"<Invoice xmlns="u" xmlns:cbc="c"><cbc:UBLVersionID>2.1</cbc:UBLVersionID><cbc:CustomizationID>urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0</cbc:CustomizationID></Invoice>"#;
        assert_eq!(syntax(xml), Some(Syntax::UblInvoice));
        assert!(kennung(xml, Syntax::UblInvoice).ends_with("xrechnung_3.0"));
    }
}
