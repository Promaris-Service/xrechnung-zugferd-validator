# `kosit` – Validierungsablauf nach KoSIT

## Zweck

Dieses Modul bildet den Ablauf des KoSIT-Validators (XRechnung-Konfiguration) in Rust nach. Es orchestriert die einzelnen Validierungsschritte:

1. Auswahl des Prüfszenarios anhand von Syntax und Kennung (Umsetzung der `scenarios.xml`).
2. XML-Schema-Validierung (XSD) gegen die offiziellen XRechnung-Schemata.
3. Schematron-Validierung durch Ausführung der zugehörigen XSLT-Stylesheets.
4. Anwendung der „customLevel“-Stufen aus `scenarios.xml` auf die gefundenen Prüfregeln.
5. Annahmeentscheidung: Das Dokument wird akzeptiert, wenn keine relevanten Fehler (entsprechend der Stufen) vorliegen.

Das Modul stellt die öffentliche Schnittstelle über Re-Exports bereit:

- `pruefe`: Die zentrale Funktion zum Starten der Validierung.
- `Stufen`: Typ zur Abbildung der customLevel-Zuordnung.
- `Szenarien`: Typ zur Repräsentation der wählbaren Szenarien.
- `ALLE_XSD`, `ALLE_XSLT`: Konstanten mit den benötigten Artefakt-Pfaden bzw. -Referenzen.

## Begründung & Designentscheidungen

- **Nachbildung des Referenzvalidators**: Der Ablauf entspricht bewusst dem des etablierten `de.kosit.validationtool`, um kompatible Ergebnisse zu erzielen und auf die offiziellen Prüfartefakte zurückgreifen zu können.
- **Modulare Aufteilung**: Die Verantwortlichkeiten sind auf drei Untermodule verteilt:
  - `szenario`: Nachbildung der Szenarienauswahl inklusive aller Definitionen aus `scenarios.xml`.
  - `stufen`: Zuordnung von Regel-IDs zu den jeweiligen Stufen je Szenario (customLevel).
  - `pruefung`: Steuerung des eigentlichen Validierungsflusses (XSD → XSLT → Stufen → Annahme).
- **Schlanke öffentliche API**: Nur die tatsächlich benötigten Typen und Funktionen werden re-exportiert; die internen Module bleiben privat. Dies kapselt die Implementierung und erleichtert spätere Änderungen.
- **Verwendung der Original-Artefakte**: Es werden keine eigenen Prüfregeln implementiert; stattdessen werden die offiziellen XSD-Schemata und Schematron-XSLT der KoSIT/XRechnung verwendet.

## Umgesetzte Norm

- **EN 16931**: Europäische Norm für elektronische Rechnungen (vgl. CEN/TC 434).
- **XRechnung**: Deutsche Anwendung der EN 16931 (CIUS) mit den zugehörigen Geschäftsregeln (BR-KOSIT-…).
- **KoSIT-Validator-Regeln**: Die Szenarienlogik und die Stufen (customLevel) entsprechen der offiziellen `scenarios.xml` der KoSIT. Durch die Ausführung der mitgelieferten XSD- und Schematron-Artefakte werden alle dort definierten Prüfregeln angewendet.
- **Mustang-Projekt (optional)**: Falls die Artefakte aus dem Mustang-Projekt stammen, gelten zusätzlich deren Konformitätsregeln – das Modul selbst ist jedoch formatagnostisch und nutzt nur die bereitgestellten XSD/XSLT.

## Bewusste Nicht-Entscheidungen

- **Kein HTML-Report und kein `rep:`-XML**: Der Original-Validator erzeugt einen detaillierten HTML-Bericht und ein XML im `rep:`-Format. Dieses Modul verzichtet darauf. Stattdessen wird ein eigener, strukturierter `Bericht` erzeugt, der dieselben Informationen (Regel, Stufe, Ort, Text) in einem formatunabhängigen Datenmodell trägt.
- **Kein direkter Dateizugriff auf Konfigurationsdateien**: `scenarios.xml` und andere Konfigurationsdateien werden nicht zur Laufzeit eingelesen. Ihre Inhalte sind als Konstanten bzw. Tabellen im Code abgebildet (siehe `szenario.rs`, `stufen.rs`).
- **Keine externe Prozessausführung**: Alle Schritte (XSD-Validierung, XSLT-Transformation, Stufenbewertung) werden innerhalb des Rust-Prozesses durchgeführt, ohne dass der Java-basierte KoSIT-Validator oder ein externes Tool aufgerufen wird.
- **Keine eigene Regel-Engine**: Die eigentliche Prüfung der Geschäftsregeln erfolgt ausschließlich über die offiziellen Schematron-XSLT; es gibt keine zusätzliche Rust-Implementierung einzelner Regeln.
