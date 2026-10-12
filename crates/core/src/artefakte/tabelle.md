## Zweck

`tabelle.rs` stellt zwei statische, schreibgeschützte Tabellen bereit: `KOSIT` und `MUSTANG`. Jede Tabelle enthält `Datei`-Einträge mit einem logischen Artefaktpfad (`pfad`) und dem vollständigen Inhalt (`text`) der zugehörigen Prüfdateien. Die Datei wird maschinell von `scripts/artefakte-tabelle.py` erzeugt und darf nicht von Hand geändert werden.

Die Tabelle sorgt dafür, dass alle für die Validierung benötigten Schematron-, XSD-, XSLT- und Szenariodateien zur Laufzeit ohne Dateisystemzugriff verfügbar sind. Das ist insbesondere für WASI-Ziele relevant, bei denen kein verlässliches Dateisystem existiert.

## Begruendung & Designentscheidungen

- **Compile-Time-Einbettung:** `include_str!` bindet die Artefakte bereits beim Kompilieren ein. Dadurch bleibt die ausgelieferte Binary unabhängig von externen Dateien, Verzeichnissen und relativen Pfaden zur Laufzeit.
- **Zweigeteilte Tabellen:** `KOSIT` bündelt die Validierungsartefakte des KoSIT-Regelwerks, `MUSTANG` die des Mustang-Projekts. Diese Trennung bildet die beiden Regelwerksfamilien ab und erleichtert die gezielte Auswahl.
- **Stabile logische Pfade:** Die `pfad`-Werte beschreiben das Auslieferungslayout der Artefakte. Sie sind nicht zwingend identisch mit den Dateisystempfaden des Builds und dienen als Schlüssel für die spätere Artefaktauswahl.
- **Maschinelle Erzeugung:** Pfade und Inhalte stammen aus dem Artefaktbestand unter `artefakte/`. Das Skript `scripts/artefakte-tabelle.py` erzeugt die Einträge; manuelle Eingriffe würden beim nächsten Lauf überschrieben.
- **Größe statt Laufzeit:** Das Einbetten erhöht die Binärgröße signifikant, vermeidet aber Dateisystemzugriffe, Komprimierung und fehlerhafte relative Pfade zur Laufzeit.

## Umgesetzte Norm / Regelwerke

- **KoSIT:** EN16931-Validierung für CII und UBL in der Version 1.3.16, inklusive der Basisschemas (`CrossIndustryInvoice_*_100pD16B.xsd`), UBL-2.1-Komponenten, XRechnung-XSLTs und Prüfszenarien.
- **Mustang/ZUGFeRD:** Factur-X-Profile BASIC-WL, BASIC, EN16931, EXTENDED und MINIMUM als Schematron, XSD und XSLT. Zusätzlich CII-/UBL-Validierung und XRechnung-Versionen 1.2, 2.0, 2.1, 2.2, 2.3 und 3.0.
- Die konkreten Dateinamen in der Tabelle enthalten die jeweiligen Versionsstände. Änderungen an den Artefakten oder Versionsständen gehören in den Artefaktbestand und das Generierungsskript, nicht in diese Datei.

## Bewusste Nicht-Entscheidungen

- Keine Laufzeit-Validierung oder Signaturprüfung der eingebetteten Artefakte; die Integrität wird über den Build-Prozess sichergestellt.
- Keine Lazy-Loading- oder Hashmap-Struktur in dieser Datei; die Suche nach Artefakten kann außerhalb über die Arrays erfolgen.
- Keine automatische Auflösung von XSD-Imports innerhalb der Tabelle. Falls ein Import auf eine andere eingebettete Datei zeigt, muss die Zuordnung in der Validierungslogik erfolgen.
- Keine Verschlüsselung oder Komprimierung der Inhalte; Transparenz und einfache Debuggbarkeit stehen im Vordergrund.
