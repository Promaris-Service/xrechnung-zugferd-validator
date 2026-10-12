# antwort.rs – Antwortformat (JSON-Schema)

## Zweck
Datenstrukturen für die JSON-Antwort des Validierungsdienstes. Die Datei enthält ausschließlich serialisierbare Typen (`serde::Serialize`) und keine Geschäftslogik. Sie stellt das Schema für die Web-UI zentral bereit.

## Begruendung & Designentscheidungen
- **Zentrale Schemadefinition:** Transport, Ausführung und UI greifen auf dasselbe Format zu.
- **Optionale Felder:** `eingebettet`, `pdf_a`, `mustang` und `mustang_hinweis` werden über `skip_serializing_if` nur bei Bedarf ausgegeben.
- **Getrennte Prüferberichte:** KoSIT ist als Tor immer vorhanden, Mustang optional.
- **Summentyp `Urteil`:** Intern wird zwischen Erfolgsbericht, Fachfehler und Grenzfehler unterschieden; die HTTP-Schicht wählt die passende konkrete Struktur.

## Umgesetzte Norm
Die Struktur bildet die Ergebnisse der EN-16931-Prüfung ab:
- `regel`: Regel-ID (z. B. BR-S-05, CII-SR-013, BR-DE-1).
- `stufe`: Einstufung als `information`, `warnung` oder `fehler`.
- `flag`: SVRL-flag (fatal, warning, leer).
- `xsd.gueltig`: Ergebnis der XSD-Validierung.
- `angenommen`: Gesamturteil (XSD bestanden und kein Befund der Stufe `fehler`).

## Bewusste Nicht-Entscheidungen
- Keine HTML-/XML-Reportausgabe; das JSON transportiert dieselbe Information.
- Keine Deserialisierung (`Deserialize`), da nur Antworten erzeugt werden.
