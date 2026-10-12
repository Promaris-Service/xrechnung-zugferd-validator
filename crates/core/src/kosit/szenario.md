# `szenario.rs` — Szenarienwahl nach Syntax und Kennung

## Zweck
Die Datei bildet die KoSIT-Szenariendatei `scenarios-xrechnung-3.0.2.xml` für XRechnung 3.0.2 in Rust nach. Sie wählt anhand der Belegsyntax (CII, UBL Invoice, UBL CreditNote) und der exakten CustomizationID/Guideline-ID das passende Validierungsszenario (XSD, XSLT-/Schematron-Kette, Schlüssel für customLevel) aus.

## Begründung und Designentscheidungen
- **Direkte Umsetzung statt XPath:** Die offiziellen `<match>`-Bedingungen sind reine Gleichheitsvergleiche auf Wurzelelement und ID. Eine Rust-Implementierung mit `match` ist schneller und zur Testzeit überprüfbar; die Szenarionamen müssen wörtlich mit `scenarios-xrechnung-3.0.2.xml` übereinstimmen, sonst greift die customLevel-Zuordnung nicht.
- **Drei Betriebsarten:**
  - `XRechnung302`: exakt die offiziellen KoSIT-Szenarien. Unbekannte Profile (z. B. Factur-X) werden abgelehnt (`None`).
  - `En16931Alle`: nur EN16931-Kernregeln für jeden Beleg, unabhängig vom Profil. Kein customLevel-Schlüssel (`stufen: None`).
  - `Automatisch` (Standard): versucht zuerst das offizielle Szenario, fällt sonst auf EN16931-Kernregeln zurück.
- **Artefaktauswahl:** EN16931 wird als vorverarbeitete Schematron-Quelle (`.sch`) verwendet; sie liefert identische Befunde wie die kompilierten XSLTs, ist aber doppelt so schnell. Die XSLTs bleiben als Referenz im Artefaktbestand.

## Umgesetzte Norm
- **EN 16931-3 (CII) und EN 16931-2 (UBL):** Die EN-Schematrondateien `EN16931-CII-validation-1.3.16.sch` und `EN16931-UBL-validation-1.3.16.sch` decken die europäischen Kernregeln ab.
- **XRechnung 3.0.2 (KoSIT):** Die XSLT-Dateien `XRechnung-CII-validation.xsl` und `XRechnung-UBL-validation.xsl` ergänzen die deutschen CIUS-Regeln.
- **CustomizationIDs:** Die Konstanten `ID_EN`, `ID_XR`, `ID_XR_EXT`, `ID_XR_CVD` entsprechen den in der KoSIT-Szenariendatei verwendeten IDs für EN16931, XRechnung, XRechnung Extension und XRechnung CVD.

## Bewusste Nicht-Entscheidungen
- Keine Unterstützung für XRechnung 2.x oder ältere KoSIT-Konfigurationen.
- Keine dynamische Auswertung von beliebigen CustomizationIDs; nur die fest kodierten elf offiziellen Kombinationen werden erkannt.
- Keine Normalisierung oder Toleranz gegenüber abweichenden Schreibweisen der IDs; es gelten exakte Stringvergleiche wie in KoSIT.
