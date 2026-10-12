# `schema.rs` – XSD-Kompilierung und -Prüfung

## Zweck
Die Datei kompiliert aus den eingebetteten XSD-Artefakten einen `SchemaSet`, löst alle `schemaLocation`-Verweise über den Speicher auf und stellt mit `pruefe` eine einfache XSD-Validierung für Belege bereit.

## Begründung & Designentscheidungen
- `SpeicherResolver` verhindert Dateisystem- und Netzzugriffe und macht die Validierung WASI-tauglich sowie deterministisch.
- Die Auflösung erfolgt gegen den eingebetteten Artefaktbestand; `artefakte::finde_uri` liefert nur Treffer für bekannte URIs, nicht für beliebige Pfade.
- Die Wurzel-XSD wird über `artefakte::finde` und `artefakte::uri` geladen, anschließend mit `SchemaSet::add_document` eingebracht und kompiliert.
- Fehler aus `add_document` und `compile` werden als `Fehler::Engine` gekapselt; die Validierungsergebnisse werden in `pruefe` in die Report-übliche Form `Code Meldung @ Pfad` umgewandelt.

## Umgesetzte Norm
Die Datei ist für die XSD-Syntaxstufe der EN-16931-Konformität zuständig. Die konkret geprüfte Syntax hängt vom übergebenen `pfad` ab; die Artefakte decken unter anderem UBL 2.1, UN/CEFACT CII D16B sowie Factur-X-/ZUGFeRD-Profile ab. Schematron- und Geschäftsregelprüfungen sind nicht Teil dieser Datei.

## Bewusste Nicht-Entscheidungen
- Keine Schematron-/Geschäftsregelprüfung; diese ist separat umgesetzt.
- Keine Netzwerk- oder Dateisystem-Auflösung: unbekannte URIs liefern `Ok(None)` und werden nicht extern nachgeladen.
- Keine strukturierten Fehlerobjekte in `pruefe`; bewusst nur menschen-/reportlesbare Textzeilen.
- `validate_str` parst den Beleg erneut. Der zusätzliche Aufwand ist akzeptiert, um den XML-Text unverändert weiterreichen zu können.
- Der Schemasatz wird bei jedem `kompiliere`-Aufruf neu aufgebaut; Caching ist ausdrücklich nicht Bestandteil dieser Datei.
