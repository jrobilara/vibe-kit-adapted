#!/bin/bash
# Recolector mecánico de git para /estado y encargos (Misión 4 — Diseño A y C).
# Devuelve un objeto JSON en stdout con claves fijas:
#   rama, ultimo_commit, commits_recientes, pendientes_de_push, arbol_limpio, archivos_modificados
set -u

python3 -c '
import json, subprocess

def run(*args):
    r = subprocess.run(["git", *args], capture_output=True, text=True, encoding="utf-8", errors="replace")
    return r.returncode, r.stdout.strip()

_, rama = run("rev-parse", "--abbrev-ref", "HEAD")
rama = rama or "HEAD"

_, log_raw = run("log", "-10", "--format=%h\t%cI\t%s")
commits = []
for line in log_raw.splitlines():
    if not line.strip():
        continue
    parts = line.split("\t", 2)
    if len(parts) == 3:
        commits.append({"sha": parts[0], "fecha": parts[1], "mensaje": parts[2]})

ultimo = commits[0] if commits else None

pendientes = 0
rc, up = run("rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}")
if rc == 0 and up:
    rc2, cnt = run("rev-list", "--count", f"{up}..HEAD")
    if rc2 == 0 and cnt.isdigit():
        pendientes = int(cnt)
else:
    for rem in (f"origin/{rama}", f"upstream/{rama}"):
        rc_v, _ = run("rev-parse", "--verify", rem)
        if rc_v == 0:
            rc2, cnt = run("rev-list", "--count", f"{rem}..HEAD")
            if rc2 == 0 and cnt.isdigit():
                pendientes = int(cnt)
                break

_, st_raw = run("status", "--porcelain")
modificados = [l.strip() for l in st_raw.splitlines() if l.strip()]

out = {
    "rama": rama,
    "ultimo_commit": ultimo,
    "commits_recientes": commits,
    "pendientes_de_push": pendientes,
    "arbol_limpio": len(modificados) == 0,
    "archivos_modificados": modificados,
}
print(json.dumps(out, ensure_ascii=False, indent=2))
'
