# motor.rs — Prüf-Motor

## Zweck
Die Datei enthält den ausführenden Prüf-Motor für den E-Rechnungs-Validator. Sie kompiliert genau einmal eine WASI-Component und erzeugt für jeden Prüfauftrag eine frische, isolierte Instanz. Zwei Eingabeformate werden unterstützt: rohes XML (`pruefe`, CII/UBL) und ZUGFeRD-/Factur-X-PDF (`pruefe_pdf`). In beiden Wegen laufen die Prüfwerkzeuge KoSIT und Mustang im selben Gast; das Ergebnis wird in die Antworttypen aus `antwort.rs` übersetzt.

## Begründung & Designentscheidungen

### Einmal kompilieren, pro Auftrag frisch instanziieren
`Motor::neu` baut `Engine` und `Component` einmalig auf. `pruefe` und `pruefe_pdf` laufen jeweils auf einem eigenen Thread. In `aufbau` wird pro Auftrag ein neuer `Store<Host>` erzeugt, eine neue Instanz instanziiert und nach dem Lauf wieder verworfen. Dadurch kann kein Zustand aus einer früheren Prüfung in die nächste gelangen.

### Rechtlose Instanz
Der `WasiCtx` wird mit `WasiCtxBuilder::new().build()` erzeugt: keine vorgeöffneten Verzeichnisse, kein Netz, keine Umgebungsvariablen, kein Stdio. Die Component importiert außerdem kein `wasi:sockets`; Netzzugriff ist damit technisch unmöglich. `filesystem/preopens` liefert eine leere Liste, daher gibt es keinen erreichbaren Dateipfad.

### Harte Ressourcengrenzen
Der `Grenzwaechter` implementiert `wasmtime::ResourceLimiter` und wird mit `store.limiter(...)` gesetzt. Übersteigt eine Anforderung das konfigurierte Speicherlimit oder die feste Tabellen-Obergrenze, wird ein Fehler zurückgegeben statt `-1`. Dadurch trappt die Allokation sofort, die Instanz wird verworfen, und der Host kann nicht durch eine Entity-Bombe oder übergroße XML-Bäume in einen OOM-Zustand geraten. `grund` merkt sich, welche Grenze gegriffen hat, damit der Aufrufer einen klaren 422 statt eines generischen 500 liefern kann.

### Zeitgrenze über Epoch
`Config::epoch_interruption(true)` aktiviert die Epoch-Interruption. Ein Detached-Thread erhöht die Epoch der `Engine` einmal pro Sekunde. Jeder Store erhält per `set_epoch_deadline(timeout)` eine Deadline. Wird sie erreicht, trappt der laufende Gastaufruf als `Trap::Interrupt` und wird als `zeit-limit` gemeldet.

### Nativer Thread-Stack
Die in Wasm kompilierte Schematron-Rekursion erzeugt tiefe native Frames. Deshalb läuft jede Prüfung auf einem eigenen Thread mit konfigurierbarer nativer Stackgröße. Ohne ausreichend großen nativen Stack würde ein nativer Stack Overflow den Prozess beenden statt in einen sauberen Fehler zu münden.

### Fehler- und Ergebnismodell
`lauf_xml` und `lauf_pdf` rufen die WIT-Funktionen `call_beide` bzw. `call_beide_pdf` mit `Szenarien::Automatisch` auf. Das äußere `Result` beschreibt Host-/Trap-Fehler, das innere je Prüfer den fachlichen Erfolg oder Fehler.

`urteil_bauen` setzt die Gate-Regel um: KoSIT ist das Tor. Liefert KoSIT keinen Bericht, wird die gesamte Prüfung fachlich abgelehnt. Mustang ist ergänzend: Wenn Mustang den Beleg nicht kennt, entfällt sein Bericht und `mustang_hinweis` erklärt den Grund, ohne die Gesamtprüfung abzulehnen.

### PDF-Prüfung vollständig im Gast
Beim PDF-Weg passiert das PDF-Parsing in der Component. Die PDF wird im Gast einmal extrahiert und beiden Prüfern gereicht. Der Host sieht nur die rohen PDF-Bytes und das zurückgegebene Ergebnis. Eine präparierte PDF erreicht daher keinen Dateisystem- oder Netzzugriff und unterliegt denselben Speicher- und Zeitschranken wie XML.

### Fehlerklassifikation
- Ressourcengrenzen (Speicher/Tabelle/Zeit/zu komplex) werden als `Urteil::Grenze` zurückgegeben (fachlicher 422).
- Fachliche Fehler der Component werden als `Urteil::Fach` zurückgegeben.
- Unerwartete Host-/Trap-Fehler werden als `anyhow::Error` weitergegeben (500).

## Umgesetzte Norm
Der Motor selbst implementiert keine EN-16931-Regeln, sondern delegiert sie an die Component. Er wählt `Szenarien::Automatisch`: offizielles XRechnung-Szenario, sonst EN-16931-Kernregeln. Die Prüfwerkzeuge der Component setzen die KoSIT-/XRechnung- und Mustang-Prüfungen um.

## Bewusste Nicht-Entscheidungen

- **Kein Instanz-Pool / kein wiederverwendeter Store.** Das wäre schneller, würde aber Zustand über Aufträge tragen. Frische Instanzen pro Auftrag sind hier gewollt.
- **Kein Vorwärmen.** Die Component kompiliert lazy; dadurch können erste Aufrufe zusätzliche Kosten verursachen. Bewusst zugunsten der Isolationsgarantie in Kauf genommen.
- **Kein Caching von Artefakten oder Dateien.** Die Instanz hat keine Dateisystemfähigkeiten; alle Artefakte kommen aus dem In-Memory-Aufruf.
- **Keine globale, prozessweite Ressourcenabrechnung.** Speicher-, Tabellen- und Zeitschranken gelten pro Auftrag und Instanz.
