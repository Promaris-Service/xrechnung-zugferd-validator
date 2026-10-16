# erechnung-validator

**EN 16931 e-invoice validation as a WASI component — XRechnung, ZUGFeRD and Factur-X
in pure Rust, running the original KoSIT and Mustang artifacts without a JVM.**

> 🇩🇪 Eine deutsche Fassung dieser README liegt in [README.de.md](https://github.com/Promaris-Service/xrechnung-zugferd-validator/blob/main/README.de.md).

KoSIT and Mustang validation for e-invoices according to EN 16931 (CII and UBL) in **pure Rust** — natively as a Cargo crate and CLI, and as a **WASI component** (`wasm32-wasip2`) with a typed WIT interface. No JVM, no C library, nothing to download: the original validation artifacts (Schematron XSLTs, XSDs, code lists) are embedded.

The rules are **not reimplemented**. The original artifacts are executed with the Rust engine [oxixml](https://github.com/cool-japan/oxixml): the EN 16931 core rules as Schematron source (CEN 1.3.15, the same version underlying KoSIT's XSLT), everything else as the compiled XSLTs that Saxon also executes in the KoSIT validator and in Mustang. On a corpus of 255 real incoming invoices (250 CII, 5 UBL, all Factur-X profiles plus XRechnung), the findings — rule IDs, severities, XSD verdict — are **identical in 255/255** cases with the KoSIT validator 1.6.1, and the Mustang verdicts are **identical in 255/255** cases with Mustang 2.24.0.

**And it is dramatically faster.** On that same corpus, measured end to end from a cold start (64 cores), this crate runs the Mustang rules about **27× faster** than Mustang-Java (3.1 s vs. 82.5 s) and the KoSIT rules about **1.7× faster** than KoSIT-Java (2.7 s vs. 4.5 s) — per document roughly 12 ms instead of 324 ms for Mustang. Full numbers under [Performance](#performance).

## What's inside

| Crate | What | Target |
|---|---|---|
| `crates/core` (`erechnung-validator`) | Library: `Validator::kosit`, `::mustang`, `::beide` | native and wasm32 |
| `crates/component` (`erechnung-validator-wasi`) | WASI component, exports `promaris:erechnung/pruefung` | wasm32-wasip2 |
| `crates/cli` (`erechnung-validator`) | Command line, native all cores, or as WASI command | both |
| `examples/host-wasmtime` | Example host, loads the component with wasmtime | native |

Embedded artifacts (`crates/core/artefakte/`, origin and licenses in `NOTICE.md`):

- **KoSIT** `validator-configuration-xrechnung` as of 2026-01-31: XRechnung 3.0.2 (CII, UBL Invoice, UBL CreditNote, Extension, CVD), EN 16931 CII/UBL, scenarios with `customLevel`. Additionally the scenarios "EN16931 for every document".
- **CEN** EN 16931 Schematron sources, release validation-1.3.15 (preprocessed: includes embedded, abstract patterns instantiated).
- **Mustang 2.24.0**: Factur-X 1.0 (ZF_250) MINIMUM, BASIC WL, BASIC, EN16931, EXTENDED with code lists, XRechnung 1.2 to 3.0 (CII/UBL), EN 16931 CII/UBL, XSDs per profile.

## Native (Rust)

```toml
[dependencies]
erechnung-validator = "0.1"
```

```rust
use erechnung_validator::{Szenarien, Validator};

// One validator per thread; the thread needs 64 MiB stack (Validator::STACK_BYTES).
let v = Validator::new();
let xml = std::fs::read_to_string("rechnung.xml")?;

let kosit = v.kosit(&xml, Szenarien::Automatisch)?;   // like KoSIT
let mustang = v.mustang(&xml)?;                        // like Mustang (XML part)
println!("{} {}", kosit.angenommen, kosit.json());
for f in kosit.fehler() { println!("{} {}", f.regel, f.text); }
```

`Szenarien::XRechnung302` behaves like the official KoSIT configuration (Factur-X has no scenario there → `Fehler::KeinSzenario`), `En16931Alle` checks every document against the EN 16931 core rules, `Automatisch` (default) uses the official scenario if one exists.

`vorwaermen()` precompiles all artifacts. Compiled XSLT and Schematron artifacts are held
**once per process** (`Arc`), so a second worker does not pay for them again; only the XSD
schema is per validator (it is not `Send`). See `crates/core/src/engine/cache.md`.

### CLI

```
cargo build --release -p erechnung-validator-cli
./target/release/erechnung-validator [--kosit|--mustang|--beide] [--szenarien xrechnung|alle|auto]
                                     [--threads N] [--json|--kurz] <datei.xml|verzeichnis>...
```

One JSON line per document and tool (default) or `--kurz` (short). Exit code 0 if all documents were accepted. Natively, as many workers run as there are cores.

## WASI component

```
rustup target add wasm32-wasip2
cargo build --release --target wasm32-wasip2 -p erechnung-validator-wasi -p erechnung-validator-cli
```

Result: `target/wasm32-wasip2/release/erechnung_validator_wasi.wasm` (library, world `validator`) and `erechnung-validator.wasm` (command). Both are also provided as release artifacts, together with `validator.wit`.

Interface (`crates/component/wit/validator.wit`):

```wit
interface pruefung {
    kosit:      func(xml: string, szenarien: szenarien) -> result<bericht, fehler>;
    mustang:    func(xml: string) -> result<bericht, fehler>;
    beide:      func(xml: string, szenarien: szenarien) -> tuple<result<bericht, fehler>, result<bericht, fehler>>;
    vorwaermen: func() -> result<_, fehler>;
    artefakte:  func() -> string;
}
```

`bericht` carries scenario/profile, syntax, identifier, XSD verdict with error texts, the findings (rule ID, level, original flag, XPath location, wording, artifact) and the overall verdict `angenommen` (accepted).

**Host requirement:** The EN 16931 stylesheets recurse deeply. The host must raise the Wasm stack to 64 MiB (wasmtime: `Config::max_wasm_stack(64 << 20)` or `-W max-wasm-stack=67108864`); the component's shadow stack is already 64 MiB (`.cargo/config.toml`). A component instance is a thread: compiled artifacts persist across calls, so create one instance per worker and call `vorwaermen`.

Command component with wasmtime:

```
wasmtime run -W max-wasm-stack=67108864 --dir ./belege::/belege \
  target/wasm32-wasip2/release/erechnung-validator.wasm -- --kurz /belege
```

Example host in Rust: `examples/host-wasmtime` (typed bindings via `wasmtime::component::bindgen!`).

## Performance

255 real documents (9 MB), 64 cores, everything including startup and compilation, best found configuration per tool. **This table was measured before the shared artifact cache** (commit `e331713`); the wall times still hold, the memory figures are considerably lower by now — see below:

| Tool | Configuration | Wall time | per document | Memory |
|---|---|---|---|---|
| KoSIT Java (Saxon) | 2 JVMs parallel | 4.5 s | 18 ms | – |
| **KoSIT, this crate** | 64 workers | **2.7 s** | 11 ms | 2.7 GB |
| KoSIT, this crate | 16 workers | 4.2 s | 16 ms | 1.6 GB |
| Mustang Java | 1 JVM per file, 32 parallel | 82.5 s | 324 ms | – |
| **Mustang, this crate** | 64 workers | **3.1 s** | 12 ms | 12 GB |
| Mustang, this crate | 16 workers | 3.9 s | 15 ms | 6.9 GB |
| Both tools, this crate | 64 workers | 5.1 s | 20 ms | 14 GB |

Computation time per document on one core: KoSIT path median 21 ms, p90 93 ms, maximum 1.3 s; Mustang path median 25 ms, p90 112 ms, maximum 1.1 s (430 KB document with many positions). The wall time of a batch is determined by the slowest document, not the number of cores.

**Where the speedup comes from:** The XSLT path (the compiled Schematron XSLTs of KoSIT and Mustang in oxixml) required 40.7 s (KoSIT) or 77 s (Factur-X) of computation time for the corpus and 0.5 to 2.5 s of compilation per artifact; Saxon is about twelve times faster on this path per document. Executing the Schematron sources directly (`oxixml-schematron`, each rule an XPath) reduces computation time to 18 s (KoSIT, factor 2) or 11 s (Factur-X, factor 7) and compilation to milliseconds — with identical findings. For this, the sources are preprocessed (includes, abstract patterns, code lists instead of `document()`), see `crates/core/scripts/` and `crates/core/src/engine/schematron.md`. Only the XRechnung Schematron (own `xsl:function`) and Mustang's CEN run for XRechnung still run as XSLT.

### Since the shared artifact cache

Measured on a different corpus (400 files, 32 threads, release build with fat LTO), so not
comparable row by row with the table above. Every stage produces **byte-identical**
findings; only `dauer_ms` changes:

| Stage | KoSIT @32T | Mustang @32T |
|---|---|---|
| cache per thread (before) | 1.54 s · 11.8 GB | 5.13 s · 49.1 GB |
| XSLT/Schematron shared (`Arc`) | 0.77 s · 2.1 GB | 1.37 s · 2.4 GB |
| plus PGO | 0.72 s · 2.2 GB | 1.21 s · 2.4 GB |
| plus XSD shared (needs oxixml patch) | 0.72 s · **1.02 GB** | 1.27 s · **1.52 GB** |

Memory therefore **no longer grows with the thread count**. The derivation, the kernel
analysis and the open oxixml patch are in `docs/perf/PERFORMANCE-FINDINGS.md`.

## What is deliberately not included

- Mustang's PDF part (veraPDF PDF/A-3 validation, XMP, embedding) and its Java-side arithmetic check. Both are not Schematron.
- ZUGFeRD 1.0, Order-X, XRechnung 1.x/2.x, the French Flux-2 Schematron.
- KoSIT's HTML report and `rep:` XML; the `Bericht` carries the same information.

## Tests

```
cargo test --workspace --release
# Regression against an own corpus with KoSIT reference (customer documents remain local):
ERECHNUNG_BESTAND=/pfad/zu/xml ERECHNUNG_KOSIT_CODES=/pfad/kosit-codes.tsv cargo test --release -p erechnung-validator --test bestand
```

The examples under `crates/core/tests/belege` come from the XRechnung test suite (Apache-2.0).

## Keeping the artifacts current

The embedded artifacts are pinned in `docs/artefakte-quellen.toml`.
`scripts/pruefe-artefakt-updates.py` compares the pins against the upstream releases of
KoSIT, EN 16931 and Mustang and exits with 10 when a newer version exists; the procedure
for adopting one is in `docs/artefakte-aktualisieren.md`.

## Structure

Each module is separated into files by concern; next to each `.rs` there is a `.md` of the same name with purpose, norm, pitfalls, and what was deliberately not built. Entry point: `crates/core/src/lib.rs`.

## License

Code: MIT OR Apache-2.0. Embedded third-party artifacts: see `NOTICE.md`.
