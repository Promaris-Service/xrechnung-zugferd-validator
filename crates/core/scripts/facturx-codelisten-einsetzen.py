#!/usr/bin/env python3
"""Factur-X-Schematron vorverarbeiten: document('…_codedb.xml')/codedb/cl[@id=N]/enumeration[@value=$v]
durch ($v = ('a','b',…)) ersetzen, damit ein reiner Schematron-Prozessor (ohne XSLT-document()) es ausfuehren kann."""
import re, sys, os
sch, codedb, dst = sys.argv[1], sys.argv[2], sys.argv[3]
cl = {}
for m in re.finditer(r'<cl id="(\d+)">(.*?)</cl>', open(codedb, encoding='utf-8').read(), re.S):
    cl[m.group(1)] = re.findall(r'<enumeration value="([^"]*)"', m.group(2))
s = open(sch, encoding='utf-8').read()
muster = re.compile(r"document\((?:'|&apos;)[^')]+?(?:'|&apos;)\)/codedb/cl\[@id=(\d+)\]/enumeration\[@value=(\$[A-Za-z0-9_]+)\]")
def q(v): return "'" + v.replace("&", "&amp;").replace("'", "''") + "'"
n = 0
def ersetze(m):
    global n; n += 1
    werte = ", ".join(q(v) for v in cl[m.group(1)])
    return f"({m.group(2)} = ({werte}))"
out = muster.sub(ersetze, s)
rest = re.findall(r"document\([^)]*\)[^ <]{0,60}", out)
open(dst, 'w', encoding='utf-8').write(out)
print(os.path.basename(dst), "ersetzt", n, "uebrig", len(rest), rest[:3])
