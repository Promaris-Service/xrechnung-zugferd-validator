//! Beispiel-Host: laedt die Component, ruft `kosit` und `mustang` auf einem Beleg auf.
//! Aufruf: host-wasmtime <erechnung_validator_wasi.wasm> <beleg.xml>
//! Zeigt, was ein Abnehmer braucht: WASI-p2-Linker, grosser Wasm-Stack, typisierte Bindings.

use wasmtime::{Result, format_err};
use wasmtime::component::{Component, Linker, ResourceTable};
use wasmtime::{Config, Engine, Store};
use wasmtime_wasi::{WasiCtx, WasiCtxBuilder, WasiCtxView, WasiView};

wasmtime::component::bindgen!({
    world: "validator",
    path: "../../crates/component/wit",
});

struct Host {
    wasi: WasiCtx,
    table: ResourceTable,
}

impl WasiView for Host {
    fn ctx(&mut self) -> WasiCtxView<'_> {
        WasiCtxView { ctx: &mut self.wasi, table: &mut self.table }
    }
}

fn main() -> Result<()> {
    let mut args = std::env::args().skip(1);
    let wasm = args.next().ok_or_else(|| format_err!("Pfad zur .wasm fehlt"))?;
    let beleg = args.next().ok_or_else(|| format_err!("Pfad zum Beleg fehlt"))?;
    let xml = std::fs::read_to_string(&beleg).map_err(|e| format_err!("{beleg}: {e}"))?;

    let mut config = Config::new();
    config.wasm_component_model(true);
    // Die EN-16931-Stylesheets rekursieren tief: Stack auf 64 MiB (Standard 512 KiB).
    config.max_wasm_stack(64 * 1024 * 1024);
    config.async_stack_size(128 * 1024 * 1024);
    let engine = Engine::new(&config)?;
    let component = Component::from_file(&engine, &wasm)?;

    let mut linker = Linker::new(&engine);
    wasmtime_wasi::p2::add_to_linker_sync(&mut linker)?;
    let host = Host { wasi: WasiCtxBuilder::new().inherit_stderr().build(), table: ResourceTable::new() };
    let mut store = Store::new(&engine, host);
    let validator = Validator::instantiate(&mut store, &component, &linker)?;
    let pruefung = validator.promaris_erechnung_pruefung();

    use exports::promaris::erechnung::pruefung::Szenarien;
    let t = std::time::Instant::now();
    let (kosit, mustang) = pruefung.call_beide(&mut store, &xml, Szenarien::Automatisch)?;
    let dauer = t.elapsed();
    for (name, r) in [("KoSIT", kosit), ("Mustang", mustang)] {
        match r {
            Ok(b) => {
                println!(
                    "{name}: szenario={} xsd={} angenommen={} befunde={} ({} ms Pruefung)",
                    b.szenario, b.xsd_gueltig, b.angenommen, b.befunde.len(), b.dauer_ms
                );
                for f in b.befunde.iter().take(10) {
                    println!("   {:?} {} {}", f.stufe, f.regel, f.text.chars().take(100).collect::<String>());
                }
            }
            Err(e) => println!("{name}: Fehler {e:?}"),
        }
    }
    println!("Gesamt inkl. erster Kompilierung: {dauer:?}");
    Ok(())
}
