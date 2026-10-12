//! Pruefung wie Mustangs XMLValidator (Factur-X/ZUGFeRD 2, XRechnung, UBL). Siehe mod.md.
//!   profil.rs    Profil aus der Guideline-ID; XSD und XSLT-Kette je Profil
//!   pruefung.rs  Ablauf: XSD -> Profil-XSLT (+ XR_30) -> Urteil

mod profil;
mod pruefung;

pub use profil::{ALLE_XSD, ALLE_XSLT};
pub use pruefung::pruefe;
