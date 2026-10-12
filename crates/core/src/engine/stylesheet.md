# `stylesheet.rs` – XSLT/Schematron-Stylesheets ausführen

## Zweck

Dieses Modul kompiliert eingebettete XSLT-Stylesheets und führt sie auf einem geparsten Beleg aus. Die Stylesheets sind die bereits aus den Schematron-Regelwerken erzeugten XSLT-Artefakte (KoSIT/XRechnung, Mustang/Factur-X/ZUGFeRD). Das Ergebnis ist SVRL-Text, der von `svrl.rs` in einzelne Befunde überführt wird.

## Begründung und Designentscheidungen

- **Trennung von Kompilierung und Ausführung:** `kompiliere` erzeugt ein `Kompiliert`, das anschließend beliebig oft für Belege verwendet werden kann. Das vermeidet wiederholtes Laden und Kompilieren des Artefakts.
- **Speicher statt Dateisystem:** Artefakt und Mustang-Codelisten werden über `artefakte` aus dem eingebetteten Speicher geladen. Das ist für den Betrieb als WASI-Modul erforderlich.
- **`MemoryResolver` für `document()`:** Mustang-Stylesheets rufen Codelisten über `document('FACTUR-X_…_codedb.xml')` auf. Der Resolver beantwortet diese Aufrufe aus dem Speicher; externe Dateizugriffe unterbleiben.
- **Erkennung über Pfadpräfix:** Nur bei Artefakten unter `mustang/` werden die Codelisten registriert. Die übrigen Artefakte benötigen diesen Resolver nicht.
- **Basis-URI:** Die Artefakt-URI wird als Basis-URI gesetzt, damit das Laufzeitmodul `document()`-Aufrufe und relative Verweise eindeutig auflösen kann.
- **Stack-Konfiguration:** Die Engine reicht `stack_bytes` als expliziten Parameter an das XSLT-Laufzeitmodul weiter. Die EN-16931-Stylesheets rekursieren tief, daher muss der aufrufende Thread bzw. WASI-Shadow-Stack ausreichend groß sein.
- **Fehlerkontext:** Compile- und Transformationsfehler werden mit dem Artefaktpfad versehen.

## Umgesetzte Norm

Dieses Modul setzt selbst keine EN-16931-Regel um. Es führt die von KoSIT und Mustang veröffentlichten XSLT-Artefakte aus, die den Regelbestand für XRechnung und Factur-X/ZUGFeRD abbilden. Besonders relevant ist die Unterstützung der Mustang-Codelisten per `document()`.

## Bewusste Nicht-Entscheidungen

- **Kein `xsl:include`/`xsl:import`-Resolver:** Keines der aktuell eingebetteten Artefakte verwendet externe Includes.
- **Keine Erkennung außer `mustang/`:** Es wird nicht versucht, aus dem Stylesheet-Inhalt zu erkennen, ob Codelisten benötigt werden; die Zuordnung erfolgt über den Artefaktpfad.
- **Keine Laufzeitgarantie für `stack_bytes`:** Der Parameter wird nicht gegen den tatsächlichen Stack des aktuellen Threads geprüft. Ein zu kleiner Wert kann einen Prozessabbruch zur Folge haben. Die Verantwortung liegt beim Aufrufer.
- **Keine Timeouts oder Größenbeschränkungen:** Die Ausführung hat keine Abbruchlogik für besonders große oder aufwendige Belege.
