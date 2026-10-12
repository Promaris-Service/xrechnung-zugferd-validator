# `dokument.rs` — Beleg parsen und einordnen

## Zweck (was)

Die Datei stellt die zentrale Eingangsverarbeitung für einen E-Rechnungs-Beleg bereit. `Dokument::parse` nimmt den Rohtext eines XML-Belegs, bestimmt die Syntax (CII oder UBL Invoice/CreditNote), parst den Beleg in einen gemeinsamen `oxixml_infoset::Tree` und ermittelt die Profilkennung (`CustomizationID` bzw. Guideline-ID).

Das Ergebnis ist eine `Dokument`-Instanz, die im weiteren Lauf von allen Prüfungen geteilt wird.

## Begründung & Designentscheidungen (warum)

Die Syntax wird bewusst vor dem vollständigen XML-Parsing aus dem Rohtext bestimmt, weil die Kennung darüber entscheidet, welche Validierungsartefakte geladen werden. So wird für die Einordnung kein zweiter XML-Durchlauf benötigt; der Baum wird genau einmal erzeugt und anschließend wiederverwendet.

`wurzel` sucht das erste Element nach dem Prolog und verwendet den lokalen Namen (`Invoice`, `CreditNote`, `CrossIndustryInvoice`), dadurch ist die Erkennung präfixunabhängig.

`kennung` liest die Profilkennung ebenfalls als Rohtext. Für CII wird zuerst der Anker `GuidelineSpecifiedDocumentContextParameter` lokalisiert und erst danach das nächste `ID`-Element gelesen, damit ein früheres `ID`-Element wie `BusinessProcess` nicht fälschlich verwendet wird. Für UBL wird direkt die `CustomizationID` gesucht.

Für die gelesenen Textinhalte werden die fünf vordefinierten XML-Entitäten dekodiert.

## Umgesetzte Norm (welche EN16931/KoSIT/Mustang/XRechnung-Regel)

- EN 16931-1/-3: Konforme Instanzen sind entweder UBL 2.1 (`Invoice` oder `CreditNote`) mit `cbc:CustomizationID` oder UN/CEFACT CII (`CrossIndustryInvoice`) mit `ram:ID` im `ram:GuidelineSpecifiedDocumentContextParameter`.
- XRechnung/KoSIT: Fordert in beiden Syntaxen die entsprechende Kennung; typische Werte enthalten `urn:cen.eu:en16931:2017` und `urn:xeinkauf.de:kosit:xrechnung_3.0`.
- Mustang: Die Kennung dient zur Auswahl der passenden XSLT-/Validierungsartefakte und damit zur Bestimmung des anwendbaren Regelwerks.

## Bewusste Nicht-Entscheidungen

- Keine Reparatur oder Korrektur von defektem XML; nicht wohlgeformte Eingaben werden mit `Fehler::Dokument` zurückgewiesen.
- Keine semantische oder Schematron-Prüfung an dieser Stelle; es werden ausschließlich Syntax, Baum und Kennung vorbereitet.
- Keine allgemeine XML-Entity- oder DTD-Auflösung; es werden nur die fünf vordefinierten XML-Entitäten behandelt.
- Die Rohtext-Heuristik ist schlank und auf übliche, einfache Prologe und Kennungs-Elemente ausgelegt; sie ist kein vollständiger XML-Tokenizer.
