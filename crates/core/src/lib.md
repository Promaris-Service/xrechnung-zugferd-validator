# lib.rs — Crate-Wurzel

## Zweck (Was)

`lib.rs` ist die Crate-Wurzel des E-Rechnungs-Validators. Sie enthält keine eigene Validierungslogik, sondern verdrahtet die internen Module und definiert die öffentliche API.

Öffentlich exportiert werden:

- `Validator` und `Doppelergebnis` aus `validator`
- `Bericht`, `Befund`, `Stufe`, `Syntax`, `Werkzeug` aus `bericht`
- `Szenarien` aus `kosit`
- `Fehler` aus `fehler`
- `ARTEFAKTE` als Versionskennung der eingebetteten Artefakte

Alle übrigen Module bleiben privat und sind nicht Teil der API.

## Begründung & Designentscheidungen (Warum)

Die Crate wird in unterschiedlichen Umgebungen verwendet: nativ als Cargo-Abhängigkeit oder CLI sowie als WASI-Component. Beide Varianten benötigen nur wenige, stabile Typen. Die öffentliche Oberfläche ist daher bewusst klein; interne Module können sich ändern, ohne die WIT-Schnittstelle oder native Abnehmer zu beeinflussen.

Kompilierte Prüfartefakte leben im `Validator`, nicht in globalem Zustand. Sie werden je Thread als Exemplar gehalten, weil die kompilierten Stylesheets der Rust-Engine `oxixml` nicht `Send`/`Sync` sind.

Die Crate setzt auf reines Rust und eingebettete Artefakte. Dadurch entfallen JVM-, C-Abhängigkeiten und externe Dateizugriffe zur Laufzeit.

## Umgesetzte Norm

Diese Datei selbst setzt keine einzelne EN16931-, KoSIT-, Mustang- oder XRechnung-Regel um. Sie bildet den Einstiegspunkt, über den die eigentlichen Prüfpfade erreicht werden:

- `kosit` für die Prüfung nach KoSIT/XRechnung-Konfiguration
- `mustang` für die Prüfung nach Mustang-Validierung
- `bericht` für das gemeinsame Ergebnisformat
- `svrl` für die Übersetzung von SVRL-Ausgaben in Befunde

Die ausgelieferten Prüfartefakte werden zentral über `ARTEFAKTE` versioniert.

## Bewusste Nicht-Entscheidungen

- Kein `unsafe` in dieser Crate; die Rust-Speichersicherheit wird nicht ausgehebelt.
- Kein globaler, veränderlicher Zustand. Validator-Instanzen sind explizit zu erzeugen.
- Keine öffentlichen Re-Exports interner Module wie `artefakte`, `engine`, `svrl` oder `pdf`.
- Keine Parallelitätsannahmen auf Ebene der Crate-Wurzel; die Nutzung mehrerer Threads erfolgt durch getrennte `Validator`-Instanzen.
- Keine eigene XML-/XSLT-Engine. Verarbeitung und Auswertung delegieren an die internen Module und `oxixml`.
