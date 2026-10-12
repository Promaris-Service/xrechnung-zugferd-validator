//! Eingebettetes Rechnungs-XML aus einer ZUGFeRD/Factur-X-PDF ziehen. Siehe pdf.md.
//!
//! ZUGFeRD/Factur-X legt das EN-16931-XML als angehaengte Datei (embedded file) in die
//! PDF. Verankert ist sie zweifach: ueber den Namensbaum `/Names/EmbeddedFiles` und ueber
//! die "associated files" `/AF` des Katalogs (PDF/A-3, von Factur-X vorgeschrieben). Diese
//! Datei heisst normkonform `factur-x.xml` (ZUGFeRD 2), fruehere Staende `zugferd-invoice.xml`,
//! XRechnung-im-PDF `xrechnung.xml`, Order-X `order-x.xml`.
//!
//! Hier wird NUR die Containerstruktur der PDF gelesen und der XML-Anhang entpackt; die
//! eigentliche Rechnungspruefung macht danach `Validator::kosit` auf dem gewonnenen XML.
//! Reiner Rust (lopdf, flate2/miniz_oxide), baut unveraendert fuer wasm32-wasip2.

use crate::fehler::Fehler;
use lopdf::{Dictionary, Document};

/// Bekannte Dateinamen des Rechnungs-XML, nach Vorrang. Klein geschrieben verglichen.
const BEKANNTE: &[&str] = &[
    "factur-x.xml",
    "zugferd-invoice.xml",
    "xrechnung.xml",
    "cii.xml",
    "order-x.xml",
];

/// Extrahiert Dateiname und UTF-8-Text des eingebetteten Rechnungs-XML.
pub fn eingebettetes_xml(pdf: &[u8]) -> Result<(String, String), Fehler> {
    let doc = Document::load_mem(pdf)
        .map_err(|e| Fehler::Dokument(format!("PDF nicht lesbar: {e}")))?;

    let mut kandidaten: Vec<(String, Vec<u8>)> = Vec::new();
    if let Ok(katalog) = doc.catalog() {
        sammle_aus_names(&doc, katalog, &mut kandidaten);
        sammle_aus_af(&doc, katalog, &mut kandidaten);
    }
    if kandidaten.is_empty() {
        return Err(Fehler::Dokument(
            "PDF ohne eingebettete Datei (keine ZUGFeRD/Factur-X-Rechnung)".to_string(),
        ));
    }

    let (name, bytes) = waehle(kandidaten)?;
    let text = in_text(bytes)?;
    Ok((name, text))
}

/// Namensbaum `/Names/EmbeddedFiles` des Katalogs einsammeln (inkl. `/Kids`).
fn sammle_aus_names(doc: &Document, katalog: &Dictionary, out: &mut Vec<(String, Vec<u8>)>) {
    let names = match doc.get_dict_in_dict(katalog, b"Names") {
        Ok(d) => d,
        Err(_) => return,
    };
    if let Ok(wurzel) = doc.get_dict_in_dict(names, b"EmbeddedFiles") {
        namensbaum(doc, wurzel, out, 0);
    }
}

/// Ein Knoten des Namensbaums: entweder Blatt mit `/Names` [name, filespec, ...] oder
/// Zwischenknoten mit `/Kids`. Tiefe begrenzt gegen entartete/zyklische Baeume.
fn namensbaum(doc: &Document, knoten: &Dictionary, out: &mut Vec<(String, Vec<u8>)>, tiefe: u32) {
    if tiefe > 64 {
        return;
    }
    if let Ok(liste) = knoten.get(b"Names").and_then(|o| o.as_array()) {
        for paar in liste.chunks(2) {
            if let [_schluessel, wert] = paar
                && let Ok((_, obj)) = doc.dereference(wert)
                && let Ok(fs) = obj.as_dict()
                && let Some(d) = aus_filespec(doc, fs)
            {
                out.push(d);
            }
        }
    }
    if let Ok(kids) = knoten.get(b"Kids").and_then(|o| o.as_array()) {
        for kid in kids {
            if let Ok((_, obj)) = doc.dereference(kid)
                && let Ok(kd) = obj.as_dict()
            {
                namensbaum(doc, kd, out, tiefe + 1);
            }
        }
    }
}

/// Associated files `/AF` des Katalogs: Array von Filespec-Verweisen (PDF/A-3, Factur-X).
fn sammle_aus_af(doc: &Document, katalog: &Dictionary, out: &mut Vec<(String, Vec<u8>)>) {
    let af = match katalog.get(b"AF").and_then(|o| doc.dereference(o).map(|(_, o)| o)) {
        Ok(o) => o,
        Err(_) => return,
    };
    if let Ok(liste) = af.as_array() {
        for e in liste {
            if let Ok((_, obj)) = doc.dereference(e)
                && let Ok(fs) = obj.as_dict()
                && let Some(d) = aus_filespec(doc, fs)
            {
                out.push(d);
            }
        }
    }
}

/// Obergrenze fuer einen entpackten Anhang (32 MiB). Reale E-Rechnungen liegen weit
/// darunter; der Deckel begrenzt die an die Pruefung weitergereichte Datenmenge.
const MAX_ANHANG: usize = 32 * 1024 * 1024;

/// Name und entpackter Inhalt aus einem Filespec-Dictionary (`/F`/`/UF` + `/EF`).
fn aus_filespec(doc: &Document, fs: &Dictionary) -> Option<(String, Vec<u8>)> {
    let roh_name = fs
        .get(b"UF")
        .or_else(|_| fs.get(b"F"))
        .ok()
        .and_then(|o| doc.dereference(o).ok())
        .and_then(|(_, o)| o.as_str().ok())
        .map(dekodiere_name)?;

    let ef = doc.get_dict_in_dict(fs, b"EF").ok()?;
    let strom_obj = ef.get(b"F").or_else(|_| ef.get(b"UF")).ok()?;
    let (_, obj) = doc.dereference(strom_obj).ok()?;
    let strom = obj.as_stream().ok()?;
    // Entpacken (FlateDecode ...); faellt der Filter aus, den Rohinhalt nehmen.
    let bytes = strom
        .decompressed_content()
        .unwrap_or_else(|_| strom.content.clone());
    // Grobschutz gegen Dekompressions-Bomben: eine EN-16931-Rechnung ist wenige hundert
    // KB gross. Ein unplausibel grosser Anhang wird verworfen, damit er nicht die
    // nachgelagerte (teure) XSLT-/Schematron-Pruefung auf XXL-Eingaben treibt.
    if bytes.len() > MAX_ANHANG {
        return None;
    }
    Some((roh_name, bytes))
}

/// PDF-Dateinamen in einen String bringen: UTF-16BE (BOM `FE FF`) oder sonst die
/// druckbaren ASCII-Zeichen (PDFDocEncoding ist fuer `factur-x.xml` o. ae. deckungsgleich).
fn dekodiere_name(roh: &[u8]) -> String {
    if roh.len() >= 2 && roh[0] == 0xFE && roh[1] == 0xFF {
        let paare: Vec<u16> = roh[2..]
            .chunks_exact(2)
            .map(|c| u16::from_be_bytes([c[0], c[1]]))
            .collect();
        return String::from_utf16_lossy(&paare);
    }
    roh.iter()
        .filter(|&&b| (0x20..0x7f).contains(&b))
        .map(|&b| b as char)
        .collect()
}

/// Aus allen gefundenen Anhaengen die Rechnungs-XML auswaehlen: erst nach bekanntem Namen
/// (Vorrang MINIMUM..Order-X), sonst der einzige/erste `.xml`-Anhang.
fn waehle(kandidaten: Vec<(String, Vec<u8>)>) -> Result<(String, Vec<u8>), Fehler> {
    for wunsch in BEKANNTE {
        if let Some((n, b)) = kandidaten
            .iter()
            .find(|(n, _)| n.eq_ignore_ascii_case(wunsch))
        {
            return Ok((n.clone(), b.clone()));
        }
    }
    if let Some((n, b)) = kandidaten
        .iter()
        .find(|(n, _)| n.to_ascii_lowercase().ends_with(".xml"))
    {
        return Ok((n.clone(), b.clone()));
    }
    Err(Fehler::Dokument(format!(
        "kein eingebettetes Rechnungs-XML in der PDF (gefunden: {})",
        kandidaten
            .iter()
            .map(|(n, _)| n.as_str())
            .collect::<Vec<_>>()
            .join(", ")
    )))
}

/// Anhangbytes in UTF-8-Text ueberfuehren; fuehrende UTF-8-BOM entfernen.
fn in_text(mut bytes: Vec<u8>) -> Result<String, Fehler> {
    if bytes.starts_with(&[0xEF, 0xBB, 0xBF]) {
        bytes.drain(0..3);
    }
    String::from_utf8(bytes)
        .map_err(|_| Fehler::Dokument("eingebettetes XML ist kein gueltiges UTF-8".to_string()))
}
