# http.rs — HTTP-Transport

## Zweck
Die Datei realisiert die HTTP-Schicht des Dienstes. Ein kleiner `tiny_http`-Server mit festem Worker-Satz (4 Threads) nimmt Anfragen entgegen und übersetzt sie in Aufrufe des `Motor`.

Routen:

| Methode | Pfad | Bedeutung | Statuscodes |
|---|---|---|---|
| `GET` | `/health` | Liveness/Selbsttest | `200` |
| `POST` | `/validate` | XML- oder PDF-Prüfung | `200`, `400`, `413`, `422`, `500` |
| andere auf `/health` oder `/validate` | — | Methode nicht erlaubt | `405` |
| sonst | — | Unbekannter Pfad | `404` |

Die Antwort ist mit Ausnahme von `/health` (Text `ok`) immer JSON. Erfolg (`200`) liefert den JSON-Bericht aus `antwort.rs`. Fehlerantworten folgen dem Schema `{"fehler":"…","meldung":"…"}`.

## Begruendung & Designentscheidungen

- **Schlanker Transport, keine Nutzdaten im Log.** Die Schicht protokolliert ausschließlich Methode, Pfad, Statuscode und Dauer. Der Request-Body wird weder gespeichert noch protokolliert. Interne Fehler werden nach außen als generisches `intern` gemeldet; technische Details gehen nur kurz nach stderr, ohne Nutzdaten.
- **Begrenzte Uploads.** Es werden maximal `max_body + 1` Byte gelesen. Ein einziges Byte über der Grenze zeigt an, dass der Upload zu groß ist, und führt zu `413`. So bleibt der Speicherverbrauch kontrolliert.
- **Synchron und mit festem Thread-Satz.** `tiny_http` blockiert; vier Worker teilen sich die Annahme. Die Prüfung ist erwartungsgemäß synchron und benötigt einen großen nativen Stack, daher ist async hier bewusst vermieden.
- **Explizite Eingabeerkennung.** Die Datei verlässt sich nicht auf `Content-Type`, sondern prüft die ersten 1024 Byte des Bodys auf die PDF-Signatur `%PDF-`. XML/UBL/CII wird als UTF-8-String an den Motor gegeben.
- **Fehlerweg ohne serde.** Der kleine JSON-Fehlerkörper wird von Hand erzeugt, damit der Fehlerpfad keine serde-Abhängigkeit aktiviert und das Escaping vollständig kontrolliert bleibt.

## Umgesetzte Norm
Keine. Diese Datei setzt keine EN16931-, KoSIT-, XRechnung- oder ZUGFeRD-Regel um. Sie ist reiner Transport. Die fachliche Prüfung erfolgt im Motor. Relevant ist nur die HTTP-Semantik (Statuscodes) sowie die PDF-Signaturprüfung: `%PDF-` innerhalb der ersten 1024 Byte gemäß PDF-Spezifikation.

## Bewusste Nicht-Entscheidungen

- **Kein Content-Type-Zwang.** Ob XML oder PDF vorliegt, entscheidet der Body-Anfang, nicht der Header. Ob es ein gültiger Beleg ist, entscheidet die eigentliche Prüfung im Motor.
- **Keine HTTP-Feinheiten.** Kein Keep-Alive, Chunked-Encoding, TLS, Authentifizierung, CORS oder HTTP/2. `tiny_http` genügt für einen Dienst hinter einem Proxy oder auf Loopback.
- **Kein async.** Ein fester Thread-Satz ist einfacher und vermeidet async-bedingte Komplexität.
- **Keine Request-Body-Logs.** Es werden bewusst keine Payloads im Klartext oder auszugsweise gespeichert oder protokolliert.

## Falle
`tiny_http::Request::respond` konsumiert den Request. Deshalb nimmt `validate` den Request per Wert und jeder Zweig beantwortet ihn genau einmal. `antworte` gibt den gesendeten Statuscode nur für die Statuszeile zurück.
