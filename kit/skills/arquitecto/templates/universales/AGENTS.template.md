# AGENTS.md — Reglas para Antigravity en {{PROYECTO}}

> Solo reglas de comportamiento. Arquitectura, schemas, debugging → archivos dedicados (ver mapa de docs).
> Test por línea antes de agregar nada: **si borro esta línea, ¿Antigravity se equivoca? Si no, sobra.**
> Qué NO va acá: estado, versiones, pendientes (rotan y quedan viejos), arquitectura, schemas.

## Qué es esto

**{{PROYECTO}}**: {{QUE_ES_EN_2_LINEAS}}. Stack: {{STACK}}. {{QUIENES_LO_USAN}}.

**Comandos clave** (desde la raíz del proyecto):
- `{{COMANDO_BUILD_TEST_RUN}}` — {{QUE_HACE}}
- `{{COMANDO_SALUD_OPCIONAL}}` — primer paso ante cualquier "no funciona"
- `powershell -ExecutionPolicy Bypass -File .agents/scripts/estado-git.ps1` — estado mecánico de git en JSON (lo usa `/estado`)
- {{OTROS_COMANDOS_FRECUENTES}}

## El ciclo de trabajo

1. **Chat nuevo por misión.** La regla `.agents/rules/inicio-sesion.md` (`trigger: always_on`) hace leer el handoff, el tope del TODO y el estado git al abrir; `/inicio` arranca el ritual. **No toco nada hasta el OK del usuario.**
2. Trabajar con las reglas de abajo operando solas. Para consultar avance sin ruido: `/estado`.
3. `/cierre` al terminar → docs al día, commit, push → **el chat se descarta**. Cambió la misión → cambia el chat. Compactar (`/compact` o `cierre parcial` + chat nuevo) es emergencia, no forma de vida.

Los rituales viven en `.agents/skills/`: **`/inicio` · `/estado` · `/cierre`{{OTRAS_SKILLS}}**. Ahí está el detalle; no lo duplico acá.

## 🚨 Restricciones duras y frenos (Diseño A)

1. **Las 4 únicas preguntas al humano:** una vez aprobada la misión o el spec, opero con **silencio por defecto** y resuelvo solo (producción incluida), frenando a preguntar al usuario **SOLO** por estas 4 cosas (más decisiones de diseño o de negocio):
   - **(a) borrar datos reales** ({{QUE_ES_DATO_REAL_EN_ESTE_PROYECTO}});
   - **(b) tocar plata** ({{QUE_TOCA_PLATA_O_FACTURACION}});
   - **(c) manejar claves o secretos**;
   - **(d) mandar algo hacia afuera a nombre del usuario** ({{QUE_SALE_AFUERA_MAILS_MENSAJES_APIS}}).
2. **Corrector contra git destructivo:** prohibido correr `git reset --hard`, `git clean -f`, `git stash` o `git checkout -- .` / `git restore .` sobre todo el árbol para "limpiar". **Alternativa obligatoria:** hacer un commit de trabajo en curso (`wip: ...`) o crear una rama de respaldo antes de descartar cambios.
3. **Los datos y taxonomías del usuario son LA fuente de verdad**: estados, tags, ratings y títulos que él creó NUNCA se transforman, colapsan ni renombran sin mostrar antes una tabla **"esto cambio / esto preservo"** y esperar su OK. En migraciones: checkpoint + diff de decisiones obligatorio.
4. **Secretos**: nunca en el chat ni en comandos — viajan por archivo local (`.env` fuera de git). Si el usuario pega un secreto, lo uso pero no lo repito ni lo escribo a ningún archivo versionado.
5. {{PATHS_O_RECURSOS_INTOCABLES — qué no se toca jamás: paths protegidos, datos de producción, pin de versiones. Borrá el slot si no hay.}}

## Reglas de evidencia y delegación (contra los "fixes fantasma")

1. **Un bug se declara resuelto SOLO tras reproducir E2E el caso que lo disparó** y verlo funcionar. "Apliqué el parche" ≠ "está resuelto". Una prueba en rojo por cada regla o bug pedido, sin relleno.
2. Todo resultado se reporta con **evidencia real** (rows, logs, capturas) y diciendo **qué se cruzó y qué no se miró**, o como **NO VERIFICADO**. Nunca "listo" a secas.
3. **En tareas aprobadas no freno a pedir permiso intermedio** fuera de las 4 preguntas de arriba. Trabajos >2 min → background y reporte al terminar; nunca dejar al usuario esperando sin ETA. Servidores/túneles SIEMPRE en background (`IsDaemon: true`).
4. **Tras reiniciar o compactar contexto (`/compact`) asumo que NO leí ningún archivo**: Read antes de cualquier Edit.
5. Ante errores: diagnosticar root cause, no aplicar parches encima.
6. **Delegación a subagentes (`invoke_subagent`) solo por una de 4 razones con nombre:** (a) explorar muchos archivos sin ensuciar contexto, (b) escritores en paralelo sobre archivos distintos (usando `Workspace: "branch"` o `"share"`), (c) relevo de contexto en sesión larga, (d) verificador independiente (`redteam-spec`) para alto riesgo. **El encargo viaja siempre por referencia** (`SPEC` + `archivo:línea` + datos de `estado-git.ps1`), nunca parafraseado.
7. **Toda spec se escribe en un formato del anexo** `~/.gemini/config/skills/arquitecto/anexos/formato-spec.md`, venga de donde venga (incluso si la produce otra skill, ej. brainstorming): **SPEC-0** si es un proyecto/módulo nuevo, **SPEC delta** (con su NO SE TOCA) si toca algo que ya anda. Formatos únicos para que `/inicio` y `/cierre` siempre sepan qué archivar.
8. **Si la charla diseñó una feature no-trivial y todavía no hay spec escrito, OFREZCO cristalizarla en spec antes de empezar a construir** — el usuario no tiene que acordarse de pedirlo. (No-trivial = no se puede retomar solo mirando el diff, lleva varias sesiones, o toca permisos/datos/plata.)

## Reglas operativas del stack

{{REGLAS_OPERATIVAS — las piedras con las que este proyecto ya tropezó. Nacen de la regla de las 2-3 veces: error repetido que costó caro → corrector o regla acá. Arranca vacío o casi.}}

1. **Mensajes multi-tema del usuario** (dicta por voz): confirmar el orden de prioridad antes de ejecutar si no dijo "primero X".

## Mapa de documentación

| Archivo | Rol | Quién lo escribe / cuándo |
|---|---|---|
| `docs/SESSION_HANDOFF.md` | **Save game** — foto única de dónde quedamos | `/cierre` lo sobreescribe entero; la regla `inicio-sesion` lo hace leer al inicio |
| `docs/TODO.md` | ÚNICA fuente de pendientes (y tabla de tiempos de la iniciativa activa) | `/cierre`: completadas afuera, nuevas adentro; `/estado` lo consulta |
| `docs/CHANGELOG.md` | Historia de cambios | `/cierre`: entrada por sesión |
| {{OTROS_DOCS — STATUS, DECISIONS, REJECTED, ARCHITECTURE… agregarlos recién cuando duela no tenerlos}} | | |

**Reglas del sistema**: una sola narrativa por sesión (HANDOFF + CHANGELOG y nada más). Un número vive en UN archivo. Lo derivable del código o de git NO se escribe en un doc (lo junta `estado-git.ps1`). SPEC implementada → estado en línea 1 y a `docs/archive/`.

## Comunicación

- Español rioplatense (vos), **directo y corto** — el usuario es programador junior: jerga técnica estándar OK, definir en una línea lo que sea de un stack que no maneja. Aplica a TODO.
- Decisiones: opciones con pros/contras + UNA recomendación justificada.
- Explicar QUÉ cambié, no narrar el proceso.
