# Artefakte aktualisieren (KoSIT / EN16931 / Mustang-FeRD)

Die eingebetteten Pruefartefakte sind auf feste Upstream-Versionen gepinnt
(`docs/artefakte-quellen.toml`). KoSIT und FeRD/FNFE-MPE (via Mustang) veroeffentlichen
regelmaessig neue Fassungen — dann muessen die Artefakte erneuert und neu kompiliert werden.

## Automatische Erkennung
`scripts/pruefe-artefakt-updates.py` vergleicht die Pins gegen die neuesten Upstream-Releases
(Exit 10 = Updates verfuegbar). Laeuft als woechentlicher CI-Job (siehe
`.forgejo/workflows/artefakt-updates.yml`), der bei neuer Version meldet.

## Manuell pruefen
    python3 scripts/pruefe-artefakt-updates.py      # GITHUB_TOKEN optional gegen Rate-Limit

## Update durchfuehren
1. Neue Artefakte vom jeweiligen Upstream-Release holen (Verzeichnis siehe Pin-Datei).
2. Vorverarbeiten (Schematron-Includes zusammenfuehren, Factur-X-Codelisten einsetzen).
3. In `crates/core/artefakte/` ablegen. Die `&'static str`-Tabellen erzeugt `crates/core/build.rs`
   beim nächsten Bau selbst; eine Datei mehr oder weniger wird automatisch übernommen.
   Liegt eine `.sch` noch roh vor (`<include>`, `abstract="true"`), bricht der Bau ab und
   nennt den fehlenden Vorverarbeitungsschritt.
4. `cargo test` + **255/255 gegen die neue KoSIT-/Mustang-Referenz** (Gold-Standard;
   neue Regeln koennen Urteile aendern — die Referenz wandert mit).
5. `VERSION` in `artefakte/mod.rs`, die Tabelle in `NOTICE.md` und `docs/artefakte-quellen.toml`
   aktualisieren.
