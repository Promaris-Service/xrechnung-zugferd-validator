# `pruefung.rs` — Mustang-Ablauf

**Zweck:** `pruefe` steuert die gesamte Mustang-Prüfung: Profil ermitteln, XSD-Validierung ausführen, danach die zählenden XSLT/Schematron-Ketten und die Hinweis-Kette anwenden und abschließend einen `Bericht` mit Ablehnungsentscheidung erzeugen.

**Ablauf im Einzelnen:**
1. `profil::waehle` wählt anhand Syntax und Kennung das passende Profil (`w`).
2. Das Profil-XSD wird über den Cache geprüft; Ergebnis und Fehlerdetails werden an den Bericht durchgereicht.
3. Für jeden Pfad in `w.xslt` (zählende Kette) und anschließend `w.hinweise` (Hinweiskette) wird das Artefakt ausgeführt:
   - Pfade mit Endung `.sch` werden als Schematron geladen; Ergebnisbefunde werden mit Stufe `Fehler` erzeugt und `successful-report` wird nicht berücksichtigt.
   - Andere Pfade werden als XSLT ausgeführt; die erzeugte SVRL-Ausgabe wird in Befunde überführt.
4. Befunde aus der Hinweiskette werden von `Stufe::Fehler` auf `Stufe::Information` herabgestuft, damit sie nicht zur Ablehnung führen.
5. Das Urteil ist angenommen, wenn XSD gültig ist und kein Befund die Stufe `Fehler` hat.

**Begründung & Designentscheidungen:**
- Die Reihenfolge XSD → zählende XSLTs → Hinweis-XSLTs bildet Mustangs getrennte Berichtsabschnitte ab. Dadurch erscheinen auch bei XSD-Fehlern die Schematron-Befunde im Bericht.
- Es zählen nur `failed-assert`-Befunde; `successful-report` wird bewusst ausgeschlossen. Das Verhalten ist als letzter Parameter (`false`) an die jeweiligen Auswertungen kodiert.
- Hinweis-XSLTs (z. B. XRechnung-Regeln bei BASIC/EN 16931) sind ausdrücklich informativ und beeinflussen das Annahmeurteil nicht. Deshalb werden ihre Befunde unabhängig von der Ausgangsstufe als `Information` geführt.
- Der Bericht enthält Metadaten wie Werkzeug, Szenario, Syntax, Kennung, Dauer und Artefaktversion, damit Aufrufer die Prüfung nachvollziehen können.

**Umgesetzte Norm:**
- Die Datei setzt den Mustang-Prüfablauf um: XSD-Validierung plus zählende XSLT/Schematron-Regeln plus Hinweis-XSLTs. Die konkreten EN16931-/XRechnung-/ZUGFeRD-Regelnummern liegen in den vom Profil referenzierten Artefakten, nicht in dieser Datei.
- Die Ablehnungslogik folgt Mustang: `invalid`, wenn XSD nicht gültig oder mindestens ein Befund der zählenden Kette die Stufe `Fehler` erreicht. Hinweisbefunde entsprechen Mustang-`notice`-Meldungen und bleiben informativ.
- Die bewusste Abweichung zu einem strikten KoSIT-Ablauf besteht darin, das Schematron auch nach XSD-Fehlern auszuführen, weil Mustang beide Abschnitte getrennt berichtet.

**Bewusste Nicht-Entscheidungen:**
- Es findet keine Sortierung oder Gruppierung der Befunde statt; die Reihenfolge ist durch die Abarbeitung der Ketten bestimmt.
- Die XSD-Fehlerdetails werden nicht aggregiert, sondern unverändert in den Bericht übernommen.
- Es wird keine Vorab-Prüfung oder Kurzschluss-Logik eingebaut, die bei XSD-Fehlern die weiteren Prüfungen überspringt.
- Pfadbehandlung und Artefakttyp-Erkennung sind hier bewusst einfach gehalten und verlassen sich auf die Profilstruktur; eine typsichere Auflösung erfolgt nicht.
