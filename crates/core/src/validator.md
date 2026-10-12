# `validator.rs` — zentraler Einstieg

## Zweck
Die Datei stellt den `Validator` bereit, der pro Thread die kompilierten XSLT-/XSD-Artefakte sowie die geladenen KoSIT-Stufen hält. Er ist der einheitliche Einstieg für XML- und PDF-Prüfungen mit KoSIT/XRechnung und Mustang/ZUGFeRD.

Öffentliche Methoden:
- `new()` / `Default` – neuer Validator, Artefakte werden lazy kompiliert.
- `mit_stack(bytes)` – Stack-Zusage der Engine anpassen (Standard `STACK_BYTES`, 64 MiB).
- `vorwaermen()` – alle Artefakte beider Prüfpfade vorab kompilieren.
- `kosit(xml, szenarien)` – KoSIT-Prüfung eines XML-Belegs.
- `mustang(xml)` – Mustang-Prüfung eines XML-Belegs.
- `beide(xml, szenarien)` – KoSIT und Mustang auf demselben geparsten Dokument.
- `kosit_pdf(pdf, szenarien)` – eingebettetes XML einer ZUGFeRD/Factur-X-PDF extrahieren und KoSIT-prüfen.
- `beide_pdf(pdf, szenarien)` – eingebettetes XML einmal extrahieren und beide Werkzeuge ausführen.

`beide*` liefert ein `Doppelergebnis`: `(Result<Bericht, Fehler>, Result<Bericht, Fehler>)`.

## Begründung & Designentscheidungen
Ein Exemplar je Thread ist nötig, weil die kompilierten Artefakte im `Cache` nicht `Send` sind. Ein globaler Mutex würde parallele Prüfungen serialisieren; deshalb hält jeder Worker-Thread seinen eigenen `Validator`.

Die Kompilierung erfolgt absichtlich lazy: Der erste Aufruf einer Prüfmethode kompiliert je nach Pfad. `vorwaermen()` ermöglicht Diensten, diese Kosten zu Dienstbeginn zu tragen.

Die `stack_bytes`-Einstellung wird der Engine als Zusage mitgegeben. Der aufrufende Thread muss diesen Stack tatsächlich besitzen, sonst droht ein Stack-Overflow. In einer CLI/Dienst-Startroutine ist das Muster:
`std::thread::Builder::new().stack_size(Validator::STACK_BYTES).spawn(...)`.
Für WASI muss zusätzlich der Shadow-Stack passen (`-zstack-size` und `max_wasm_stack`).

`beide()` parst das XML genau einmal und reicht dieselbe `Dokument`-Referenz an beide Engines; das spart XML-Parsing gegenüber zwei Einzelaufrufen.

## Umgesetzte Norm
Die Datei implementiert selbst keine einzelnen EN16931-Regeln. Die Regel- und Schemaprüfung liegt in den Modulen `kosit` und `mustang`.

- `kosit`/`kosit_pdf` leiten an die KoSIT-Engine weiter; die `Szenarien` steuern das Prüfprofil (z. B. XRechnung, ZUGFeRD/Factur-X nach KoSIT).
- `mustang`/`beide` nutzen die Mustang-Engine für ZUGFeRD/Factur-X.
- `beide*` kombiniert beide Sichten auf denselben Beleg; der Aufrufer kann die Ergebnisse getrennt auswerten.

Damit werden EN16931-konforme Rechnungen über die spezifischen Prüfprofile XRechnung und ZUGFeRD/Factur-X abgedeckt, soweit die darunterliegenden Engines sie umsetzen.

## Bewusste Nicht-Entscheidungen
- Kein globaler Singleton, kein `lazy_static`/`once_cell` mit `Sync`; das würde die Parallelität einschränken.
- Kein automatisches Erzeugen von Threads; der Aufrufer ist für die Stackgröße verantwortlich.
- Keine PDF-Manipulation; es wird ausschließlich das eingebettete Rechnungs-XML gelesen.
- Keine eigene XML-Parser-Konfiguration in dieser Datei; die Sicherheitseinstellungen des Parsers liegen in `Dokument::parse`.
- Keine Persistenz des Cache über Prozessgrenzen.
