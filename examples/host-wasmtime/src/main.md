# main.rs – Beispiel-Host für den E-Rechnungs-Validator

## Zweck (was)

Diese Binärdatei ist ein ausführbares Beispiel für einen Host, der die zu einer WASI-Preview-2-Komponente kompilierten Validierungsfunktionen des E-Rechnungs-Validators lädt und aufruft. Sie nimmt den Pfad zur WASM-Datei und den Pfad zu einer XML-Rechnung entgegen, liest die XML-Datei, instanziiert die Komponente und führt nacheinander die Prüfungen nach KoSIT/XRechnung und Mustang aus. Die Ergebnisse werden mit den wichtigsten Feldern auf der Standardausgabe ausgegeben.

## Begründung & Designentscheidungen (warum)

- **Wasmtime als Host-Runtime:** Die Komponente nutzt das WebAssembly Component Model und WASI Preview 2. `wasmtime` bietet die benötigte Unterstützung für Komponenten, `bindgen!` erzeugt typisierte Bindings aus der WIT-Schnittstelle.
- **Synchroner Aufruf:** Für ein Beispiel ist die einfache synchrone Verarbeitung ausreichend; der Host blockiert, bis die Prüfung abgeschlossen ist.
- **Großer Wasm-Stack:** Die EN-16931-Stylesheets rekursieren tief. `max_wasm_stack` wird deshalb von 512 KiB auf 64 MiB erhöht, um Stack-Überläufe zu vermeiden.
- **Ressourcenverwaltung:** `WasiCtx` und `ResourceTable` werden über `WasiView` bereitgestellt, damit die Komponente auf WASI-Funktionen zugreifen kann. `stderr` wird vererbt, damit Fehlermeldungen der Komponente sichtbar bleiben.
- **Einfaches Fehlermanagement:** Fehler werden als `anyhow::Result` propagiert und bei fehlenden Pfaden sofort gemeldet.

## Umgesetzte Norm (welche EN16931/KoSIT/Mustang/XRechnung-Regel)

Der Host ruft beide zentralen Prüfungen des Projekts auf:
- **KoSIT/XRechnung** gemäß den deutschen Regeln für elektronische Rechnungen (XRechnung) auf Basis von EN 16931.
- **Mustang/ZUGFeRD** für die Prüfung von ZUGFeRD-Dokumenten.

Die Auswahl des Szenarios erfolgt automatisch (`Szenarien::Automatisch`); der Validator erkennt selbst, welches Regelwerk anzuwenden ist.

## Bewusste Nicht-Entscheidungen

- **Keine Parallelisierung:** Die Prüfungen laufen sequenziell; eine gleichzeitige Ausführung wäre möglich, wurde aber zur besseren Nachvollziehbarkeit nicht implementiert.
- **Kein Streaming:** Die XML-Datei wird vollständig als String eingelesen. Für sehr große Belege wäre eine Streaming-Verarbeitung denkbar.
- **Keine erweiterte Fehlerbehandlung:** Es wird nicht zwischen verschiedenen Fehlertypen unterschieden; die Ausgabe ist bewusst simpel gehalten.
- **Keine benutzerdefinierten Szenarien:** Der Host unterstützt nur die automatische Szenarioerkennung; eine manuelle Auswahl ist nicht vorgesehen.
- **Keine Konfiguration über Umgebungsvariablen oder CLI:** Die Parameter sind fest verdrahtet; für produktive Nutzung wäre eine CLI-Bibliothek wie `clap` sinnvoll.
