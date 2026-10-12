# `aufruf.rs` — Kommandozeilenargumente und Dateisuche

## Zweck

Diese Datei enthält die Argumentauswertung der Kommandozeile sowie die rekursive Suche nach XML-Dateien für den E-Rechnungs-Validator. Sie stellt die Struktur `Optionen` bereit, die alle für einen Validierungslauf relevanten Einstellungen bündelt.

## Begründung & Designentscheidungen

* **Handgeschriebener Parser statt `clap`:** Die CLI soll auch als WASI-Kommando-Komponente klein bleiben und keine Abhängigkeiten mitbringen, die dort unnötig sind. Daher werden Argumente mit einer einfachen Schleife ausgewertet.
* **Fehler als `String`:** Für die Kommandozeile genügt eine einfache, direkt ausgebare Fehlermeldung; ein eigenes Fehlertypsystem wäre Overhead.
* **`--threads 0`:** Der Wert 0 wird als „so viele wie Kerne“ interpretiert (nativ) bzw. in WASI ignoriert. Diese Konvention ist bewusst gewählt, weil sie eine einfache Default-Einstellung erlaubt.
* **`Werkzeug` und `Ausgabe` als Enums:** Die möglichen Werte werden als typisierte Aufzählungen modelliert, um Tippfehler zu vermeiden und die Verwendung in `match`-Ausdrücken zu erleichtern.

## Umgesetzte Norm

Die Datei selbst setzt keine Prüfregeln um, sondern wählt die Szenarien für den Validator aus. Unterstützt werden:

* `xrechnung` → `Szenarien::XRechnung302` (XRechnung 3.0.2)
* `alle` → `Szenarien::En16931Alle` (alle EN16931-Regeln)
* `auto` → `Szenarien::Automatisch` (automatische Erkennung)

Die Zuordnung zu den konkreten Prüfregeln (KoSIT, Mustang, EN16931) erfolgt in der Bibliothek `erechnung_validator`.

## Bewusste Nicht-Entscheidungen

* Keine Unterstützung für kombinierte Kurzflags (z. B. `-jk`).
* Keine Konfigurationsdatei oder Umgebungsvariablen.
* Keine Internationalisierung der Hilfetexte.
* Keine rekursive Symlink-Auflösung mit Zyklenerkennung (Kann zu Problemen führen; für den produktiven Einsatz ggf. nachrüsten).
* Fehlerbehandlung bei nicht lesbaren Verzeichnissen erfolgt stillschweigend; es wird kein Warnhinweis ausgegeben.
