# `mustang/` – Einstieg in die Mustang-Nachbildung

## Zweck

Das Modul `mustang` bündelt die Validierung von Factur-X/ZUGFeRD- und XRechnung/UBL-Dokumenten in Anlehnung an den XMLValidator des Mustang-Projekts. Es stellt den öffentlichen Einstiegspunkt `pruefe` sowie die profilabhängigen XSD- und XSLT-Artefakte bereit. Die Datei `mod.rs` selbst enthält keine Prüflogik; sie ordnet die Teilmodule und legt die öffentliche API des Moduls fest.

## Begründung und Designentscheidungen

- **Klare Modulgrenzen:** Die Implementierung liegt in den privaten Modulen `profil` und `pruefung`. Nur die stabile, nach außen benötigte Schnittstelle wird per `pub use` re-exportiert.
- **Ein zentraler Einstiegspunkt:** Mit `pruefe` existiert genau eine öffentliche Funktion, über die Validierungen angestoßen werden. Dadurch bleibt die Nutzung unabhängig von internen Ablaufänderungen.
- **Artefakte als Konstanten:** `ALLE_XSD` und `ALLE_XSLT` bündeln die für alle unterstützten Profile benötigten XSD- bzw. XSLT-Ressourcen. Sie sind als Konstanten öffentlich, damit Tests, Build-Prozesse oder externe Werkzeuge sie ohne Kenntnis der internen Profilstruktur referenzieren können.
- **Dokumentation im Modulkopf:** Die Modul-Doc-Kommentare benennen die Zuständigkeit der beiden Teilmodule und machen den Ablauf `XSD -> Profil-XSLT (+ XR_30) -> Urteil` auf einen Blick sichtbar.
- **Referenzstand:** Die zugrunde gelegten XSD-/XSLT-Artefakte entsprechen dem Stand von Mustang-CLI.jar 2.24.0.

## Umgesetzte Norm

Die Datei `mod.rs` setzt selbst keine inhaltliche EN16931-, KoSIT- oder XRechnung-Regel um. Sie ist der organisatorische Einstieg für die nachgelagerte Prüfung:

- Factur-X/ZUGFeRD-Profile über die jeweiligen XSD- und XSLT-Ketten.
- XRechnung/UBL über die entsprechende XSLT-Kette, inklusive des zusätzlichen XRechnung-3.0-XSLT (`XR_30`).

Die konkrete Regelauswahl und -anwendung erfolgt in `profil` und `pruefung`.

## Bewusste Nicht-Entscheidungen

- **Keine Arithmetikprüfung:** Mustangs Java-seitige Rechenproben (`checkArithmetics`, `CalculatedInvoice`) werden hier nicht nachgebildet.
- **Keine PDF-Prüfung:** veraPDF, XMP-Metadaten und PDF-/XML-Einbettungsprüfungen sind nicht Teil dieses Moduls.
- **Keine öffentlichen Teilmodulnamen:** `profil` und `pruefung` bleiben private Implementierungsdetails; die öffentliche API besteht nur aus den Re-Exports.
