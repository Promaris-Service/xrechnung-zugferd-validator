# `fehler.rs` — Fehlerarten

## Zweck

Die Datei definiert den oeffentlichen Fehlertyp `Fehler` der Kern-Crate. Er fasst alle Zustaende zusammen, in denen eine Pruefung nicht stattfinden konnte. Dazu gehoeren technische Ablehnungen des Dokuments, fehlende Szenarien, unbekannte Profile und interne Engine-Fehler.

Validierungsbefunde am eigentlichen Beleg sind ausdruecklich keine `Fehler` dieser Datei, sondern erscheinen im Pruefbericht.

## Begruendung & Designentscheidungen

Die Trennung zwischen `Fehler` und Berichtsbefunden ist zentral: Ein Abnehmer muss „Beleg ist ungueltig“ von „Werkzeug konnte nicht pruefen“ unterscheiden koennen. Ein technischer Fehler darf niemals als bestandene Pruefung interpretiert werden.

Die Modellierung als Enum mit String-Meldungen erlaubt eine einfache, typisierte Fehlerbehandlung, ohne dass Aufrufer Zeichenketten parsen muessen. `Display` und `std::error::Error` machen den Typ in normalen Rust-Fehlerpfaden (`Result<T, Box<dyn Error>>` u. Ae.) nutzbar.

## Umgesetzte Norm

Die Datei setzt keine einzelne EN16931-, KoSIT- oder XRechnung-Pruefregel um. Sie bildet jedoch eine Vorbedingung der Pruefarchitektur ab:

- `KeinSzenario`: Wenn zu einer CustomizationID/Guideline-ID kein passendes KoSIT-Szenario bekannt ist, muss der Beleg abgelehnt werden, statt mit unpassenden Regeln geprueft zu werden.
- `UnbekanntesProfil`: Wenn die verwendete Engine ein Profil nicht kennt, ist eine zuverlaessige Pruefung ebenfalls nicht moeglich.
- `Dokument`: Nicht wohlgeformtes XML oder ein unbekannter Rechnungstyp verhindert schon vor der eigentlichen Regelpruefung jede weitere Verarbeitung.

## Bewusste Nicht-Entscheidungen

- Der Typ liefert keine maschinell auswertbaren Fehlercodes; die Unterscheidung erfolgt ueber die Enum-Varianten.
- Es gibt keine `source`-Kette: Die Ursache wird nur als formatierte Meldung transportiert, da der Aufrufer hier eine klare Endzustands-Sicht benoetigt.
- `Dokument` buendelt syntaktische und semantische Ablehnungen bewusst in einer Variante. Wer XML-Parserfehler von „unbekannter Rechnungstyp“ unterscheiden muss, sollte dies ueber die erzeugte Meldung oder eine spätere Aufsplittung loesen.
- Da der Typ oeffentlich ist, sollten externe Nutzer bei `match` einen Wildcard-Arm vorsehen, wenn sie zukuenftige Erweiterungen vertragen wollen.
