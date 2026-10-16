//! Einstieg: `Validator` haelt die kompilierten Artefakte. Siehe validator.md.

use crate::bericht::Bericht;
use crate::engine::{cache::Cache, dokument::Dokument};
use crate::fehler::Fehler;
use crate::kosit::{self, Stufen, Szenarien};
use crate::mustang;
use std::cell::OnceCell;

/// Recommended stack size for the deeply nested EN 16931 stylesheets (the thread must provide it).
pub const STACK_BYTES: usize = 64 * 1024 * 1024;

/// Result of [`Validator::beide`]: KoSIT on the left, Mustang on the right.
pub type Doppelergebnis = (Result<Bericht, Fehler>, Result<Bericht, Fehler>);

/// One validator per thread. Compiles the artifacts on first use and keeps them.
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
    /// Recommended stack size for the deeply nested EN 16931 stylesheets (the thread must provide it).
    pub const STACK_BYTES: usize = STACK_BYTES;

    pub fn new() -> Self {
        Validator {
            cache: Cache::default(),
            stufen: OnceCell::new(),
            stack_bytes: STACK_BYTES,
        }
    }

    /// Stack size the engine may assume on the running thread (default 64 MiB).
    pub fn mit_stack(mut self, bytes: usize) -> Self {
        self.stack_bytes = bytes;
        self
    }

    /// Pre-compile every artifact of both tools (service start-up).
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

    /// Validation as performed by the KoSIT validator.
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

    /// Validate a ZUGFeRD/Factur-X PDF: extract the embedded invoice XML and check it
    /// as `kosit` does. Additionally returns the file name of the embedded XML.
    pub fn kosit_pdf(
        &self,
        pdf: &[u8],
        szenarien: Szenarien,
    ) -> Result<(String, Bericht), Fehler> {
        let (name, xml) = crate::pdf::eingebettetes_xml(pdf)?;
        let bericht = self.kosit(&xml, szenarien)?;
        Ok((name, bericht))
    }

    /// Both tools on a ZUGFeRD/Factur-X PDF: extract the embedded invoice XML ONCE and
    /// then run KoSIT and Mustang on it as `beide` does. Additionally returns the file
    /// name of the embedded XML.
    pub fn beide_pdf(
        &self,
        pdf: &[u8],
        szenarien: Szenarien,
    ) -> Result<(String, Doppelergebnis), Fehler> {
        let (name, xml) = crate::pdf::eingebettetes_xml(pdf)?;
        let doppel = self.beide(&xml, szenarien)?;
        Ok((name, doppel))
    }

    /// Validation as performed by Mustang.
    pub fn mustang(&self, xml: &str) -> Result<Bericht, Fehler> {
        let dok = Dokument::parse(xml)?;
        mustang::pruefe(&self.cache, self.stack_bytes, &dok)
    }

    /// Both tools on a document that is parsed only once.
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
