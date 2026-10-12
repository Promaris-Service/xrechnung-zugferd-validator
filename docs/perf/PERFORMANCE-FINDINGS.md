# Performance-Befunde & Roadmap

> Stand: 2026-10-09. Lokale Messungen auf dem MLK-Kernel (`7.3.0-rc5-mlk15-afdo`),
> 400-Datei-Korpus (4 echte XRechnung/CII-Belege × 100), Release-Build (fat LTO).
> **Alle gemessenen Änderungen sind byte-identisch** (nur das Feld `dauer_ms` variiert).

## 1. Zusammenfassung der Gewinne

| Stufe | KoSIT @32T | Mustang @32T |
|---|---|---|
| **Baseline** (Cache je Thread) | 1,54 s · 11,8 GB | 5,13 s · 49,1 GB |
| **+ XSLT/Schematron geteilt** (`Arc`, einmal kompiliert) | 0,77 s · 2,1 GB | 1,37 s · 2,4 GB |
| **+ PGO** (profilgeführt, kernel-inspiriert) | 0,72 s · 2,2 GB | 1,21 s · 2,4 GB |
| **+ XSD geteilt** (oxixml-regex `Rc`→`Arc`) | 0,72 s · **1,02 GB** | 1,27 s · **1,52 GB** |
| **Gesamt** | **~2,1× schneller · ~11,6× weniger RAM** | **~4× schneller · ~32× weniger RAM** |

Speicher wächst **nicht mehr mit der Thread-Zahl** (16/32/64 Threads ~gleich).

## 2. Was gemacht wurde

### 2a. Geteilte Artefakte (live, Branch `valdis/perf-shared-cache`, Commit e331713)
Kompilierte XSLT-Stylesheets und Schematrons sind `Send + Sync` und werden prozessweit
**einmal** kompiliert und per `Arc` an alle Worker geteilt (Kompilierung unter Write-Lock
mit Double-Check → je Artefakt genau eine Kompilierung, kein Thundering-Herd). Baut mit
unverändertem oxixml. **Das ist der größte Einzelgewinn.** Plus gepufferte CLI-Ausgabe.

### 2b. PGO (Profile-Guided Optimization)
Inspiriert vom Kernel (MLK ist `CONFIG_AUTOFDO_CLANG=y`), dem Validator-Binary fehlte es.
`-Cprofile-generate` → Korpus laufen → `llvm-profdata merge` → `-Cprofile-use`. Ergebnis:
+6 % (KoSIT) bis +12 % (Mustang), byte-identisch, nur ein Build-Schritt. Lohnt sich für die
compute-gebundene Hot-Loop; gehört in die Release-CI.

### 2c. XSD-Schema teilen — braucht Upstream-Fix (demonstriert)
`oxixml_schema::Schema` war **nicht** `Send` (hielt `Rc<ClassExpr>` tief in `oxixml-regex`).
Ein **16-Zeilen-Patch** (`Rc`→`Arc` für `ClassExpr`, siehe `oxixml-regex-arc.patch`) macht
`Schema` `Send + Sync`; dann lässt sich auch der XSD-Cache global teilen (cache.rs: dritter
`static SCHEMATA`). Gewinn: KoSIT 2,1→1,02 GB, Mustang 2,4→1,52 GB, byte-identisch, Tests grün.
**Weg nach vorn:** Upstream-PR an oxixml-regex (`Rc`→`Arc`). Nützt dem ganzen Ökosystem
(thread-teilbare kompilierte Schemata). Bis dahin nur lokal via `[patch.crates-io]`.

## 3. Kernel-Analyse (MLK) — nicht der Flaschenhals

`perf stat` (KoSIT, 32T): `sys` nur 1,24 s von 37 s, Page-Faults minimal, **THP=`always`**
liefert Hugepages automatisch (mimalloc-Hugepage-Tuning bringt nichts). BORE + PREEMPT +
HZ=1000 + AutoFDO passen ideal zur Burst-Last. **Der Kernel ist für diese Workload bereits
optimal konfiguriert.** Der einzige übertragbare Hebel war PGO (→ 2b).

Der echte Kostenträger: **~1,2 Mrd. Cache-Misses** in der oxixml-Baum-Traversierung — ein
Engine-Datenlayout-Problem, kein Kernel-Problem (Hugepages adressieren TLB, nicht L1/L2/L3).

## 4. Crate-Landschaft (Alternativen/Ideen)

- **Xee** (XPath 3.1 + XSLT, vom lxml-Autor) und **Xrust** (XPath/XQuery/XSLT 3.0) — reine
  Rust-Engines. Anderer Ansatz als oxixml; interessant als Referenz/Benchmark, aber ein
  Engine-Wechsel gefährdet die 255/255-Byte-Identität.
- **sup-xml** — behauptet XPath/XSD/XSLT/RelaxNG/Schematron/C14N in einem, ~2× libxml2.
  Unverifiziert; wäre ein Kandidat für einen Vergleich.
- **SXSI (Succinct XML Self-Index)** — Tree-Automata + komprimierte Indizes, 1–3
  Größenordnungen schneller bei XPath. **Das ist die research-grade Richtung gegen die
  Cache-Misses:** datenorientierte Repräsentation (flache Arrays/Bytecode/Automaten) statt
  Baum-/Objekt-Traversierung.

## 5. VeraPDF ersetzen (JVM-frei werden)

Der XML-Teil ist bereits reines Rust; die **PDF/A-3-Konformitätsprüfung** (ZUGFeRD-Container)
läuft im Umfeld noch über **veraPDF (Java)**. Optionen:
- **Reine Rust-Crates existieren:** `pdf_compliance` (ISO 19005 Teil 1–4 inkl. PDF/A-3),
  `page_validation`, gPdf (Rust+WASM). Reife vs. veraPDF unbelegt → müsste gegen veraPDF
  gegengeprüft werden (wie 255/255 bei KoSIT/Mustang).
- **On-Brand-Ansatz:** veraPDF nutzt maschinenlesbare **Validation-Profiles**
  (`verapdf/verapdf-validation-profiles`). Diese **Original-Profile in Rust ausführen** (statt
  Regeln neu zu schreiben) — exakt die „run the original artifacts, byte-identical"-Philosophie
  des Validators. Ambitioniert, aber die konsequente Fortsetzung des „No JVM"-Versprechens.

## 6. Priorisierte Roadmap

1. **PGO in die Release-CI** (klein, +6–12 %, byte-identisch). [2b]
2. **Upstream-PR oxixml-regex `Rc`→`Arc`**, dann XSD-Cache teilen (−50 %/−37 % RAM). [2c]
3. **DOM-Reuse für XSD** — `schema.pruefe` re-parst `dok.xml` statt `dok.baum` zu nutzen;
   braucht einen baum-basierten Validator in oxixml-schema (Upstream). ~15–30 % laut Schätzung.
4. **wasm SIMD128** (`+simd128`) fürs WASI-Build — 5–20 % in Parser-/String-Pfaden.
5. **Wizer Pre-Init/Snapshot** fürs WASI-Component — kompilierte Artefakte ins Modul-Image
   einfrieren → Start ohne Laufzeit-Kompilierung.
6. **WIT-Batch-API** `pruefe-viele(list<string>)` — weniger Host↔WASM-Grenzübertritte.
7. **Research-grade:** datenorientierter XSLT-Interpreter / Tree-Automata (SXSI) gegen die
   1,2 Mrd. Cache-Misses — der eigentliche Flaschenhals. Großer Umbau in oxixml.
8. **VeraPDF-Ersatz** evaluieren (Crate adoptieren oder Profile-Executor bauen). [5]

## 7. Algorithmus-Analyse (autonom, 2026-10-09)

- **Validator-eigener Code ist optimal:** Szenario-/Profilauswahl ist `match`-basiert (O(1),
  kein linearer Scan), `pruefung.rs`/`lauf.rs` sind dünne Orchestrierung. Die Zeit liegt
  ausschliesslich in oxixml (XSLT-/XPath-Interpreter, XSD-Validierung).
- **Zwei DOM-Modelle = doppeltes Parsen:** Die XSLT-/Schematron-Seite nutzt
  `oxixml_infoset::Tree` (`dok.baum`), die XSD-Validierung parst intern erneut nach
  `oxixml_dom::Document` (`validate_str` → `oxixml_dom::build::parse_str`). Pro Beleg wird
  also in **zwei verschiedene Baummodelle** geparst. `validate_document(&Document)` existiert,
  nimmt aber `oxixml_dom::Document`, nicht den `Tree` — ein lokaler DOM-Reuse ist daher nicht
  möglich. **Fix upstream:** oxixml müsste die beiden Modelle vereinen oder eine günstige
  `Tree`↔`Document`-Brücke bieten. Potenzial grob 15–30 % (ein Parse-Durchgang je Beleg).
- **Profiler blockiert:** `perf record` scheitert an `perf_event_paranoid=2` (EACCES),
  `valgrind` ist nicht installiert, und weder `sysctl` noch Installationen fasse ich autonom
  an. `perf stat` (Zähl-Modus) funktioniert und liefert die Kernaussage: ~1,2 Mrd.
  Cache-Misses, compute-gebunden, `sys` vernachlässigbar.
- **Kernel final:** MLK = Mainline 7.3 + BORE + CachyOS-Performance-Patches. Alles
  general-purpose und bereits aktiv (THP=always, BORE, HZ=1000, AutoFDO). Für diese Workload
  ist der Kernel **nicht** der Flaschenhals; der einzige daraus ableitbare Validator-Gewinn
  war PGO (umgesetzt, §2b).

**Fazit der Algorithmus-/Kernel-Runde:** Die grossen, machbaren Gewinne (geteilter Cache,
PGO, XSD-`Arc`) sind gehoben bzw. als Upstream-PR vorbereitet. Was darüber hinaus geht
(DOM-Modelle vereinen, datenorientierter XSLT-Interpreter/Tree-Automata gegen die
Cache-Misses), ist **oxixml-Upstream-Arbeit** — der Validator-Code selbst gibt nichts mehr her.
