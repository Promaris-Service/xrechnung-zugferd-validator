#!/usr/bin/env python3
"""Schematron vorverarbeiten: <include> einbetten, abstrakte Muster (is-a/param) textlich instanziieren (ISO 19757-3 §6.5)."""
import re, sys, os
src = sys.argv[1]; dst = sys.argv[2]
base = os.path.dirname(src)
s = open(src, encoding='utf-8').read()
def inline(m):
    t = open(os.path.join(base, m.group(1)), encoding='utf-8').read()
    return re.sub(r'<\?xml[^>]*\?>', '', t)
s = re.sub(r'<include\s+href="([^"]+)"\s*/>', inline, s)
def attrs(tag): return dict(re.findall(r'([\w:-]+)="([^"]*)"', tag))
abstracts = {}
def grab(m):
    a = attrs(m.group(1))
    if a.get('abstract') == 'true':
        abstracts[a['id']] = m.group(2); return ''
    return m.group(0)
s = re.sub(r'<pattern([^>]*)>(.*?)</pattern>', grab, s, flags=re.S)
def expand(m):
    a = attrs(m.group(1)); body = m.group(2)
    if 'is-a' not in a: return m.group(0)
    params = dict(re.findall(r'<param\s+name="([^"]+)"\s+value="([^"]*)"\s*/>', body))
    t = abstracts[a['is-a']]
    for name in sorted(params, key=len, reverse=True):
        t = re.sub(r'\$' + re.escape(name) + r'(?![\w-])', lambda _: params[name], t)
    return f'<pattern id="{a.get("id", "")}">{t}</pattern>'
s = re.sub(r'<pattern([^>]*)>(.*?)</pattern>', expand, s, flags=re.S)
open(dst, 'w', encoding='utf-8').write(s)
print(dst, len(s), "asserts", s.count('<assert'), "abstrakt", list(abstracts))
