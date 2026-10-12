# `cache.rs` – Kompilierte Artefakte vorhalten

## Zweck
Cache für kompilierte Stylesheets, Schematrons und XSD-Schemata. Beim ersten Zugriff wird das jeweilige Artefakt kompiliert (Kosten: etwa 0,3–2,5 s), danach werden nur noch Zeiger-Klone zurückgegeben. `vorwaermen()` kompiliert alle benötigten Artefakte im Voraus, damit Dienste die Latenz nicht am ersten Beleg bezahlen.

Der Cache ist **zweigeteilt**, weil die Artefakte unterschiedliche Thread-Eigenschaften haben:

| Artefakt | Ablage | Geteilt |
|---|---|---|
| XSLT-Stylesheets (`STYLESHEETS`) | prozessweiter `static`, `Arc` | ja, einmal je Prozess |
| Schematrons (`SCHEMATRONS`) | prozessweiter `static`, `Arc` | ja, einmal je Prozess |
| XSD-Schemata (`Cache::schemata`) | `RefCell` je `Validator`, `Rc` | nein, eines je Thread |

## Begründung & Designentscheidungen
- **Warum XSLT/Schematron prozessweit?** Die kompilierten oxixml-Stylesheets und Schematrons sind `Send + Sync`. Sie prozessweit genau einmal zu kompilieren und per `Arc` zu teilen, spart bei Batch-Läufen den Speicher von N−1 Kopien **und** die wiederholte Kompilierung. Das ist der größte Einzelgewinn der Perf-Arbeit (siehe `docs/perf/PERFORMANCE-FINDINGS.md`): Speicher wächst dadurch **nicht mehr mit der Thread-Zahl**.
- **Double-Check unter Write-Lock:** `geteilt_holen` prüft erst unter Read-Lock, dann unter Write-Lock erneut. So entsteht je Artefakt genau **eine** Kompilierung statt einer je Thread — kein Thundering-Herd beim Batch-Start. Serialisiert wird nur der einmalige Kaltstart; der Dauerbetrieb nutzt reine Lese-Locks.
- **Warum XSD trotzdem je Instanz?** `oxixml_schema::Schema` ist **nicht** `Send`: es hält tief in `oxixml-regex` ein `Rc<ClassExpr>`. Ein geteilter `static` scheidet damit aus, also bleibt das Schema pro `Validator`-Exemplar (ein Cache je Thread). In WASI gibt es nur einen Thread, dort ist das ohne Belang.
- **Interior Mutability:** Die `RefCell`-Map erlaubt die lazy Initialisierung des XSD-Caches, ohne die API mit `&mut self` zu belasten. Alle Zugriffe darauf erfolgen innerhalb eines Threads.
- **Schlüssel als `&'static str`:** Die Pfade der eingebetteten Artefakte stehen zur Kompilierzeit fest; das erspart Lifetimes und dynamische Speicherung.
- **Automatische Klassifizierung in `vorwaermen`:** Dateien auf `.sch` werden als Schematron-Quelle behandelt, alle anderen als XSLT. Schemata kommen in einem eigenen Parameter, weil sie eine andere Kompilierroutine und den lokalen Cache brauchen.
- **Speicherbedarf:** Nach dem Teilen liegen die XSLT-/Schematron-Artefakte einmal im Prozess (KoSIT-Weg ~1 GB, Mustang-Weg ~1,5 GB bei 32 Threads, gemessen mit dem `Arc`-Patch für `oxixml-regex`). Nur der XSD-Anteil skaliert noch mit der Worker-Zahl.

## Umgesetzte Norm
Die Datei selbst setzt keine EN-16931-Regel um. Sie ist Teil der Validierungs-Pipeline und hält die für XRechnung-/ZUGFeRD-Prüfungen benötigten Artefakte vor:
- XSD-Schemata (UBL, UN/CEFACT CII)
- Schematron-Regeln nach EN 16931 und KoSIT/XRechnung
- XSLT-Transformationen (kompilierte Schematron-XSLTs von KoSIT und Mustang)

## Bewusste Nicht-Entscheidungen
- **Kein geteilter XSD-Cache, solange `Schema` nicht `Send` ist.** Ein 16-Zeilen-Patch an `oxixml-regex` (`Rc`→`Arc` für `ClassExpr`) macht ihn teilbar und senkt den Speicher weiter; er liegt als `docs/perf/oxixml-regex-arc.patch` bei und gehört upstream, nicht in einen dauerhaften `[patch.crates-io]`-Eintrag.
- **Keine Cache-Invalidierung:** Der Cache wächst monoton; kompilierte Artefakte werden nie entfernt oder erneuert. Die zugrunde liegenden Dateien sind eingebettet und ändern sich zur Laufzeit nicht.
- **Keine dynamischen Pfade:** Es werden nur `'static`-Pfade der eingebetteten Artefakte angenommen, keine laufzeitgenerierten oder benutzerdefinierten.
