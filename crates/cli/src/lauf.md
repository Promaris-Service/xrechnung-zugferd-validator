# lauf.rs – Verteilung und Prüfung

## Zweck
Dieses Modul startet die Stapelprüfung aller gefundenen XML-Dateien. Es liest die CLI-Optionen, ermittelt die Anzahl der Prüfthreads, verteilt die Dateien auf Worker, führt pro Datei den konfigurierten Validator aus, gibt eine Ergebniszeile je Bericht aus und liefert `true`, wenn alle Berichte angenommen wurden.

## Begründung & Designentscheidungen
- **Eigener Validator je Worker**: Die kompilierten Validierungsartefakte sind nicht `Send`. Deshalb erhält jeder Worker eine eigene `Validator`-Instanz.
- **64-MiB-Stack**: Die EN-16931-Stylesheets rekursieren tief. Der vergrößerte Stack verhindert Stack-Overflow in den Worker-Threads.
- **Reißverschlussverteilung**: Dateien werden als `skip(i).step_by(threads)` verteilt, nicht als zusammenhängende Blöcke. Das vermeidet, dass ein Worker mehrere langsame Belege hintereinander erhält, während andere leer laufen.
- **Ergebnisreihenfolge**: Jede Datei bekommt ihren Originalindex. Der Sammler legt die Worker-Ergebnisse in einen `Vec<Option<Vec<_>>>` an der passenden Stelle ab; dadurch bleibt die Eingabereihenfolge erhalten.
- **WASI-Sonderweg**: Unter WASI wird mit genau einem Thread gearbeitet, weil dort keine nativen Threads sinnvoll verfügbar sind; der übrige Codepfad ist identisch.
- **Ausgabeformate**: JSON pro Zeile oder tab-getrennte Kurzform. Fehler werden als eigene Zeilen mit `FEHLER` bzw. JSON-Fehlerobjekt ausgegeben.

## Umgesetzte Norm
Das Modul implementiert keine einzelne EN16931-Regel selbst. Es orchestriert die Prüfungen:
- `Validator::kosit` prüft gegen die KoSIT/XRechnung-Regeln (EN 16931 mit deutschen CIUS-Regeln). Der Parameter `o.szenarien` steuert das Prüfszenario.
- `Validator::mustang` prüft mit der Mustang-Engine.
- `Validator::beide` führt beide Prüfungen aus und liefert die Einzelberichte.

Die eigentliche Normanwendung liegt in `erechnung_validator`. Dieses Modul ist nur für Dateiauswahl, Verteilung, Ausgabe und Gesamtstatus verantwortlich.

## Bewusste Nicht-Entscheidungen
- Keine eigene XML-Parsing- oder Prüflogik; das Modul bleibt reine Orchestrierung.
- Keine stille Fortsetzung nach Lesefehlern. Eine nicht lesbare Datei wird als Fehlerzeile ausgegeben und der Gesamtstatus wird `false`.
- Kein Streaming der Ausgabe. Die native Verteilung sammelt alle Ergebniszeilen im Speicher und gibt sie erst nach Abschluss in Eingabereihenfolge aus. Das wird zugunsten deterministischer Reihenfolge in Kauf genommen.
- Keine Sortierung der Eingabedateien. Die Reihenfolge stammt aus den CLI-Pfaden.
