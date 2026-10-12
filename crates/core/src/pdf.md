# pdf.rs — Eingebettetes Rechnungs-XML aus ZUGFeRD/Factur-X-PDF

## Zweck

Diese Datei extrahiert das eingebettete Rechnungs-XML (EN 16931) aus einer ZUGFeRD- bzw. Factur-X-PDF. Die Funktion `eingebettetes_xml` erhält die PDF-Bytes und liefert ein Tupel `(Dateiname, XML-Text)` zurück. Die eigentliche Validierung der Rechnung erfolgt später durch den XML-Validator; hier wird ausschließlich der Container geöffnet und der Anhang entpackt.

## Begründung & Designentscheidungen

- **Trennung von Container und Inhalt**: Die PDF-Verarbeitung ist strikt auf das Auffinden und Dekomprimieren des XML-Anhangs beschränkt. Die Rechnungsprüfung (`Validator::kosit`) arbeitet ausschließlich auf dem gewonnenen XML-String. Dadurch bleibt die Kernlogik unabhängig vom Transportformat.
- **Reiner Rust unter WASI**: Die Implementierung nutzt `lopdf` und `flate2`/`miniz_oxide` ohne plattformspezifische Abhängigkeiten. Sie kompiliert unverändert für `wasm32-wasip2` und kann damit in einer sicherheitsbeschränkten WebAssembly-Komponente ausgeführt werden.
- **Doppelte Verankerung berücksichtigen**: Gemäß Factur-X/PDF/A-3 ist der XML-Anhang sowohl im Namensbaum `/Names/EmbeddedFiles` als auch als Associated File `/AF` des Katalogs verankert. Beide Stellen werden gelesen, um robust zu sein.
- **Konservative Auswahl**: Zuerst werden bekannte Dateinamen (siehe Norm) mit Vorrang gesucht. Falls keiner passt, wird der erste Anhang mit der Endung `.xml` als Fallback akzeptiert. Dies ermöglicht die Verarbeitung von Dateien, die nicht exakt dem ZUGFeRD-Namensschema folgen, aber dennoch ein Rechnungs-XML enthalten.
- **Schutz gegen entartete Namensbäume**: Die Rekursion über `/Kids` ist auf eine Tiefe von 64 begrenzt, um Stacküberläufe bei zyklischen oder extrem tiefen Strukturen zu verhindern.
- **Dekomprimierungsfallback**: Schlägt das Dekomprimieren des Streams fehl (z. B. unbekannter Filter), wird der Rohinhalt verwendet. Die spätere UTF-8-Prüfung stellt sicher, dass nur gültiger XML-Text durchkommt.

## Umgesetzte Norm

- **ZUGFeRD 2 / Factur-X** (basierend auf EN 16931): Der eingebettete XML-Anhang trägt den Dateinamen `factur-x.xml`.
- **Ältere/alternative Varianten**: `zugferd-invoice.xml`, `xrechnung.xml`, `order-x.xml` werden ebenfalls erkannt, da sie in der Praxis vorkommen.
- **PDF/A-3**: Die Verankerung über den Katalogeintrag `/AF` (Associated Files) wird ausgelesen; das Vorhandensein von `/AF` mit korrektem `AFRelationship` ist für Factur-X vorgeschrieben.
- **Filespec-Struktur**: Der Dateiname wird aus `/UF` bzw. `/F` gelesen; der Datenstrom aus `/EF/F` bzw. `/EF/UF`. Die Namensdekodierung unterstützt UTF-16BE (BOM `FE FF`) und druckbares ASCII (für PDFDocEncoding-kompatible Standardnamen).
- **Auswahlreihenfolge**: Die Konstante `BEKANNTE` definiert die Priorität: `factur-x.xml`, `zugferd-invoice.xml`, `xrechnung.xml`, `cii.xml`, `order-x.xml`. Erst danach wird nach beliebigen `.xml`-Dateien gesucht.

## Bewusste Nicht-Entscheidungen

- **Keine PDF/A- oder veraPDF-Prüfung**: Die Funktion validiert nicht die PDF/A-Konformität des Containers, sondern nur die Rechnung selbst. Das WIT-Feld `pdf-bericht.pdf-a` bleibt daher leer und ist für eine separate Prüfung reserviert.
- **Kein Rendern, kein Text-Layer**: Nur die eingebettete Datei wird extrahiert; visuelle Inhalte oder Texterkennung werden nicht verwendet.
- **Keine Entschlüsselung**: Passwortgeschützte oder verschlüsselte PDFs werden nicht unterstützt; `Document::load_mem` schlägt in diesem Fall fehl.
- **Keine Größenbegrenzung für entpackte Daten**: (Hinweis: In der aktuellen Implementierung fehlt eine Begrenzung der dekomprimierten XML-Größe; dies wird als bekanntes Verbesserungspotenzial geführt. In zukünftigen Versionen sollte eine Obergrenze eingeführt werden.)
- **Keine Konfliktprüfung bei mehreren gleichnamigen Anhängen**: Bei doppelter Verankerung derselben Datei in `/Names` und `/AF` wird ohne weitere Prüfung der erste Treffer verwendet. Eine tiefere Konsistenzprüfung ist nicht Teil dieses Moduls.
