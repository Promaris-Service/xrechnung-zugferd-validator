# main.rs – CLI-Einstiegspunkt

## Zweck
Die Datei `main.rs` ist der Einstiegspunkt des Kommandozeilen-Validators `erechnung-validator`. Sie liest die Argumente, startet die Validierung über die Module `aufruf` und `lauf` und übersetzt das Ergebnis in einen Prozess-Exit-Code (0 = alle Belege gültig, 1 = mindestens ein Beleg wurde abgelehnt, 2 = Aufruf-/Verarbeitungsfehler). Die eigentliche Prüf- und Berichtslogik ist in den Modulen gekapselt.

## Begründung & Designentscheidungen
- **Trennung von Aufruf, Lauf und Hauptprogramm:** `aufruf` übernimmt das Parsen der Kommandozeile, `lauf` steuert die Validierung. `main` bleibt schmal und testbar.
- **Nativer Allokator:** Unter nativen Zieltriples wird `mimalloc::MiMalloc` als globaler Allokator gesetzt. Er ist auf hohen Durchsatz bei vielen kleinen Allokationen ausgelegt, wie sie beim XML-Parsen und Validieren auftreten. Unter WASI wird bewusst darauf verzichtet, um Abhängigkeiten und mögliche Inkompatibilitäten zu vermeiden.
- **Einheitliches Verhalten:** Die Kommentare legen fest, dass nativ mehrere Validator-Worker parallel laufen können, während die WASI-Command-Component mit einem Thread auskommt und dasselbe Ergebnisformat liefert.
- **Exit-Code-Konvention:** Fehler in der Kommandozeile werden mit Hilfetext auf `stderr` und Code 2 beantwortet; Validierungsergebnisse führen zu Code 0 oder 1.

## Umgesetzte Norm
Diese Datei setzt selbst keine EN16931-/KoSIT-/XRechnung-/ZUGFeRD-Prüfregel um. Sie delegiert die Validierung an `lauf::starte`, das die eigentlichen Regelprüfungen der EN16931 (z. B. nach KoSIT/XRechnung oder Mustang) anwendet. Die Auswahl der Prüfprofile erfolgt durch die Kommandozeilenoptionen `--kosit`, `--mustang`, `--beide` sowie `--szenarien`.

## Bewusste Nicht-Entscheidungen
- **Keine Differenzierung der Fehler-Exit-Codes in `main`:** Derzeit erhalten sowohl Aufruffehler als auch Fehler aus `lauf::starte` den Exit-Code 2. Eine feinere Unterscheidung (z. B. 2 für Aufruf, 3 für Laufzeit) ist nicht umgesetzt.
- **Kein eigenes Logging oder Tracing:** Die Ausgabe erfolgt direkt auf `stdout`/`stderr`; es wird kein Logging-Framework initialisiert.
- **Keine Behandlung von Panics:** Panics aus den Modulen werden nicht abgefangen; dies ist für ein Kommandozeilenwerkzeug bewusst einfach gehalten.
