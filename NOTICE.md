# Herkunft der eingebetteten Artefakte

Der Rust-Code dieses Repos steht unter MIT OR Apache-2.0. Die unter
`crates/core/artefakte/` eingebetteten Prüfartefakte stammen von Dritten und werden
**unverändert** weitergegeben. Ihre Lizenzen gelten für sie weiter:

| Verzeichnis | Inhalt | Herkunft | Lizenz |
|---|---|---|---|
| `kosit/cii`, `kosit/ubl`, `kosit/xrechnung`, `kosit/scenarios-*.xml` | KoSIT-Validator-Konfiguration XRechnung 3.0.2 (Stand 2026-08-31): kompilierte Schematron-XSLTs, XSDs, Szenarien | https://github.com/itplr-kosit/validator-configuration-xrechnung | Apache-2.0 (Konfiguration, XRechnung-Schematron) |
| `kosit/cii/EN16931-CII-validation.xsl`, `kosit/ubl/EN16931-UBL-validation.xsl` | EN 16931 Schematron (CEN/TC 434), von KoSIT kompiliert (Referenz) | https://github.com/ConnectingEurope/eInvoicing-EN16931 | EUPL-1.2 |
| `kosit/cen/*.sch` | EN 16931 Schematron-Quellen, Release validation-1.3.16, mit `scripts/schematron-vorverarbeiten.py` zusammengeführt (Includes, abstrakte Muster) | https://github.com/ConnectingEurope/eInvoicing-EN16931/releases/tag/validation-1.3.15 | EUPL-1.2 |
| `kosit/ubl/*/*.xsd` | OASIS UBL 2.1 XML Schemas | https://docs.oasis-open.org/ubl/os-UBL-2.1/ | OASIS IPR (freie Nutzung) |
| `kosit/cii/*.xsd` | UN/CEFACT Cross Industry Invoice D16B | https://unece.org/trade/uncefact | UN/CEFACT (freie Nutzung) |
| `kosit/scenarios-en16931-alle.xml` | Promaris-Szenarien (EN16931 für jeden Beleg) | dieses Repo | MIT OR Apache-2.0 |
| `mustang/xslt`, `mustang/schema`, `mustang/sch`, `mustang/cii` | Factur-X 1.0 / ZUGFeRD 2.x (ZF_250): Schematron-XSLTs, Codelisten, XSDs; `sch/` = Schematron-Quellen mit eingesetzten Codelisten (`scripts/facturx-codelisten-einsetzen.py`) | Mustang 2.26.0 (`Mustang-CLI.jar`), ursprünglich FeRD / FNFE-MPE | Apache-2.0 (technische Artefakte; via Mustang u. FeRD-Nutzungsrechte) |
| `mustang/xr` | XRechnung 3.0 Schematron-XSLTs (CII/UBL) aus Mustang | Mustang 2.26.0 / KoSIT | Apache-2.0 |
| `mustang/ubl` | EN 16931 UBL Schematron-XSLT aus Mustang | Mustang 2.26.0 / CEN | EUPL-1.2 |
| `crates/core/tests/belege` | Beispiele der XRechnung-Testsuite | https://github.com/itplr-kosit/xrechnung-testsuite | Apache-2.0 |

Mustang selbst (Java) steht unter Apache-2.0; von ihm ist kein Code enthalten, nur die
ausgelieferten Artefakte. Die Engine `oxixml` steht unter Apache-2.0.

Die ZUGFeRD-/Factur-X-**Artefakte** (Schemata und Schematron) stehen laut FeRD unter
Apache-2.0 und sind frei weitergebbar (FeRD, „Haftungsausschluss und Nutzungsrechte
ZUGFeRD"). Geschützt ist nur der ZUGFeRD-/Factur-X-**Spezifikationstext** (PDF, Texte,
Bilder; Copyright AWV e.V.) — dieser ist hier **nicht** enthalten. Die FNFE-MPE-
Registrierung betrifft allein den Download der Originalpakete, nicht die Weitergabe der
Artefakte.

Die vollständigen Lizenztexte liegen dem Repo bei: `LICENSE-MIT`, `LICENSE-APACHE` (für
den Rust-Code und die Apache-2.0-Artefakte) sowie `LICENSE-EUPL` (für die
EUPL-1.2-Artefakte). Die UN/CEFACT- und OASIS-Schemas tragen ihre Copyright-Vermerke in den
jeweiligen Dateien und werden unverändert weitergegeben.
