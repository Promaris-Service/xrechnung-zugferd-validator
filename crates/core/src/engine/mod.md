# `engine/` — oxixml-Anbindung

## Zweck

Das Modul `engine` kapselt den gesamten Zugriff auf die externen XML-Bibliotheken (`oxixml-xslt`, `oxixml-schema`, `oxixml-infoset`). Es stellt geparste Dokumente sowie kompilierte und ausführbare Validierungsartefakte bereit. Fachliche Validierungsmodule wie `kosit/` und `mustang/` arbeiten nur mit den hier definierten Typen `Dokument`, `Cache`, `Stylesheet` und `Schema` und müssen keine XML-Interna kennen.

## Begruendung & Designentscheidungen

Die Engine ist als eigene Schicht gekapselt, weil sie noch jung ist (0.1.x). API-Änderungen oder ein möglicher Wechsel auf eine andere XML-Engine betreffen nur dieses Verzeichnis; die fachliche Regelprüfung bleibt unverändert.

Die Aufteilung folgt den unterschiedlichen Ausführungswegen:

- `dokument.rs` parst einen Beleg genau einmal und bestimmt Syntax und Kennung.
- `stylesheet.rs` kompiliert Schematron-XSLT aus dem Speicher und führt sie aus.
- `schema.rs` kompiliert einen XSD-Satz aus dem Speicher und prüft dagegen.
- `schematron.rs` führt Schematron-Quellen direkt aus; dieser Weg ist schneller als der XSLT-Weg.
- `cache.rs` hält kompilierte Artefakte je Validator-Exemplar vor.

Durch die Trennung von direkter Schematron-Ausführung und XSLT-basierter Ausführung kann je nach Validierungskontext der schnellere oder der kompatiblere Weg gewählt werden.

## Umsetzung der Norm

In diesem Modul ist keine einzelne EN16931-/XRechnung-/ZUGFeRD-Regel implementiert. Es stellt die technische Laufzeitumgebung für XSD- und Schematron-Prüfungen bereit, die von den fachlichen Modulen aufgerufen werden. Die hier ausgeführten Schematron- und XSD-Prüfungen sind die Mechanismen, mit denen EN16931-Regeln sowie die nationalen Spezifikationen von KoSIT/XRechnung und Mustang/ZUGFeRD technisch validiert werden.

## Bewusste Nicht-Entscheidungen

- Es wird keine fachliche Regelprüfung direkt in `engine/` implementiert; die Regeln liegen in den aufrufenden Modulen.
- Es wird kein automatischer Fallback zwischen Schematron-XSLT und direktem Schematron-Pfad vorgegeben; die Auswahl bleibt dem Aufrufer überlassen.
- Die Modulgrenzen bilden Engine-Aufrufe ab, nicht die Gliederung der EN16931-Geschäftsregeln.
