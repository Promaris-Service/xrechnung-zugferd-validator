// Die HTTP-Schicht: ein kleiner tiny_http-Server mit festem Worker-Satz.
//   GET  /health   -> "ok"
//   POST /validate  <XML im Body> -> JSON-Bericht
//   GET  /count    -> {"gesamt":N,...} (privat, nur Loopback)
//
// Es wird NIE ein Request-Body protokolliert oder abgelegt. Hoechstens eine inhaltslose
// Statuszeile (Methode, Pfad, Code, Dauer) geht nach stderr. Upload-Grenze und Timeout
// schuetzen vor Missbrauch; Nicht-XML ergibt eine saubere Fehlerantwort.

use std::io::Read;
use std::net::SocketAddr;
use std::sync::Arc;
use std::time::Instant;

use anyhow::Result;
use crate::zaehler::Zaehler;
use tiny_http::{Header, Method, Request, Response, Server};

use crate::antwort::Urteil;
use crate::motor::Motor;

const WORKER: usize = 4;

pub fn serve(addr: SocketAddr, motor: Motor, max_body: usize, zaehler: Zaehler) -> Result<()> {
    let server = Server::http(addr).map_err(|e| anyhow::anyhow!("Server binden: {e}"))?;
    let server = Arc::new(server);
    let motor = Arc::new(motor);
    let zaehler = Arc::new(zaehler);

    let mut handles = Vec::new();
    for _ in 0..WORKER {
        let server = Arc::clone(&server);
        let motor = Arc::clone(&motor);
        let zaehler = Arc::clone(&zaehler);
        handles.push(std::thread::spawn(move || {
            loop {
                match server.recv() {
                    Ok(req) => behandle(req, &motor, max_body, &zaehler),
                    Err(_) => break,
                }
            }
        }));
    }
    for h in handles {
        let _ = h.join();
    }
    Ok(())
}

fn json_header() -> Header {
    Header::from_bytes(&b"Content-Type"[..], &b"application/json; charset=utf-8"[..]).unwrap()
}

fn sende_json(req: Request, code: u16, koerper: String) {
    let resp = Response::from_string(koerper).with_status_code(code).with_header(json_header());
    let _ = req.respond(resp);
}

fn sende_text(req: Request, code: u16, text: &str) {
    let resp = Response::from_string(text).with_status_code(code);
    let _ = req.respond(resp);
}

// Kleiner, handgebauter Fehlerkoerper, damit auch der Fehlerweg kein serde braucht.
fn fehler_json(art: &str, meldung: &str) -> String {
    format!(
        "{{\"fehler\":\"{}\",\"meldung\":\"{}\"}}",
        escape(art),
        escape(meldung)
    )
}

fn escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if (c as u32) < 0x20 => out.push_str(&format!("\\u{:04x}", c as u32)),
            c => out.push(c),
        }
    }
    out
}

// PDF erkennen: die Signatur `%PDF-` steht laut Norm in den ersten 1024 Byte, praktisch
// ganz am Anfang. Fuehrende Leerraum-/Steuerzeichen werden uebersprungen.
fn ist_pdf(buf: &[u8]) -> bool {
    let anfang = &buf[..buf.len().min(1024)];
    let ab = anfang
        .iter()
        .position(|b| !b.is_ascii_whitespace())
        .unwrap_or(0);
    anfang[ab..].starts_with(b"%PDF-")
}

fn behandle(req: Request, motor: &Motor, max_body: usize, zaehler: &Zaehler) {
    let start = Instant::now();
    let methode = req.method().clone();
    let url = req.url().to_string();
    let pfad = url.split('?').next().unwrap_or("").to_string();

    let code = match (&methode, pfad.as_str()) {
        (Method::Get, "/health") => {
            sende_text(req, 200, "ok\n");
            200
        }
        // Privater Nutzungsstand (nur Loopback erreichbar). Nur eine Zahl.
        (Method::Get, "/count") => {
            sende_json(req, 200, zaehler.json());
            200
        }
        (Method::Post, "/validate") => {
            let c = validate(req, motor, max_body);
            // Nur abgeschlossene Validierungen zaehlen (Bericht 200 oder Fachurteil 422).
            if c == 200 || c == 422 {
                zaehler.plus();
            }
            c
        }
        (_, "/validate") | (_, "/health") | (_, "/count") => {
            sende_json(req, 405, fehler_json("methode", "Methode nicht erlaubt"));
            405
        }
        _ => {
            sende_json(req, 404, fehler_json("pfad", "Unbekannter Pfad"));
            404
        }
    };

    // Inhaltslose Statuszeile: keine Payload, kein Body.
    eprintln!("{:?} {} -> {} ({} ms)", methode, pfad, code, start.elapsed().as_millis());
}

// tiny_http beantwortet einen Request per Wert; die Funktion verbraucht ihn in jedem
// Zweig genau einmal und gibt den gesendeten Statuscode fuer die Statuszeile zurueck.
fn validate(mut req: Request, motor: &Motor, max_body: usize) -> u16 {
    // Body bis max_body+1 lesen; ein Byte mehr bedeutet "zu gross".
    let mut buf = Vec::new();
    if req.as_reader().take((max_body as u64) + 1).read_to_end(&mut buf).is_err() {
        return antworte(req, 400, fehler_json("body", "Body nicht lesbar"));
    }
    if buf.len() > max_body {
        return antworte(req, 413, fehler_json("zu-gross", "Upload ueber Groessengrenze"));
    }
    if buf.is_empty() {
        return antworte(req, 400, fehler_json("leer", "Leerer Body, XML oder PDF erwartet"));
    }

    // Art der Eingabe am Anfang des Bodys erkennen (Content-Type ist egal): ein PDF
    // beginnt mit `%PDF`, alles andere wird als XML behandelt.
    let urteil = if ist_pdf(&buf) {
        // PDF roh (Bytes) in die Component geben; dort wird extrahiert und geprueft.
        motor.pruefe_pdf(buf)
    } else {
        let xml = match String::from_utf8(buf) {
            Ok(s) => s,
            Err(_) => return antworte(req, 400, fehler_json("utf8", "Body ist weder PDF noch gueltiges UTF-8/XML")),
        };
        motor.pruefe(xml)
    };

    match urteil {
        Ok(Urteil::Bericht(b)) => {
            let koerper = serde_json::to_string(&b).unwrap_or_else(|_| "{}".to_string());
            antworte(req, 200, koerper)
        }
        Ok(Urteil::Fach(f)) => {
            let koerper = serde_json::to_string(&f).unwrap_or_else(|_| "{}".to_string());
            antworte(req, 422, koerper)
        }
        Ok(Urteil::Grenze(g)) => {
            // Ressourcengrenze gegriffen (Speicher/Tabelle/Zeit): der Beleg ist zu
            // gross/komplex. Sauberer 422 statt Host-Crash; kein Nutzdaten-Log.
            let koerper = serde_json::to_string(&g).unwrap_or_else(|_| "{}".to_string());
            antworte(req, 422, koerper)
        }
        Err(e) => {
            // Kein Body, kein XML im Log: nur eine kurze interne Notiz ohne Nutzdaten.
            eprintln!("interner Pruef-Fehler: {e}");
            antworte(req, 500, fehler_json("intern", "Pruefung fehlgeschlagen"))
        }
    }
}

fn antworte(req: Request, code: u16, koerper: String) -> u16 {
    let resp = Response::from_string(koerper).with_status_code(code).with_header(json_header());
    let _ = req.respond(resp);
    code
}
