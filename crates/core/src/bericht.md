# Bericht (Ergebnisformat)

## Zweck

`bericht.rs` definiert das gemeinsame, JSON-serialisierbare Ergebnisformat für die beiden Prüfwerkzeuge (KoSIT und Mustang). Ein `Bericht` enthält Metadaten zur Prüfung (Werkzeug, Szenario/Profil, Syntax, Kennung), die XSD-Prüfung, alle Schematron-Befunde und das aggregierte Gesamturteil.

## Begründung & Designentscheidungen

- **Ein Format für zwei Werkzeuge:** Abnehmer müssen nicht zwischen KoSIT- und Mustang-Ergebnissen unterscheiden. Werkzeugspezifische Informationen bleiben erhalten (z. B. `szenario`, `quelle`, `flag`).
- **Stufen statt Roh-Flags:** Die heterogenen `flag`-Werte (`fatal`, `error`, `warning`, `info`, leer) werden auf drei kanonische Stufen `Fehler`, `Warnung`, `Information` abgebildet, damit Filter und Sortierung einheitlich sind. Der Original-`flag` bleibt im Befund erhalten.
- **Unveränderter Meldungstext:** Der `text` eines Befunds wird nicht übersetzt oder bewertet, damit er gegenüber einem Lieferanten nachprüfbar bleibt.
- **Explizite Serialisierung als JSON:** Die Methode `json()` erzeugt eine kompakte JSON-Repräsentation; alle Felder sind über Serde ableitbar.

## Umgesetzte Norm

Das Format selbst setzt keine Prüfregel um, sondern aggregiert Ergebnisse der Schematron-Artefakte. Es orientiert sich an den Ergebnisstrukturen der KoSIT-XRechnung- und Mustang/ZUGFeRD-Prüfung:

- **XSD-Gültigkeit:** `xsd_gueltig` und `xsd_fehler` spiegeln die XML-Schema-Prüfung wider.
- **Schematron-Befunde:** Jeder `Befund` entspricht einem `svrl:failed-assert` oder `svrl:successful-report`; `regel` enthält die Regel-ID (z. B. `BR-DE-1`, `CII-SR-013`).
- **Gesamturteil:** `angenommen` gilt als `true`, wenn die XSD-Prüfung bestanden ist und kein Befund die Stufe `Fehler` hat. Die konkrete Berechnung erfolgt im jeweiligen Werkzeug (KoSIT: customLevel-Abbildung, Mustang: eigener Schematron-Befund ohne `warning`-Flag).

## Bewusste Nicht-Entscheidungen

- Keine Bewertung oder Übersetzung der Meldungstexte; der Wortlaut der Artefakte bleibt erhalten.
- Keine Normalisierung oder Vereinheitlichung der Regel-IDs über die Werkzeuge hinweg.
- Keine Verschmelzung oder Deduplikation von Befunden; alle Meldungen werden einzeln übernommen.
- Keine eigene Ableitung der Syntax aus dem Beleg; der Wert wird vom Aufrufer gesetzt und nur hier deklariert.
- Keine persistente Speicherung oder Ausgabeformat; `json()` liefert nur die Zeichenkette, die Weiterverarbeitung übernimmt der Aufrufer.
