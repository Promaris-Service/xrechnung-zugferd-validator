# erechnung-validator

**EN 16931 e-invoice validation as a WASI component — XRechnung, ZUGFeRD and Factur-X
in pure Rust, running the original KoSIT and Mustang artifacts without a JVM.**

> 🇩🇪 Eine deutsche Fassung dieser README liegt in [README.de.md](https://github.com/Promaris-Service/xrechnung-zugferd-validator/blob/main/README.de.md).

KoSIT and Mustang validation for e-invoices according to EN 16931 (CII and UBL) in **pure Rust** — natively as a Cargo crate and CLI, and as a **WASI component** (`wasm32-wasip2`) with a typed WIT interface. No JVM, no C library, nothing to download: the original validation artifacts (Schematron XSLTs, XSDs, code lists) are embedded.

The rules are **not reimplemented**. The original artifacts are executed with the Rust engine [oxixml](https://github.com/cool-japan/oxixml): the EN 16931 core rules as Schematron source (CEN 1.3.16, the same version underlying KoSIT's XSLT), everything else as the compiled XSLTs that Saxon also executes in the KoSIT validator and in Mustang.

Two corpora back this up. On 255 real incoming invoices (250 CII, 5 UBL, all Factur-X profiles plus XRechnung), the findings — rule IDs, severities, XSD verdict — are **identical in 255/255** cases with the KoSIT validator 1.6.1, and the Mustang verdicts are **identical in 255/255** cases with Mustang 2.24.0. On a second, larger corpus of **8,357 real outgoing invoices** (XRechnung 3.0, CII), the KoSIT path was compared against KoSIT validator 1.6.3 with configuration 2026-08-31, document by document: 1,443 documents carry findings, 1,505 findings in total, and both rule IDs and severities match in **8,357/8,357** documents — not one difference.

**On the Mustang rules it is far faster. On the KoSIT rules the answer depends on how you run Java.** Over those 8,357 documents it runs the Mustang rules about **10× faster** than Mustang-Java 2.26.0 (8.3 s vs. 81.6 s). Against the KoSIT validator it wins a single batch run (6.3 s vs. 8.6 s, start-up included) but loses to a warmed-up KoSIT daemon (3.6 s). Figures, method and the reason for the split under [Performance](#performance).

## What's inside

| Crate | What | Target |
|---|---|---|
| `crates/core` (`erechnung-validator`) | Library: `Validator::kosit`, `::mustang`, `::beide` | native and wasm32 |
| `crates/component` (`erechnung-validator-wasi`) | WASI component, exports `promaris:erechnung/pruefung` | wasm32-wasip2 |
| `crates/cli` (`erechnung-validator`) | Command line, native all cores, or as WASI command | both |
| `examples/host-wasmtime` | Example host, loads the component with wasmtime | native |

Embedded artifacts (`crates/core/artefakte/`, origin and licenses in `NOTICE.md`):

- **KoSIT** `validator-configuration-xrechnung` as of 2026-08-31: XRechnung 3.0.2 (CII, UBL Invoice, UBL CreditNote, Extension, CVD), EN 16931 CII/UBL, scenarios with `customLevel`. Additionally the scenarios "EN16931 for every document".
- **CEN** EN 16931 Schematron sources, release validation-1.3.16 (preprocessed: includes embedded, abstract patterns instantiated).
- **Mustang 2.26.0**: Factur-X 1.09.2 (ZF_250) MINIMUM, BASIC WL, BASIC, EN16931, EXTENDED with code lists, XRechnung 1.2 to 3.0 (CII/UBL), EN 16931 CII/UBL, XSDs per profile.

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

Measured on **8,357 real outgoing invoices** (XRechnung 3.0, CII; 87 MB) on an AMD Ryzen
Threadripper PRO 5975WX (32 cores, 64 threads, 125 GB RAM), release build with fat LTO and
`-C target-cpu=native`. Both sides run the **same artifacts**: KoSIT configuration 2026-08-31
with KoSIT validator 1.6.3, and Mustang 2.26.0. Each figure is the best of three runs; the
spread stayed under 4 %.

### Throughput

| Rule set | Wall time | per document | Documents/s | Peak memory |
|---|---|---|---|---|
| KoSIT | **6.30 s** | 0.75 ms | 1,327 | 0.98 GB |
| Mustang | **8.32 s** | 1.00 ms | 1,004 | 1.28 GB |
| both | **14.03 s** | 1.68 ms | 596 | 1.59 GB |

### Against the Java validators

| | this crate | Java | |
|---|---|---|---|
| **Mustang** — 64 JVMs, one per directory | **8.32 s** | 81.56 s | **9.8× faster** |
| KoSIT — single batch run, start-up included | **6.30 s** | 8.55 s | 1.36× faster |
| KoSIT — warmed-up daemon (`-T 64`) | 6.30 s | **3.63 s** | 1.7× **slower** |
| KoSIT — 64 JVMs in batch mode | **6.30 s** | 98.44 s | 15.6× faster |

The KoSIT comparison splits because start-up is not symmetric. This crate needs 0.10 s
(KoSIT) or 0.34 s (Mustang) for process start and artifact set-up, and the batch figures
include it. The KoSIT daemon needs **4.06 s** once and is fast afterwards: 3.63 s of pure
validation while *also* rendering a 28 KB HTML visualisation per document, which this crate
does not do. For a one-shot run this crate is ahead; for a long-running service a warm JVM
with Saxon is ahead.

Earlier releases of this README quoted much larger factors. Those came from a 255-document
corpus with KoSIT-Java in a far weaker configuration (two parallel JVMs); the daemon is about
40× better than that. Mustang-Java, run once per directory instead of once per file, is about
twice as fast as the 324 ms per document quoted before. The figures above replace them.

### Scaling across threads

3,998 documents, both rule sets:

| Threads | Wall time | Speed-up | Efficiency | RSS |
|---|---|---|---|---|
| 1 | 196.88 s | 1.00 | 100 % | 0.52 GB |
| 2 | 99.77 s | 1.97 | 99 % | 0.52 GB |
| 4 | 46.97 s | 4.19 | 105 % | 0.57 GB |
| 8 | 24.07 s | 8.18 | 102 % | 0.66 GB |
| 16 | 13.92 s | 14.14 | 88 % | 0.80 GB |
| 32 | 9.52 s | 20.68 | 65 % | 1.01 GB |
| 64 | 7.11 s | 27.69 | 43 % | 1.53 GB |

Near-ideal up to 8 threads. The machine has 32 physical cores, so 64 threads are SMT and the
43 % efficiency there is the normal yield, not a defect — **32 threads is the working point**.
Values above 100 % are cache and turbo behaviour, that is measurement noise rather than a
result.

Memory grows from 0.52 to 1.53 GB between 1 and 64 threads: the shared artifact cache does
its job. Per-thread caches needed 12 to 49 GB for the same work.

### Computation time per document, on one core

| Rule set | Median | p90 | p99 | Maximum |
|---|---|---|---|---|
| KoSIT | 37 ms | 50 ms | 127 ms | 639 ms |
| Mustang | 49 ms | 65 ms | 286 ms | 914 ms |
| *Mustang-Java 2.26.0* | *174 ms* | *1,132 ms* | *2,513 ms* | *30,187 ms* |

The distribution is tight — p90 is 1.35× the median — so a few slow documents do not dominate
a batch once there are enough of them.

Time scales linearly with document size (r = 0.915, about 4.6 ms per KB) rather than being a
fixed per-document cost. Within the Schematron stage roughly **48 %** goes to evaluating the
806 asserts, **35 %** to matching the 113 rule contexts — each of which is a full tree
traversal from the document root — and 17 % to set-up. The XSD check is 2 % of the total.

### Where the speed-up comes from

The XSLT path (the compiled Schematron XSLTs of KoSIT and Mustang in oxixml) required 40.7 s
(KoSIT) or 77 s (Factur-X) of computation time for the 255-document corpus and 0.5 to 2.5 s of
compilation per artifact; Saxon is about twelve times faster on this path per document.
Executing the Schematron sources directly (`oxixml-schematron`, each rule an XPath) reduces
computation time to 18 s (KoSIT) or 11 s (Factur-X) and compilation to milliseconds — with
identical findings. For this, the sources are preprocessed (includes, abstract patterns, code
lists instead of `document()`), see `crates/core/scripts/` and
`crates/core/src/engine/schematron.md`. Only the XRechnung Schematron (own `xsl:function`) and
Mustang's CEN run for XRechnung still run as XSLT.

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

`crates/core/build.rs` regenerates the table of embedded artifacts on every change under
`artefakte/`, so adding or removing a file needs no manual step. It also refuses to build a
Schematron source that is still raw from upstream (`<include>` or `abstract="true"` left in
it), because such an artifact would silently validate too little at runtime.

## Structure

Each module is separated into files by concern; next to each `.rs` there is a `.md` of the same name with purpose, norm, pitfalls, and what was deliberately not built. Entry point: `crates/core/src/lib.rs`.

## License

Code: MIT OR Apache-2.0. Embedded third-party artifacts: see `NOTICE.md`.
