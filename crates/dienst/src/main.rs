// Einstieg des HTTP-Dienstes: Konfiguration aus der Umgebung lesen, den Motor einmal
// bauen (Component einmal kompilieren) und den HTTP-Server starten.
//
// Der Dienst schreibt NIE einen Request-Body irgendwohin und legt nichts auf Platte ab.
// Protokolliert wird hoechstens eine inhaltslose Statuszeile (Methode, Pfad, Code, Dauer).

mod antwort;
mod http;
mod motor;

use std::net::ToSocketAddrs;

// Grenzen und Vorgaben, alle per Umgebungsvariable ueberschreibbar.
const STD_BIND: &str = "127.0.0.1:8093";
const STD_WASM: &str = "/data/erechnung-validator/erechnung_validator_wasi.wasm";
const STD_MAX_BODY: usize = 16 * 1024 * 1024; // 16 MiB Upload-Grenze
const STD_TIMEOUT_S: u64 = 60; // harte Obergrenze je Pruefung (Epoch-Deadline)
const STD_WASM_STACK: usize = 64 * 1024 * 1024; // 64 MiB Wasm-Stack (EN-16931-Stylesheets)
const STD_THREAD_STACK: usize = 256 * 1024 * 1024; // nativer Stack des Pruef-Threads
const STD_MAX_MEMORY: usize = 512 * 1024 * 1024; // hartes Linear-Memory-Limit je Instanz

fn env_usize(name: &str, std: usize) -> usize {
    std::env::var(name).ok().and_then(|v| v.parse().ok()).unwrap_or(std)
}

fn env_u64(name: &str, std: u64) -> u64 {
    std::env::var(name).ok().and_then(|v| v.parse().ok()).unwrap_or(std)
}

fn main() -> anyhow::Result<()> {
    let bind = std::env::var("ERECHNUNG_BIND").unwrap_or_else(|_| STD_BIND.to_string());
    let wasm = std::env::var("ERECHNUNG_WASM").unwrap_or_else(|_| STD_WASM.to_string());
    let max_body = env_usize("ERECHNUNG_MAX_BODY", STD_MAX_BODY);
    let timeout_s = env_u64("ERECHNUNG_TIMEOUT_S", STD_TIMEOUT_S);
    let wasm_stack = env_usize("ERECHNUNG_WASM_STACK", STD_WASM_STACK);
    let thread_stack = env_usize("ERECHNUNG_THREAD_STACK", STD_THREAD_STACK);
    let max_memory = env_usize("ERECHNUNG_MAX_MEMORY", STD_MAX_MEMORY);

    let addr = bind
        .to_socket_addrs()?
        .next()
        .ok_or_else(|| anyhow::anyhow!("Bind-Adresse ungueltig: {bind}"))?;

    // Component EINMAL kompilieren (teuer). Danach pro Request ein frischer Store.
    let motor = motor::Motor::neu(&wasm, wasm_stack, thread_stack, timeout_s, max_memory)?;

    eprintln!(
        "erechnung-validator-dienst: bind={addr} wasm={wasm} max_body={max_body}B timeout={timeout_s}s max_memory={max_memory}B"
    );

    http::serve(addr, motor, max_body)
}
