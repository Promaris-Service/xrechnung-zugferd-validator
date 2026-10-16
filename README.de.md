# erechnung-validator

**EN-16931-Rechnungsprüfung als WASI-Component — XRechnung, ZUGFeRD und Factur-X
in reinem Rust, mit den originalen KoSIT- und Mustang-Artefakten, ohne JVM.**

> 🇬🇧 An English version of this README is in [README.md](https://github.com/Promaris-Service/xrechnung-zugferd-validator/blob/main/README.md).

KoSIT- und Mustang-Validierung für E-Rechnungen nach EN 16931 (CII und UBL) in **reinem
Rust** — nativ als Cargo-Crate und CLI, und als **WASI-Component** (`wasm32-wasip2`) mit
typisierter WIT-Schnittstelle. Keine JVM, keine C-Bibliothek, nichts nachzuladen: die
originalen Prüfartefakte (Schematron-XSLTs, XSDs, Codelisten) sind eingebettet.

Die Regeln sind **nicht nachgebaut**. Ausgeführt werden die originalen Artefakte mit der
Rust-Engine [oxixml](https://github.com/cool-japan/oxixml): die EN-16931-Kernregeln als
Schematron-Quelle (CEN 1.3.15, dieselbe Fassung, die KoSITs XSLT zugrunde liegt), alles
andere als die kompilierten XSLTs, die auch Saxon im KoSIT-Validator und in Mustang
ausführt. Auf einem Bestand von 255 echten Eingangsrechnungen (250 CII, 5 UBL, alle
Factur-X-Profile plus XRechnung) sind die Befunde — Regel-IDs, Schweregrade, XSD-Urteil —
zu **255/255 identisch** mit dem KoSIT-Validator 1.6.1, und die Mustang-Urteile zu
**255/255 identisch** mit Mustang 2.24.0.

## Was drin ist

| Crate | Was | Ziel |
|---|---|---|
| `crates/core` (`erechnung-validator`) | Bibliothek: `Validator::kosit`, `::mustang`, `::beide` | nativ und wasm32 |
| `crates/component` (`erechnung-validator-wasi`) | WASI-Component, exportiert `promaris:erechnung/pruefung` | wasm32-wasip2 |
| `crates/cli` (`erechnung-validator`) | Kommandozeile, nativ alle Kerne, oder als WASI-Command | beides |
| `examples/host-wasmtime` | Beispiel-Host, lädt die Component mit wasmtime | nativ |

Eingebettete Artefakte (`crates/core/artefakte/`, Herkunft und Lizenzen in `NOTICE.md`):

- **KoSIT** `validator-configuration-xrechnung` Stand 2026-01-31: XRechnung 3.0.2
  (CII, UBL Invoice, UBL CreditNote, Extension, CVD), EN 16931 CII/UBL, Szenarien
  mit `customLevel`. Zusätzlich die Promaris-Szenarien „EN16931 für jeden Beleg".
- **CEN** EN 16931 Schematron-Quellen, Release validation-1.3.15 (vorverarbeitet:
  Includes eingebettet, abstrakte Muster instanziiert).
- **Mustang 2.24.0**: Factur-X 1.0 (ZF_250) MINIMUM, BASIC WL, BASIC, EN16931,
  EXTENDED mit Codelisten, XRechnung 1.2 bis 3.0 (CII/UBL), EN 16931 CII/UBL, XSDs je Profil.

## Nativ (Rust)

```toml
[dependencies]
erechnung-validator = "0.1"
```

```rust
use erechnung_validator::{Szenarien, Validator};

// Ein Validator je Thread; der Thread braucht 64 MiB Stack (Validator::STACK_BYTES).
let v = Validator::new();
let xml = std::fs::read_to_string("rechnung.xml")?;

let kosit = v.kosit(&xml, Szenarien::Automatisch)?;   // wie KoSIT
let mustang = v.mustang(&xml)?;                        // wie Mustang (XML-Teil)
println!("{} {}", kosit.angenommen, kosit.json());
for f in kosit.fehler() { println!("{} {}", f.regel, f.text); }
```

`Szenarien::XRechnung302` verhält sich wie die offizielle KoSIT-Konfiguration (Factur-X
hat dort **kein** Szenario → `Fehler::KeinSzenario`), `En16931Alle` prüft jeden Beleg
gegen die EN-16931-Kernregeln, `Automatisch` (Standard) nimmt das offizielle Szenario, wenn
es eines gibt.

`vorwaermen()` kompiliert alle Artefakte vorab. XSLT- und Schematron-Artefakte liegen
**prozessweit** nur einmal im Speicher (`Arc`), also kostet ein zweiter Worker sie nicht
erneut; nur das XSD-Schema liegt je Validator (es ist nicht `Send`). Siehe
`crates/core/src/engine/cache.md`.

### CLI

```
cargo build --release -p erechnung-validator-cli
./target/release/erechnung-validator [--kosit|--mustang|--beide] [--szenarien xrechnung|alle|auto]
                                     [--threads N] [--json|--kurz] <datei.xml|verzeichnis>...
```

Eine JSON-Zeile je Beleg und Werkzeug (Standard) oder `--kurz`. Rückgabe 0, wenn alle
Belege angenommen wurden. Nativ laufen so viele Worker wie Kerne.

## WASI-Component

```
rustup target add wasm32-wasip2
cargo build --release --target wasm32-wasip2 -p erechnung-validator-wasi -p erechnung-validator-cli
```

Ergebnis: `target/wasm32-wasip2/release/erechnung_validator_wasi.wasm` (Bibliothek,
World `validator`) und `erechnung-validator.wasm` (Command). Beide liegen auch als
Release-Artefakt bei, zusammen mit `validator.wit`.

Schnittstelle (`crates/component/wit/validator.wit`):

```wit
interface pruefung {
    kosit:      func(xml: string, szenarien: szenarien) -> result<bericht, fehler>;
    mustang:    func(xml: string) -> result<bericht, fehler>;
    beide:      func(xml: string, szenarien: szenarien) -> tuple<result<bericht, fehler>, result<bericht, fehler>>;
    vorwaermen: func() -> result<_, fehler>;
    artefakte:  func() -> string;
}
```

`bericht` trägt Szenario/Profil, Syntax, Kennung, XSD-Urteil mit Fehlertexten, die
Befunde (Regel-ID, Stufe, Original-Flag, XPath-Ort, Wortlaut, Artefakt) und das
Gesamturteil `angenommen`.

**Host-Pflicht:** Die EN-16931-Stylesheets rekursieren tief. Der Host muss den Wasm-Stack
auf 64 MiB anheben (wasmtime: `Config::max_wasm_stack(64 << 20)` bzw.
`-W max-wasm-stack=67108864`); der Shadow-Stack der Component ist bereits 64 MiB
(`.cargo/config.toml`). Eine Component-Instanz ist ein Thread: kompilierte Artefakte
bleiben über Aufrufe erhalten, also eine Instanz je Worker anlegen und `vorwaermen`.

Command-Component mit wasmtime:

```
wasmtime run -W max-wasm-stack=67108864 --dir ./belege::/belege \
  target/wasm32-wasip2/release/erechnung-validator.wasm -- --kurz /belege
```

Beispiel-Host in Rust: `examples/host-wasmtime` (typisierte Bindings per
`wasmtime::component::bindgen!`).

## Leistung

255 echte Belege (9 MB), 64 Kerne, alles inklusive Start und Kompilierung, beste
gefundene Konfiguration je Werkzeug. **Diese Tabelle wurde vor dem geteilten
Artefakt-Cache gemessen** (Commit `e331713`); die Wandzeiten gelten weiter, die
Speicherwerte sind inzwischen deutlich niedriger — siehe unten:

| Werkzeug | Konfiguration | Wandzeit | je Beleg | Speicher |
|---|---|---|---|---|
| KoSIT Java (Saxon) | 2 JVMs parallel | 4,5 s | 18 ms | – |
| **KoSIT, diese Crate** | 64 Worker | **2,7 s** | 11 ms | 2,7 GB |
| KoSIT, diese Crate | 16 Worker | 4,2 s | 16 ms | 1,6 GB |
| Mustang Java | 1 JVM je Datei, 32 parallel | 82,5 s | 324 ms | – |
| **Mustang, diese Crate** | 64 Worker | **3,1 s** | 12 ms | 12 GB |
| Mustang, diese Crate | 16 Worker | 3,9 s | 15 ms | 6,9 GB |
| Beide Werkzeuge, diese Crate | 64 Worker | 5,1 s | 20 ms | 14 GB |

Rechenzeit je Beleg auf einem Kern: KoSIT-Weg Median 21 ms, p90 93 ms, Maximum 1,3 s;
Mustang-Weg Median 25 ms, p90 112 ms, Maximum 1,1 s (430-KB-Beleg mit vielen
Positionen). Die Wandzeit eines Batches bestimmt der langsamste Beleg, nicht die Kernzahl.

**Woher die Beschleunigung kommt:** Der XSLT-Weg (die kompilierten Schematron-XSLTs von
KoSIT und Mustang in oxixml) brauchte 40,7 s (KoSIT) bzw. 77 s (Factur-X) Rechenzeit für
den Bestand und 0,5 bis 2,5 s Kompilierung je Artefakt; Saxon ist auf diesem Weg je
Dokument rund zwölfmal schneller. Die Schematron-Quellen direkt auszuführen
(`oxixml-schematron`, jede Regel ein XPath) senkt die Rechenzeit auf 18 s (KoSIT, Faktor 2)
bzw. 11 s (Factur-X, Faktor 7) und die Kompilierung auf Millisekunden — bei identischen
Befunden. Dafür werden die Quellen vorverarbeitet (Includes, abstrakte Muster,
Codelisten statt `document()`), siehe `crates/core/scripts/` und
`crates/core/src/engine/schematron.md`. Nur das XRechnung-Schematron (eigene
`xsl:function`) und Mustangs CEN-Lauf für XRechnung laufen noch als XSLT.

### Seit dem geteilten Artefakt-Cache

Gemessen auf einem anderen Korpus (400 Dateien, 32 Threads, Release-Build mit fat LTO),
deshalb nicht Zeile für Zeile mit der Tabelle oben vergleichbar. Alle Stufen liefern
**byte-identische** Befunde, nur `dauer_ms` ändert sich:

| Stufe | KoSIT @32T | Mustang @32T |
|---|---|---|
| Cache je Thread (vorher) | 1,54 s · 11,8 GB | 5,13 s · 49,1 GB |
| XSLT/Schematron geteilt (`Arc`) | 0,77 s · 2,1 GB | 1,37 s · 2,4 GB |
| zusätzlich PGO | 0,72 s · 2,2 GB | 1,21 s · 2,4 GB |
| zusätzlich XSD geteilt (braucht oxixml-Patch) | 0,72 s · **1,02 GB** | 1,27 s · **1,52 GB** |

Der Speicher wächst damit **nicht mehr mit der Thread-Zahl**. Herleitung, Kernel-Analyse
und der offene oxixml-Patch stehen in `docs/perf/PERFORMANCE-FINDINGS.md`.

## Was bewusst nicht enthalten ist

- Mustangs PDF-Teil (veraPDF-PDF/A-3-Prüfung, XMP, Einbettung) und seine Java-seitige
  Arithmetikprobe. Beides ist kein Schematron.
- ZUGFeRD 1.0, Order-X, XRechnung 1.x/2.x, das französische Flux-2-Schematron.
- KoSITs HTML-Report und `rep:`-XML; der `Bericht` trägt dieselben Informationen.

## Tests

```
cargo test --workspace --release
# Regression gegen einen eigenen Bestand mit KoSIT-Referenz (Kundenbelege bleiben lokal):
ERECHNUNG_BESTAND=/pfad/zu/xml ERECHNUNG_KOSIT_CODES=/pfad/kosit-codes.tsv cargo test --release -p erechnung-validator --test bestand
```

Die Beispiele unter `crates/core/tests/belege` stammen aus der XRechnung-Testsuite
(Apache-2.0).

## Artefakte aktuell halten

Die eingebetteten Artefakte sind in `docs/artefakte-quellen.toml` festgenagelt.
`scripts/pruefe-artefakt-updates.py` vergleicht diese Pins mit den Upstream-Releases von
KoSIT, EN 16931 und Mustang und endet mit 10, wenn es eine neuere Fassung gibt; wie man sie
übernimmt, steht in `docs/artefakte-aktualisieren.md`.

## Aufbau

Jedes Modul ist nach Belang in Dateien getrennt; zu jeder `.rs` liegt eine gleichnamige
`.md` mit Zweck, Norm, Fallen und dem, was bewusst nicht gebaut wurde. Einstieg:
`crates/core/src/lib.rs`.

## Lizenz

Code: MIT OR Apache-2.0. Eingebettete Artefakte Dritter: siehe `NOTICE.md`.
