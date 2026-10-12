#!/usr/bin/env python3
"""Erzeugt crates/core/src/artefakte/tabelle.rs aus dem Inhalt von crates/core/artefakte/.
Aufruf aus crates/core/: python3 scripts/artefakte-tabelle.py"""
import os
root='artefakte'
def liste(tool):
    out=[]
    for dp,_,fs in os.walk(os.path.join(root,tool)):
        for f in sorted(fs):
            if f.endswith(('.xsl','.xslt','.xsd','.xml','.sch')):
                out.append(os.path.relpath(os.path.join(dp,f),root).replace(os.sep,'/'))
    return sorted(out)
def block(name,tool):
    s=f"pub static {name}: &[Datei] = &[\n"
    for rel in liste(tool):
        s+=f'    Datei {{ pfad: "{rel}", text: include_str!("../../artefakte/{rel}") }},\n'
    return s+"];\n"
src='''//! Tabelle der eingebetteten Artefakte — GENERIERT von scripts/artefakte-tabelle.py, nicht von Hand aendern.
//! Siehe tabelle.md.

use super::Datei;

'''+block('KOSIT','kosit')+"\n"+block('MUSTANG','mustang')
open('src/artefakte/tabelle.rs','w').write(src)
