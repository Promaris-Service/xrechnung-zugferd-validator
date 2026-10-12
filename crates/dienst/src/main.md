# main.rs — Einstieg des Prüfdienstes

## Zweck

Diese Datei ist der Prozesseinstieg des HTTP-Dienstes. Sie

- liest die Laufzeitkonfiguration aus Umgebungsvariablen,
- erzeugt die Zieladresse für den TCP-Listener,
- baut den Prüfmotor genau einmal auf — dabei wird die WASI-Component einmal kompiliert — und
- startet die HTTP-Verarbeitung.

Der Dienst speichert keine Request-Bodies. Protokolliert wird maximal eine inhaltslose Statuszeile mit Methode, Pfad, Statuscode und Dauer.

## Begründung & Designentscheidungen

Der Validator läuft pro Prüfung in einer frischen, isolierten WASI-Instanz. Der teure Aufbau der Laufzeit und das Kompilieren der Component passieren deshalb nur einmal beim Start. Die eigentliche Prüfung ist in `motor.rs` gekapselt, der HTTP-Transport in `http.rs`.

Konfiguration erfolgt ausschließlich über Umgebungsvariablen. Das macht den Dienst gut in Prozess-Supervisoren, Containern und systemd-Umgebungen einbettbar, ohne Config-Datei oder Neubau. Die Hilfsfunktionen `env_usize` und `env_u64` ersetzen fehlende oder nicht parsebare numerische Werte durch die Vorgaben.

Die Standardgrenzen sind bewusst großzügig gewählt. Der 64-MiB-Wasm-Stack reicht allein nicht aus: Die in die Wasm-Component kompilierte Schematron-Rekursion erzeugt tiefe native Frames. Deshalb läuft jede Prüfung auf einem eigenen Thread mit großem nativem Stack (`ERECHNUNG_THREAD_STACK`).

Die Bindung erfolgt standardmäßig nur an Loopback. Damit ist der Dienst ohne vorgelagerten Proxy nicht aus dem Netz erreichbar.

## Konfiguration

| Variable | Vorgabe | Bedeutung |
|---|---|---|
| `ERECHNUNG_BIND` | `127.0.0.1:8093` | Bind-Adresse für den HTTP-Server |
| `ERECHNUNG_WASM` | `/data/erechnung-validator/erechnung_validator_wasi.wasm` | Pfad zur WASI-Component |
| `ERECHNUNG_MAX_BODY` | `16777216` (16 MiB) | Upload-Grenze in Byte |
| `ERECHNUNG_TIMEOUT_S` | `60` | harte Zeitgrenze je Prüfung in Sekunden |
| `ERECHNUNG_WASM_STACK` | `67108864` (64 MiB) | `max_wasm_stack` der Wasm-Laufzeit |
| `ERECHNUNG_THREAD_STACK` | `268435456` (256 MiB) | nativer Stack des Prüf-Threads |
| `ERECHNUNG_MAX_MEMORY` | `536870912` (512 MiB) | hartes Linear-Memory-Limit je Instanz |

## Umgesetzte Norm

Keine. Diese Datei ist reiner Transport- und Aufbaucode. Die fachlichen EN16931-, KoSIT-, Mustang- und XRechnung-Regeln werden in der WASI-Component ausgeführt und über `motor.rs` angesteuert.

## Bewusste Nicht-Entscheidungen

- Kein TLS: Der Dienst bindet standardmäßig nur an Loopback; TLS terminiert ein vorgelagerter Proxy oder die betreibende Website.
- Keine Persistenz: Request-Bodies werden nicht auf Platte abgelegt, es gibt keine Konfigurationsdatei und keine inhaltsbezogenen Logs.
- Keine dynamische Nachladbarkeit der Component: Der Pfad zur WASI-Component wird nur beim Start gelesen.
