#!/bin/bash
# kit/skills/ ↔ ~/.gemini/config/skills/ — compara (default) o sincroniza las 5 skills canónicas.
#   bash .agents/scripts/kit-sync.sh          → diff (lo usa /inicio y doctor)
#   bash .agents/scripts/kit-sync.sh sync     → copia kit/ → ~/.gemini/config/skills/ y después diff (lo usa /cierre)
# La línea "Carpeta de proyectos de esta máquina" del Arquitecto es de cada PC (ADR-023):
# el diff la ignora y el sync la conserva. Sale con 1 si algo no da limpio.
set -u
P="$(cd "$(dirname "$0")/../.." && pwd)"
H="$HOME/.gemini/config"
SKILLS="skills/arquitecto skills/arquitecto-skills skills/docs-personales skills/redteam-spec skills/relevamiento"
LINEA='^\*\*Carpeta de proyectos de esta máquina\*\*'
ARQ="$H/skills/arquitecto/SKILL.md"

if [ "${1:-diff}" = sync ]; then
  # la ruta de esta PC = lo que está entre los primeros `...` de la línea instalada (si no es el lugar vacío)
  ruta=$(grep -m1 "$LINEA" "$ARQ" 2>/dev/null | cut -d'`' -f2)
  [ "$ruta" = "{{CARPETA_DE_PROYECTOS}}" ] && ruta=""
  for r in $SKILLS; do rm -rf "$H/$r"; mkdir -p "$H/$r"; cp -r "$P/kit/$r/." "$H/$r/"; done
  if [ -n "$ruta" ]; then
    # mete la ruta en el primer {{CARPETA_DE_PROYECTOS}} de esa línea (sin regex: la ruta puede traer barras o &)
    R="$ruta" awk 'BEGIN { r = ENVIRON["R"] } index($0, "**Carpeta de proyectos de esta máquina**") == 1 {
        t = "{{CARPETA_DE_PROYECTOS}}"; i = index($0, t)
        if (i) $0 = substr($0, 1, i - 1) r substr($0, i + length(t)) }
      {print}' "$ARQ" > "$ARQ.tmp" && mv "$ARQ.tmp" "$ARQ"
    echo "sync hecho — carpeta de proyectos de esta PC conservada: $ruta"
  else
    echo "sync hecho — ⚠️ esta PC no tenía carpeta de proyectos: completá la línea en $ARQ"
  fi
fi

sucio=0
for r in $SKILLS; do
  if out=$(diff -r --strip-trailing-cr -I "$LINEA" "$P/kit/$r" "$H/$r" 2>&1); then
    echo "✓ $r"
  else
    echo "✗ $r"; echo "$out"; sucio=1
  fi
done
[ "$(grep -m1 "$LINEA" "$ARQ" 2>/dev/null | cut -d'`' -f2)" = "{{CARPETA_DE_PROYECTOS}}" ] && { echo "⚠️ la carpeta de proyectos de esta PC está sin completar ($ARQ)"; sucio=1; }
[ $sucio = 0 ] && echo "kit ↔ ~/.gemini/config: LIMPIO" || echo "kit ↔ ~/.gemini/config: SUCIO — frenar y mirar antes de pisar nada"
exit $sucio
