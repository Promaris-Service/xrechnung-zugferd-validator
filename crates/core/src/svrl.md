# `svrl.rs` — SVRL-Ausgabe in Befunde übersetzen

## Zweck

Die Funktion `befunde()` nimmt eine Schematron-Validierungsausgabe im SVRL-Format entgegen, extrahiert alle `svrl:failed-assert`-Vorfälle (optional auch `svrl:successful-report`) und übersetzt sie in `Befund`-Datensätze mit Regel-ID, Stufe, `flag`, Ort, Text und Quelle.

## Begründung & Designentscheidungen

- **Echter XML-Parser:** Meldungstexte enthalten maskierte Zeichen wie `&gt;`, Anführungszeichen und Zeilenumbrüche. Textsuche oder reguläre Ausdrücke wären fehleranfällig. `roxmltree` ist reines Rust, ressourcenschonend und für `wasm32`/WASI geeignet.
- **Namensraum-Prüfung:** Es werden nur Elemente im SVRL-Namensraum `http://purl.oclc.org/dsdl/svrl` als Meldungen gewertet; andere Elemente werden ignoriert.
- **`successful-report` als Opt-in:** Manche Schematron-Installationen werten nur `failed-assert` als Fehler, z. B. Factur-X/Mustang. Für andere Validierungswege sind `sch:report`-Meldungen dagegen relevant. Deshalb steuert `mit_reports`, ob `successful-report` übernommen wird.
- **Stufe ohne `flag`:** Fehlt das `flag`-Attribut, wird die übergebene Standardstufe `ohne_flag` verwendet; vorhandene Flags werden über `Stufe::aus_flag` übersetzt.
- **Regel-ID-Fallback:** Manche Schematron-XSLTs schreiben keine `id`, sondern legen die Regel-ID als `[BR-CO-14]` in den Textanfang. `regel_aus_text()` zieht diese Kennung heraus. Wird keine Kennung erkannt, bleibt das Feld leer; der Text wird nicht verändert oder als Regel-ID erfunden.

## Umgesetzte Norm

- ISO/IEC 19757-3 Anhang D (SVRL) für die Struktur von `schematron-output`, `failed-assert` und `successful-report`.
- Keine direkte Prüfung einer EN16931-/XRechnung-Regel in dieser Datei. Die Fallback-Erkennung unterstützt das Factur-X-/Mustang-Format, in dem Regel-IDs wie `[BR-CO-14]` oder `[CII-SR-013]` im Meldungstext stehen.

## Bewusste Nicht-Entscheidungen

- Es werden nur `failed-assert` und optional `successful-report` gelesen; andere SVRL-Elemente wie `active-pattern`, `fired-rule` oder `report` ohne `successful` werden nicht modelliert.
- Es wird kein XPath/XSLT evaluiert; die eigentliche Schematron-Ausführung bleibt der vorgelagerten Verarbeitung überlassen.
- `svrl:value-of` wird nicht ausgewertet. Die Funktion übernimmt statischen Text aus `svrl:text`; dynamisch erzeugte Textbestandteile sind nicht Teil der Befundtext-Erfassung.
