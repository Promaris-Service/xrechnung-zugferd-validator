# zaehler.rs — Nutzungszaehler

## Zweck
Zaehlt, wie viele Belege der Dienst insgesamt geprueft hat — eine reine Zahl, ohne jeden
Belegbezug. Dient dem Betreiber als privater Nutzungsindikator.

## Begruendung & Designentscheidungen
- **Datenschutz:** Es wird ausschliesslich hochgezaehlt. Kein Dateiname, kein Inhalt, keine
  IP — passend zur No-Logging-Zusage des Dienstes.
- **Privat per Design:** Abrufbar nur ueber `GET /count` am Loopback (`127.0.0.1`); von
  aussen nicht erreichbar.
- **Persistenz opt-in:** Ohne `ERECHNUNG_COUNTER_FILE` zaehlt der Dienst nur im Speicher
  (Reset bei Neustart). Mit gesetzter Datei ueberlebt der Stand Neustarts
  (Zeile 1 = Zahl, Zeile 2 = Startzeit als Unix-Epoch).
- **Nebenlaeufig korrekt:** `AtomicU64` fuer den Stand; der in die Datei geschriebene Wert
  wird unter einem Mutex aus dem Atomic gelesen, damit die Datei auch bei parallelen
  Workern monoton bleibt.

## Schnittstelle
- `GET /count` -> `{"gesamt":N,"seit_epoch":S,"persistent":true|false}`.
- Hochgezaehlt wird je abgeschlossener Validierung (`POST /validate` mit Urteil).

## Bewusst nicht
- Keine Zeitreihen/Historie, keine Unterscheidung nach Werkzeug — nur die Gesamtzahl.
  Wer mehr will, setzt eine Metrik-/Logsenke davor.
