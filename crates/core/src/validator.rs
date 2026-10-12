//! Einstieg: `Validator` haelt die kompilierten Artefakte. Siehe validator.md.

use crate::bericht::Bericht;
use crate::engine::{cache::Cache, dokument::Dokument};
use crate::fehler::Fehler;
use crate::kosit::{self, Stufen, Szenarien};
use crate::mustang;
use std::cell::OnceCell;

/// Empfohlener Stack fuer die tiefen EN-16931-Stylesheets (der Thread muss ihn haben).
pub const STACK_BYTES: usize = 64 * 1024 * 1024;

/// Ergebnis von [`Validator::beide`]: links KoSIT, rechts Mustang.
pub type Doppelergebnis = (Result<Bericht, Fehler>, Result<Bericht, Fehler>);

/// Ein Validator je Thread. Kompiliert Artefakte beim ersten Gebrauch und behaelt sie.
pub struct Validator {
    cache: Cache,
    stufen: OnceCell<Stufen>,
    stack_bytes: usize,
}

impl Default for Validator {
    fn default() -> Self {
        Self::new()
    }
}

impl Validator {
    /// Siehe [`STACK_BYTES`].
    pub const STACK_BYTES: usize = STACK_BYTES;

    pub fn new() -> Self {
        Validator {
            cache: Cache::default(),
            stufen: OnceCell::new(),
            stack_bytes: STACK_BYTES,
        }
    }

    /// Stack, den die Engine dem laufenden Thread zutrauen darf (Standard 64 MiB).
    pub fn mit_stack(mut self, bytes: usize) -> Self {
        self.stack_bytes = bytes;
        self
    }

    /// Alle Artefakte beider Werkzeuge vorab kompilieren (Dienststart).
    pub fn vorwaermen(&self) -> Result<(), Fehler> {
        self.cache.vorwaermen(kosit_xslt(), kosit_xsd())?;
        self.cache
            .vorwaermen(mustang::ALLE_XSLT, mustang::ALLE_XSD)?;
        self.stufen();
        Ok(())
    }

    fn stufen(&self) -> &Stufen {
        self.stufen.get_or_init(Stufen::laden)
    }

    /// Pruefung wie der KoSIT-Validator.
    pub fn kosit(&self, xml: &str, szenarien: Szenarien) -> Result<Bericht, Fehler> {
        let dok = Dokument::parse(xml)?;
        kosit::pruefe(
            &self.cache,
            self.stufen(),
            self.stack_bytes,
            &dok,
            szenarien,
        )
    }

    /// Pruefung einer ZUGFeRD/Factur-X-PDF: das eingebettete Rechnungs-XML entpacken und
    /// wie `kosit` pruefen. Gibt zusaetzlich den Dateinamen des eingebetteten XML zurueck.
    pub fn kosit_pdf(
        &self,
        pdf: &[u8],
        szenarien: Szenarien,
    ) -> Result<(String, Bericht), Fehler> {
        let (name, xml) = crate::pdf::eingebettetes_xml(pdf)?;
        let bericht = self.kosit(&xml, szenarien)?;
        Ok((name, bericht))
    }

    /// Beide Werkzeuge auf einer ZUGFeRD/Factur-X-PDF: das eingebettete Rechnungs-XML
    /// EINMAL entpacken und dann wie `beide` KoSIT und Mustang darauf fahren. Gibt
    /// zusaetzlich den Dateinamen des eingebetteten XML zurueck.
    pub fn beide_pdf(
        &self,
        pdf: &[u8],
        szenarien: Szenarien,
    ) -> Result<(String, Doppelergebnis), Fehler> {
        let (name, xml) = crate::pdf::eingebettetes_xml(pdf)?;
        let doppel = self.beide(&xml, szenarien)?;
        Ok((name, doppel))
    }

    /// Pruefung wie Mustang.
    pub fn mustang(&self, xml: &str) -> Result<Bericht, Fehler> {
        let dok = Dokument::parse(xml)?;
        mustang::pruefe(&self.cache, self.stack_bytes, &dok)
    }

    /// Beide Werkzeuge auf einem einmal geparsten Beleg.
    pub fn beide(&self, xml: &str, szenarien: Szenarien) -> Result<Doppelergebnis, Fehler> {
        let dok = Dokument::parse(xml)?;
        Ok((
            kosit::pruefe(
                &self.cache,
                self.stufen(),
                self.stack_bytes,
                &dok,
                szenarien,
            ),
            mustang::pruefe(&self.cache, self.stack_bytes, &dok),
        ))
    }
}

fn kosit_xslt() -> &'static [&'static str] {
    crate::kosit::ALLE_XSLT
}
fn kosit_xsd() -> &'static [&'static str] {
    crate::kosit::ALLE_XSD
}
