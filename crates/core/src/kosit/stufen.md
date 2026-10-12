# `stufen.rs` — customLevel

## Zweck (was)
Die Datei liest die in der eingebetteten KoSIT-Szenariendatei `kosit/scenarios-xrechnung-3.0.2.xml` enthaltenen `<customLevel>`-Einträge und stellt daraus eine Abbildung bereit:

- pro Szenarioname (`name`)
- pro Regel-ID aus dem Textinhalt eines `customLevel`
- auf eine Validierungsstufe (`Stufe`: Fehler, Warnung, Hinweis, …)

Die öffentliche Methode `Stufen::stufe(szenario, regel)` liefert genau dann eine `Option<Stufe>`, wenn für dieses Szenario ein customLevel-Eintrag für die Regel existiert. Andernfalls bleibt es dem Aufrufer überlassen, die normale Regelbewertung zu verwenden.

## Begruendung & Designentscheidungen (warum)
Die Stufen für bestimmte Regeln sind eine fachliche Entscheidung der KoSIT und ändern sich mit jeder Konfigurationsfassung. Statt diese Overrides im Rust-Code zu duplizieren, bleibt die offizielle XML-Datei die Quelle. Der Rust-Code ist nur ein Leser.

Die Abbildung wird beim Aufruf von `laden()` einmal aus der eingebetteten Datei aufgebaut. Ein leerer oder nicht lesbarer Artefaktstand führt derzeit zu einer leeren Abbildung; der Aufrufer erhält keine Fehlermeldung. Das ist eine bewusste Vereinfachung für die erste Veröffentlichungsstufe, muss aber bei einem robusten Paketaufbau bedacht werden.

Die Textinhalte der `<customLevel>`-Elemente werden mit `split_whitespace` in einzelne Regel-IDs zerlegt. Das erlaubt die in der Szenariendatei übliche Notation mehrerer Regeln pro Element, getrennt durch Leerzeichen oder Zeilenumbrüche.

## umgesetzte Norm (welche EN16931/KoSIT/Mustang/XRechnung-Regel)
Die Datei setzt den KoSIT-Validator-Mechanismus `customLevel` aus der Szenarienbeschreibung (`scenarios.xml`) um. Für XRechnung 3.0.2 ist das eingebettete Artefakt:

- `kosit/scenarios-xrechnung-3.0.2.xml`
- relevante XML-Struktur:
  - `<scenario><name>…</name><customLevel level="warning|error|…">BR-…</customLevel></scenario>`
- Die Zuordnung wirkt als Override auf die reguläre Regelbewertung; Beispiel: `BR-CL-23` ist in `EN16931 XRechnung (UBL Invoice)` eine Warnung.

Die konkrete XRechnung-Version ist 3.0.2. Weitere Szenarien (z. B. reine EN16931) werden ebenfalls gelesen, sofern sie in derselben Datei enthalten sind.

## bewusste Nicht-Entscheidungen
- **Kein Laufzeit-Fehler bei fehlendem/nicht lesbarem Artefakt:** `laden()` gibt bei fehlender Datei oder XML-Parsefehler `Stufen::default()` zurück. Dadurch werden customLevel-Overrides in diesem Fall nicht angewendet.
- **Kein konfigurierbarer Artefaktpfad:** Die Quelldatei ist im Code hart mit `kosit/scenarios-xrechnung-3.0.2.xml` benannt. Ein Versionswechsel erfordert derzeit eine Anpassung an dieser Stelle.
- **Keine dynamische Aktualisierung oder Cache-Invalidierung:** Die Daten werden bei jedem Aufruf von `laden()` neu gelesen; es gibt keinen globalen Cache.
- **Keine Behandlung mehrfacher `<name>`-Kinder innerhalb eines Szenarios:** Es wird das erste passende Element verwendet.
- **Keine Bewertung der eigentlichen Prüfregeln:** Diese Datei übernimmt nur die customLevel-Overrides; die Regelbewertung selbst liegt in anderen Modulen.
