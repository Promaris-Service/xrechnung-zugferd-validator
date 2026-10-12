# `profil.rs` – Profilwahl und Werkzeugketten

## Zweck
Die Datei ordnet einer gemeldeten Belegkennung (`GuidelineID` bei CII, `CustomizationID` bei UBL) ein Validierungsprofil zu. Das Ergebnis ist die Struktur `Werkzeuge` mit:

- `name` für Fehlermeldungen und Logs,
- `xsd` für die Strukturprüfung,
- `xslt` für Schematron-Regeln mit Fehlercharakter,
- `hinweise` für Schematron-Regeln mit Hinweischarakter.

Außerdem exportiert sie `ALLE_XSLT` und `ALLE_XSD`, damit der Aufrufer die benötigten Ressourcen vorwärmen kann.

## Begründung & Designentscheidungen

### Orientierung an Mustang
Die Zuordnung folgt der Logik von `XMLValidator.validate` aus Mustang 2.24. Für CII wird die Guideline-ID, für UBL die CustomizationID ausgewertet. Das hält das Verhalten für gleiche Kennungen vergleichbar mit der Referenzimplementierung.

### Profil-IDs als Teilstrings
Die Kennungen werden vor dem Vergleich in Kleinschreibung betrachtet und über Teilstringtests (`contains`) geprüft. Die Reihenfolge ist absichtlich Teil der Logik: `basicwl` muss vor `basic` geprüft werden, weil die BASIC-WL-URI die BASIC-Zeichenkette enthält. Ebenso muss die XRechnung-Prüfung vor den Factur-X-Profilen liegen.

### Factur-X-Schematron statt kompilierter XSLT
Für die Factur-X-Profile werden Schematron-Dateien verwandt, deren externe Codelisten-Abfragen (`document(...)`) bereits durch Wertlisten ersetzt sind. Das ist deutlich schneller als Mustangs kompilierte XSLTs und liefert bei den geprüften Belegen identische Befunde. Die ursprünglichen XSLTs bleiben als Referenz erhalten.

### XRechnung-Kombinationen
XRechnung (CII) läuft nicht gegen das Factur-X-Hauptschematron, weil dessen Codeliste die XRechnung-Kennung nicht kennt und einen Fehler an `ram:ID` meldet. Stattdessen werden die CEN-EN16931-CII-Kette und die passende XRechnung-CII-Kette hintereinandergeschaltet. Für UBL ist die Kette analog: EN16931-UBL plus XRechnung-UBL.

Die endlichen Kombinationen werden in einer statischen Tabelle (`kette2`) abgelegt, damit die zurückgegebenen Slices `'static` sind.

### Ältere XRechnung-Fassungen
Für ältere XRechnung-Fassungen (1.x, 2.0–2.3) existieren eigene XSLT-Pfade. Sie werden nicht in `ALLE_XSLT` vorgewärmt, weil sie selten sind; die Auswahl erkennt die Version über Teilstrings.

## Umgesetzte Norm
Die Zuordnung betrifft folgende Regelwerke:

- **EN 16931 (CEN)** als europäisches Grundmodell: `urn:cen.eu:en16931:2017`
- **Factur-X / ZUGFeRD 2.x**: MINIMUM, BASIC-WL, BASIC, EN16931, EXTENDED
- **XRechnung** (KoSIT): 1.x, 2.0, 2.1, 2.2, 2.3, 3.0
- **UBL 2.1** als Rechnung und Gutschrift

### Profiltabelle
| Kennung/Erkennung | Syntax | Profil | XSD | Zählende Kette | Hinweise |
|---|---|---|---|---|---|
| `factur-x.eu:1p0:minimum` | CII | MINIMUM | Factur-X MINIMUM | Factur-X MINIMUM | – |
| `factur-x.eu:1p0:basicwl` | CII | BASIC WL | Factur-X BASIC-WL | Factur-X BASIC-WL | – |
| `factur-x.eu:1p0:basic` | CII | BASIC | Factur-X BASIC | Factur-X BASIC | XRechnung 3.0 CII |
| `factur-x.eu:1p0:extended` | CII | EXTENDED | Factur-X EXTENDED | Factur-X EXTENDED | – |
| `urn:cen.eu:en16931:2017` (ohne Factur-X-/XRechnung-Zusatz) | CII | EN 16931 | Factur-X EN16931 | Factur-X EN16931 | XRechnung 3.0 CII |
| `…xrechnung…` | CII | XRECHNUNG | Factur-X EN16931 | CEN-CII + XRechnung-CII (versioniert) | – |
| `…xrechnung…` | UBL Invoice | XRECHNUNG (UBL) | UBL-Invoice-2.1 | EN16931-UBL + XRechnung-UBL (versioniert) | – |
| `…xrechnung…` | UBL CreditNote | XRECHNUNG (UBL) | UBL-CreditNote-2.1 | EN16931-UBL + XRechnung-UBL (versioniert) | – |
| sonst | UBL | EN 16931 (UBL) | UBL-Invoice-2.1 oder UBL-CreditNote-2.1 | EN16931-UBL | – |

## Bewusste Nicht-Entscheidungen
- ZUGFeRD 1.0 und `CrossIndustryDocument` werden nicht unterstützt; sie führen zu `Fehler::UnbekanntesProfil`.
- Ältere XRechnung-XSLTs werden nicht vorgewärmt; die Strukturprüfung für XRechnung CII bleibt auf dem Factur-X-EN16931-Schema.
- Das französische Flux-2-Schematron wird nicht eingebunden.
- Eine schärfere Prüfung beliebiger UBL-CustomizationIDs ist nicht implementiert; der UBL-Zweig wertet nur die XRechnung-Kennung aus.
