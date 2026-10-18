# build.rs — Artefakt-Tabelle erzeugen und Invarianten prüfen

## Zweck
Erzeugt `$OUT_DIR/tabelle.rs` (die `&'static str`-Tabellen `KOSIT` und `MUSTANG`) aus dem
Inhalt von `artefakte/` und prüft dabei, was der Validator über diese Artefakte voraussetzt.
Eingebunden wird das Ergebnis in `src/artefakte/mod.rs` per `include!`.

## Begründung & Designentscheidungen
- **Gegen stille Drift.** Vorher erzeugte `scripts/artefakte-tabelle.py` die Tabelle und wurde
  **von Hand** aufgerufen. Wer ein Artefakt hinzufügte, entfernte oder austauschte und das
  Skript vergaß, baute gegen einen veralteten Stand, ohne dass irgendetwas fehlschlug.
  `cargo:rerun-if-changed` auf `artefakte/` erzwingt den Neubau bei jeder Änderung.
- **Vorverarbeitung wird geprüft, nicht nachgeholt.** Im Repo liegen ausschließlich die
  **bereits vorverarbeiteten** Schematron-Quellen (`<include>` eingebettet, abstrakte Muster
  instanziiert). Die Rohartefakte von upstream sind nicht eingecheckt, also kann `build.rs`
  `schematron-vorverarbeiten.py` nicht nachfahren. Es prüft stattdessen das Ergebnis: Findet
  sich in einer `.sch` noch `<include` oder `abstract="true"`, bricht der Bau ab und nennt den
  Befehl, der fehlt. Ein roh eingespieltes Artefakt würde sonst zur Laufzeit **zu wenig
  prüfen** — ein Validator, der zu wenig findet, ist schlimmer als einer, der nicht baut.
- **Gleiche Regelsätze werden berechnet, nie angenommen.** `GLEICHE_REGELSAETZE` listet
  Artefaktpaare, die dieselbe Menge aus (Regel-ID, Testausdruck) tragen. Grundlage für das
  Zusammenlegen doppelter Prüfungen: KoSIT und Mustang führen beide die EN-16931-Kernregeln,
  KoSIT als Schematron-Quelle, Mustang als kompiliertes XSLT. Ändert upstream eine Seite,
  verschwindet das Paar hier von selbst und die Laufzeit prüft wieder getrennt.

## Schnittstelle
Erzeugt in `$OUT_DIR/tabelle.rs`:
- `pub static KOSIT: &[Datei]`, `pub static MUSTANG: &[Datei]` — Pfad relativ zu `artefakte/`
  plus `include_str!` des Inhalts, nach Pfad sortiert.
- `pub static GLEICHE_REGELSAETZE: &[(&str, &str)]` — Paare gleicher Regelsätze; der erste
  Eintrag ist der Vertreter.

## Fallen
- **Rohes `>` in XPath-Tests.** In XML-Attributwerten ist `>` erlaubt und kommt in 23 der
  806 EN-16931-Tests vor. Ein naives `find('>')` zum Finden des Tag-Endes schneidet dort
  mitten im Attribut und verliert die Regel lautlos. Darum `tag_ende()`, das
  Anführungszeichen mitführt. Symptom bei einem Rückfall: `GLEICHE_REGELSAETZE` wird leer,
  obwohl die Artefakte übereinstimmen.
- **`attribut()` braucht die Attributgrenze.** Ohne die Prüfung auf Leerzeichen davor würde
  `test="` auch in `subtest="` oder `contexttest="` treffen.

## Bewusst nicht
- **Keine Vorverarbeitung im Bau.** Dafür müssten die Rohartefakte eingecheckt werden; das
  verdoppelte den Artefaktbaum. Solange sie fehlen, ist Prüfen die ehrlichere Lösung.
- **Keine Toleranz bei abweichenden IDs.** `CII-SR-004` (KoSIT) und `CII-SR-04` (Mustang)
  tragen denselben Test, aber verschiedene IDs — upstream füllt unterschiedlich mit Nullen
  auf. Die beiden CII-Artefakte gelten deshalb **nicht** als gleich. Sie zusammenzulegen
  würde die gemeldete Regel-ID in Mustang-Berichten ändern, also den Befund. Betrifft heute
  genau zwei der 806 Regeln.
