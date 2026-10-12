# `pruefung.rs` — KoSIT-Prüfablauf

## Zweck
Die Funktion `pruefe` orchestriert die vollständige Konformitätsprüfung eines Dokuments nach dem KoSIT-Ablauf: Szenario auswählen, XSD-Validierung, bei Erfolg Ausführung aller im Szenario hinterlegten Schematron-/XSLT-Prüfungen, Umwandlung der SVRL-Ergebnisse in Befunde, Anwendung optionaler Stufen-Mappings und Ermittlung der Annahme. Sie liefert einen `Bericht` mit allen Befunden, der Annahmeentscheidung und Metadaten.

## Begründung & Designentscheidungen
- Zentraler Einstiegspunkt für KoSIT-Prüfungen. Alle kompilierten Artefakte werden über `Cache` geholt, damit wiederholte Prüfungen effizient sind.
- **Abbruch bei XSD-Fehlern:** Schematron-Prüfungen laufen nur, wenn die XSD-Validierung erfolgreich war. Das entspricht dem Verhalten des KoSIT-Validators (`DefaultCheck`) und vermeidet Arbeit auf syntaktisch ungültigen Dokumenten.
- **Zwei Artefaktarten:** Pfade mit Endung `.sch` werden als Schematron-Quellen direkt geprüft (`cache.schematron`), alle anderen Pfade als vorkompilierte XSLT-Stylesheets ausgeführt und ihr SVRL-Ergebnis in Befunde überführt.
- **Stufen-Mapping:** Falls das gewählte Szenario eine Stufen-Konfiguration besitzt, werden die Befundstufen anhand der Regelbezeichnung überschrieben. So können fachliche Regeln z. B. als Warnung statt Fehler eingestuft werden, ohne die Schematron-Dateien zu ändern.
- **Annahme:** Ein Dokument gilt als angenommen, wenn die XSD-Validierung erfolgreich ist und nach Anwendung des Stufen-Mappings kein Befund mehr die Stufe `Fehler` besitzt.

## Umgesetzte Norm
Die Datei setzt keine einzelne EN16931-/XRechnung-Regel um, sondern bildet den Prüfablauf des KoSIT-Validators ab: XSD zuerst, Schematron nur bei gültiger XSD, danach Stufen-Mapping und Annahmeentscheidung. Die fachlichen Regeln ergeben sich aus dem gewählten Szenario (`Szenarien`), das Syntax und Dokumentkennung zu XSD-/XSLT-Pfaden und optionalen Stufen-Mappings auflöst.

## Bewusste Nicht-Entscheidungen
- Es gibt keine getrennte Messung von Cache-Treffern oder Kompilierungszeiten. `dauer_ms` ist die gesamte Wanduhrzeit der Funktion und kann bei einem kalten Cache auch das Laden/Kompilieren von Schema und Stylesheets enthalten.
- Es erfolgt hier keine eigene fachliche Prüfung; alle Befunde kommen aus den ausgelieferten XSD-/Schematron-/XSLT-Artefakten.
- Persistenz, Logging oder Berichtsspeicherung sind nicht Teil dieser Funktion.
