# `artefakte/mod.rs` – eingebettete Prüfartefakte und Speicherauflösung

**Zweck (was).**  
Dieses Modul ist die schmale API über die eingebetteten Validierungs-Artefakte. Es beschreibt einzelne Artefakte als Pfad-Text-Paar (`Datei`) und bietet Zugriffe über Pfad (`finde`) und URI (`finde_uri`). Die eigentlichen Daten liegen im Modul `tabelle` und sind per `include_str!` Teil des Binaries bzw. der WASM-Komponente.

**Begründung und Designentscheidungen (warum).**
- *WASI ohne Dateisystem.* Eine WASI-Component kann kein lokales Dateisystem voraussetzen. Durch das Einbetten entfällt jede Abhängigkeit von ausgelieferten Begleitdateien.
- *Konsistente URI-Basis.* `BASIS = file:///artefakte/` ist bewusst ein `file:`-URI. Dadurch lösen XSLT/XSD-Engines relative Verweise wie `document('…_codedb.xml')` oder `schemaLocation`-Hinweise hierarchisch auf, ohne dass tatsächlich auf einen Datenträger zugegriffen wird.
- *Trennung von Daten und API.* Die generierte Tabelle (`tabelle`) enthält nur statische Pfad-Text-Paare; dieses Modul enthält die Auflösungslogik.
- *Deterministische Suche.* `finde` durchsucht zuerst die KoSIT-Artefakte und danach die Mustang-Artefakte. Es gibt keine Laufzeit-I/O und keine versteckte Fallback-Quelle.

**Umgesetzte Norm/Quelle.**  
Das Modul enthält selbst keine EN16931-Regel, stellt aber die Regeldateien bereit. `VERSION` benennt den Stand:
- KoSIT-XRechnung-Konfiguration `2026-08-31`, XRechnung 3.0.2, CEN EN16931 1.3.16 als Schematron
- Mustang 2.24.0, Factur-X 1.0 ZF_250 als Schematron, XRechnung 1.2–3.0

**API im Detail.**
- `Datei`: ein Artefakt mit Pfad unterhalb von `artefakte/` und statischem Text.
- `VERSION`: öffentlicher Stand der eingebetteten Artefakte.
- `BASIS`: kanonische URI-Basis für alle Artefakte.
- `uri(pfad)`: erzeugt aus einem relativen Artefaktpfad die vollständige `file:`-URI.
- `finde(pfad)`: liefert den Text zu einem relativen Artefaktpfad, falls vorhanden.
- `finde_uri(uri)`: liefert den Text zu einer `file:///artefakte/...`-URI. Wenn die direkte Pfadsuche fehlschlägt, wird eine Alias-Auflösung für abweichende Factur-X-Dateinamen versucht.
- `mustang_codelisten()`: liefert alle Mustang-Codelisten mit der Endung `_codedb.xml`, die von den Factur-X-XSLTs per `document()` geladen werden.

**Wichtige Fallgrube.**  
Die Factur-X-XSDs nennen in `schemaLocation`-Hinweisen Dateinamen im Format `Factur-X_1.09_*`; Mustangs Auslieferung verwendet dagegen `FACTUR-X_*`. `finde_uri` bildet deshalb nach der direkten Suche den abweichenden Namen ab und ersetzt zusätzlich `BASICWL` durch `BASIC-WL`. Ohne diese Abbildung wären die Schema-Importe lediglich ignorierte Hinweise.

**Bewusste Nicht-Entscheidungen.**
- Keine Laufzeit-Nachladung von Artefakten, kein Netzwerkzugriff und kein Dateisystemzugriff.
- Keine allgemeine URI-Normalisierung oder Percent-Decoding; unterstützt werden die intern erzeugten und aus den Artefakten referenzierten URIs.
- Neue Artefaktstände sind ein neues Release und werden über `VERSION` dokumentiert.
