## Zweck

Stellt eine Funktion zum Kompilieren und Ausführen von Schematron-Quelldateien bereit. Die Prüfungen laufen direkt über die Bibliothek `oxixml-schematron` auf dem XML-Infoset, ohne den Umweg über XSLT-Transformation oder SVRL-Text.

## Begründung & Designentscheidungen

- **Performance**: Direkte Ausführung ist deutlich schneller als der klassische XSLT-Weg (ca. doppelt so schnell auf dem Bestand, Kompilierung in 20 ms statt 500 ms).
- **Direkter Report-Zugriff**: Befunde werden direkt aus dem internen Report-Objekt extrahiert, keine SVRL-Serialisierung nötig.
- **Vorverarbeitung erforderlich**: Die Schematron-Dateien müssen vorab mit `scripts/schematron-vorverarbeiten.py` aufbereitet werden, um Includes einzubetten und abstrakte Muster zu instanziieren. Dadurch entfällt die Notwendigkeit, diese Schritte zur Laufzeit auszuführen.
- **API-Design**: `Kompiliert` hält das kompilierte Schema und bietet eine Methode `befunde`, die einen Baum prüft und eine Liste von `Befund`-Objekten zurückgibt. Der Parameter `mit_reports` steuert, ob nur fehlgeschlagene Assertions oder alle Prüfergebnisse (inkl. Reports) geliefert werden.

## Umgesetzte Norm

Die Datei selbst implementiert keine spezifischen Fachregeln, sondern ist die Ausführungsschicht für Schematron-Dateien, die konkrete Prüfungen enthalten. In diesem Projekt werden darüber die Schematron-Regeln der EN 16931 (CEN/TC 434), der KoSIT XRechnung und von Mustang/Factur-X angewendet. Die Regel-IDs und Fehlermeldungen stammen aus den jeweiligen Artefakten. Die Verarbeitung erfolgt nach ISO/IEC 19757-3 (Schematron), wobei die Vorverarbeitung die dort definierten Mechanismen für Includes und abstrakte Muster abdeckt.

## Bewusste Nicht-Entscheidungen

- **Kein `xsl:function`-Support**: Eingebettete XSLT-Funktionen (z. B. `xr:checkIBAN` in XRechnung) können von der Schematron-Bibliothek nicht ausgeführt werden. Solche Prüfungen laufen weiterhin über den XSLT-basierten Weg (`stylesheet.rs`).
- **Kein `document()`-Zugriff**: Die Engine führt keine externen Dokumentzugriffe aus. Mustang-Schematron wird daher nur dann über diesen Weg genutzt, wenn alle Codelisten vorab eingebettet wurden.
- **Keine SVRL-Ausgabe**: Es wird kein SVRL-Text erzeugt; die Befunde werden direkt als strukturierte Objekte geliefert.
- **Keine Laufzeit-Includes/Abstraktionen**: Die Auflösung von `<include>` und abstrakten Mustern erfolgt nicht zur Laufzeit, sondern in der Vorverarbeitung. Die Engine erwartet bereits eine flache, instanziierte Schematron-Datei.
