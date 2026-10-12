#!/usr/bin/env python3
"""Prueft, ob KoSIT / CEN-EN16931 / Mustang (FeRD/FNFE-MPE) neuere Versionen der
eingebetteten Artefakte veroeffentlicht haben.

Liest die fixierten Versionen aus docs/artefakte-quellen.toml und fragt die neuesten
Releases/Tags der Upstream-Repos ab. Exit-Code 0 = alles aktuell, 10 = Updates verfuegbar,
1 = Abfragefehler. Optionaler GitHub-Token in $GITHUB_TOKEN gegen Rate-Limit.
"""
import json, os, sys, tomllib, urllib.request, urllib.error

PIN = os.path.join(os.path.dirname(__file__), "..", "docs", "artefakte-quellen.toml")

def gh(pfad):
    req = urllib.request.Request("https://api.github.com/" + pfad,
                                 headers={"Accept": "application/vnd.github+json",
                                          "User-Agent": "artefakt-update-check"})
    tok = os.environ.get("GITHUB_TOKEN")
    if tok:
        req.add_header("Authorization", "Bearer " + tok)
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)

def neueste_version(repo):
    """Tag der neuesten Veroeffentlichung; erst Release, sonst neuester Tag."""
    try:
        return gh(f"repos/{repo}/releases/latest").get("tag_name")
    except urllib.error.HTTPError as e:
        if e.code != 404:
            raise
    tags = gh(f"repos/{repo}/tags")
    return tags[0]["name"] if tags else None

def main():
    with open(PIN, "rb") as f:
        quellen = tomllib.load(f)
    updates, fehler = [], []
    for name, q in quellen.items():
        repo, fix = q["repo"], q["fixiert"]
        try:
            neu = neueste_version(repo)
        except Exception as e:
            fehler.append(f"{name} ({repo}): {e}")
            continue
        aktuell = (neu == fix)
        print(f"{'OK ' if aktuell else 'NEU'}  {name:16} fixiert={fix:22} neuester={neu}")
        if not aktuell and neu:
            updates.append((name, repo, fix, neu, q["verzeichnis"]))
    if fehler:
        print("\nAbfragefehler:", file=sys.stderr)
        for f in fehler:
            print("  " + f, file=sys.stderr)
    if updates:
        print("\n*** ARTEFAKT-UPDATES VERFUEGBAR ***")
        for name, repo, fix, neu, verz in updates:
            print(f"  {name}: {fix} -> {neu}  (github.com/{repo}/releases)  Ziel: {verz}")
        print("\nVorgehen: neue Artefakte holen + vorverarbeiten, einbetten, neu kompilieren,")
        print("255/255 gegen die neue KoSIT-/Mustang-Referenz pruefen, dann VERSION in")
        print("artefakte/mod.rs + NOTICE.md + diese Pin-Datei aktualisieren.")
        sys.exit(10)
    if fehler:
        sys.exit(1)
    print("\nAlle Artefakte aktuell.")

if __name__ == "__main__":
    main()
