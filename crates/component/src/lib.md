# `crates/component/src/lib.rs` — WASI-Komponenten-Hülle

**Zweck (was):**
Diese Datei übersetzt die in `wit/validator.wit` definierte WASI-Schnittstelle in Aufrufe der nativen Crate `erechnung-validator`; sie enthält selbst keine Validierungslogik. Exportiert werden `kosit`, `kosit_pdf`, `mustang`, `beide`, `beide_pdf`, `vorwaermen` und `artefakte`. Die Component nimmt XML oder PDF-Bytes entgegen und liefert Berichte bzw. Fehler in den WIT-Typen zurück.

**Begründung & Designentscheidungen (warum):**
- **Thread-lokaler Validator:** Ein Component-Exemplar wird als ein Thread betrieben. Der `Validator` wird in einem `thread_local!` gehalten, damit kompilierte Artefakte über mehrere Aufrufe erhalten bleiben und nicht pro Beleg erneut initialisiert werden müssen.
- **Lazy initialization:** `RefCell<Option<Validator>>` erlaubt den Aufbau beim ersten Aufruf; `vorwaermen` kann denselben Zustand gezielt vorab füllen. `RefCell` genügt, weil innerhalb des Threads kein gleichzeitiger Zugriff erfolgt.
- **Explizite Typabbildung:** Die WIT-Typen (`Stufe`, `Syntax`, `Szenarien`, `Fehler`, `Bericht`) werden bewusst von den Core-Typen getrennt und über Funktionen `stufe`, `syntax`, `szenarien`, `fehler`, `bericht` bzw. `ergebnis` übersetzt. So bleibt die WIT-Schnittstelle unabhängig von internen Typen der nativen Crate.
- **PDF-Funktionen:** `kosit_pdf` und `beide_pdf` reichen die PDF-Bytes an den Core; die Extraktion des eingebetteten ZUGFeRD-/Factur-X-XML erfolgt dort. `pdf_a` bleibt leer, weil der Core keine PDF/A-Konformität prüft.
- **Fehlerbehandlung:** Die vier heutigen Fehlervarianten des Kerns werden einzeln auf die WIT-Variante abgebildet. `erechnung_validator::Fehler` ist `#[non_exhaustive]`, deshalb steht am Ende ein Wildcard-Arm: eine künftige Variante hat noch keine WIT-Entsprechung und wird als `engine` mit ihrem Display-Text gemeldet, damit der Grund nicht verloren geht. Wird die WIT-Variante erweitert, gehört die neue Fehlerart vorher als eigener Arm hinein. `beide` und `beide_pdf` liefern getrennte Ergebnisobjekte für die KoSIT- und Mustang-Prüfung.

**Umgesetzte Norm:**
Keine eigene Regelimplementierung. Die Datei reicht Prüfungen der nativen Crate durch. Betroffen sind die E-Rechnungs-Regelwerke EN 16931, KoSIT/XRechnung einschließlich Szenarien wie XRechnung 3.0.2, Mustang sowie die Syntaxen UBL Invoice, UBL CreditNote und CII. Die konkreten Regeln (z. B. XRechnung-Schematron, EN16931-Befunde) werden nicht in dieser Datei implementiert.

**Bewusste Nicht-Entscheidungen:**
- Kein Dateizugriff, kein Netzwerk, keine persistente Speicherung.
- Keine PDF/A-Validierung; `pdf_a` wird bewusst als leerer String geliefert.
- Keine threadübergreifende Zustandssicherung; die Component setzt den Host-Vertrag „eine Instanz je Worker/Thread“ voraus.
- Keine API zum Leeren/Zurücksetzen des Validators; der Lebenszyklus endet mit der Component-Instanz.
- Keine Validierung der XML-/PDF-Eingaben in der Hülle; das übernimmt die native Crate.
