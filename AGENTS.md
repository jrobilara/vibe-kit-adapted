# AGENTS.md — Reglas para Antigravity en vibe-kit (el proyecto madre)

> Solo reglas de comportamiento. El método vive en PLAYBOOK-MAESTRO.md; el estado en docs/.
> Test por línea: **si borro esta línea, ¿Antigravity se equivoca? Si no, sobra.**

## Qué es esto

**vibe-kit**: el repo del método de vibe coding adaptado para Antigravity (Gemini) por Juan sobre la
base original de Guido (`guidocameraeq/vibe-kit`) — el playbook, el kit instalable (Arquitecto +
Equipador + templates + `/estado`), el observatorio (Extractor de tips e investigación de chats) y los
informes de tandas. Acá se MANTIENE el método; las apps se construyen en sus propios proyectos.

**Comandos clave** (desde la raíz):
- `powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1` (o `bash .agents/scripts/kit-sync.sh`) — compara `kit/` ↔ `~/.gemini/config/skills/` (primer paso ante cualquier duda del kit)
- `powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1 sync` — sincroniza y verifica conservando la carpeta de proyectos de esta PC (lo usa `/cierre`)
- `powershell -ExecutionPolicy Bypass -File .agents/scripts/estado-git.ps1` — datos mecánicos de git en JSON (lo usa `/estado`)

## El ciclo de trabajo

1. **Chat nuevo por misión.** La regla `.agents/rules/inicio-sesion.md` (`trigger: always_on`) ordena leer `docs/SESSION_HANDOFF.md`, las primeras 40 líneas de `docs/TODO.md` y el estado git al abrir; `/inicio` lo cruza con la realidad (git, diff `kit-sync`, tandas sin procesar) y confirma en 3 líneas. No toco nada hasta el OK.
2. Trabajar con las reglas de abajo. Para saber cómo vamos en cualquier momento: `/estado`.
3. `/cierre` al terminar → `kit-sync sync` + docs + commit + push → **el chat se descarta**.

## 🚨 Restricciones duras y frenos (Diseño A — Misión 4)

1. **`kit/` es LA fuente canónica.** Cambios al Arquitecto/Equipador/skills del kit: editar en `kit/`
   (conservando siempre `{{CARPETA_DE_PROYECTOS}}` en `kit/skills/arquitecto/SKILL.md`) → sincronizar y
   verificar con `.agents/scripts/kit-sync.ps1 sync` → commit+push. **NUNCA editar
   `~/.gemini/config/skills/` directo** (queda huérfano del historial). El script debe dar `LIMPIO` al
   cerrar toda sesión; la carpeta de proyectos de cada PC la conserva él, no se toca a mano.
2. **Las 4 únicas preguntas al humano (Diseño A):** durante una misión aprobada opero en silencio por
   defecto y resuelvo solo, salvo para preguntar únicamente por estas 4 cosas (más decisiones de diseño o
   negocio):
   - **(a) borrar datos reales**;
   - **(b) tocar plata** (pagos, facturación, cuotas pagas);
   - **(c) manejar claves o secretos**;
   - **(d) mandar algo hacia afuera a nombre de Juan** (mails, mensajes a clientes, push a un remoto ajeno como `upstream`).
3. **Corrector contra git destructivo:** prohibido correr `git reset --hard`, `git clean -f`, `git stash`
   o `git checkout -- .` / `git restore .` sobre todo el árbol para "limpiar". **Alternativa obligatoria:**
   hacer un commit temporal (`wip: ...`) o una rama de respaldo antes de descartar nada.
4. **Nada entra al menú del Equipador sin curaduría** (verificar contra fuente oficial), y todo descarte
   se escribe CON razón. Nada se instala "por las dudas" (regla de 3+).
5. **Los informes de `tips/` y `docs/mision-4/` son actas**: no se editan retroactivamente (salvo marcar
   checkboxes de propuestas aplicadas).
6. **El observatorio (`observatorio/`: el Extractor y la investigación) jamás toca el sistema** —
   extrae y propone; la sesión madre (acá, en la raíz) decide y aplica. No mezclar los roles.
7. Los cambios al playbook/kit que nacen de fricción real citan su evidencia (fecha, tanda, o proyecto
   donde dolió) — este repo funciona con "cada regla lleva su cicatriz".

## Reglas de evidencia y delegación

Las estándar del método (soy su fabricante — dar el ejemplo): evidencia real o **NO VERIFICADO** ·
tareas >2 min en background · tras compactar (`/compact`) o reiniciar contexto, releer antes de editar ·
root cause, no parches · specs en formato SPEC-0/delta · ofrecer cristalizar spec si la charla diseñó
algo no-trivial · **encargos a subagentes siempre por referencia** (`SPEC` + `archivo:línea` + salida de
`estado-git.ps1`), nunca parafraseados.

## Mapa de documentación

| Archivo | Rol | Regla |
|---|---|---|
| `README.md` | Portada para quien llega de afuera: qué es, para quién, carpetas, instalar, atribución MIT a Guido | 100% portada: sin pendientes, historial ni número de versión (ADR-023, playbook §1) |
| `docs/MISION-Y-VISION.md` | Para qué existe el repo, para quién, qué NO hace | ~1 pantalla; se toca solo si cambia el rumbo |
| `docs/TODO.md` | **ÚNICA fuente de pendientes** | REJ-005 reabierto (ADR-023). La regla `inicio-sesion` lee sus primeras 40 líneas: lo urgente va arriba |
| `docs/CHANGELOG.md` | Historia: una entrada por sesión, con el tag si lo hubo | `/cierre` la agrega al tope |
| `docs/README.md` | El índice de `docs/` | Archivo nuevo en `docs/` → una fila acá |
| `GUIA-DE-USO.md` | La puerta: recetas por situación para Juan | Anti-espejo: frases y punteros, jamás duplicar procedimientos |
| `manuales/` | El detalle a fondo de cada pieza del kit | La guía apunta acá; acá no se repite la guía |
| `docs/SESSION_HANDOFF.md` | Save game — dónde quedamos | `/cierre` lo sobreescribe entero; `inicio-sesion` lo lee al abrir |
| `docs/DECISIONS.md` | Por qué el kit es como es (ADRs, con índice al tope) | Decisión con alternativas → ADR nuevo, correlativo |
| `docs/SPEC-*.md` | Los planos de lo que se construyó | **Al implementarse NO se archivan**: se marcan `✅ IMPLEMENTADO <fecha>` en la línea de Estado y se quedan en `docs/`, porque sus criterios y su Fase 2 se siguen consultando. Lo que SÍ va a `legacy/` con lápida es el material **consumido** (relatos de uso, prompts de arranque). *Esto se aparta del `formato-spec.md` del kit, que manda archivar — allá el spec es de una feature de app; acá es del método mismo y sigue vivo.* |
| `docs/PORTABILIDAD-ANTIGRAVITY.md` | Qué se cambió para que el kit corra en Antigravity v2 (Misiones 1-4, subagentes, comandos, remotos) | Se actualiza si cambia algo de la portabilidad; antes de "arreglar" algo heredado de Claude Code, leerlo |
| `docs/REJECTED.md` | Lo descartado a nivel proyecto | Sin él, un chat futuro re-propone el plugin o el web wizard |
| `docs/consulta/` | Referencia que no cambia con el trabajo diario (`referencia-prompts-personales.md`, `EVALUACION-docs-personales-v2.md`) | Cubierto 100% por licencia MIT |
| `docs/mision-4/` | Investigación y diseños de la Misión 4 (radiografía, flota, Diseño A frenos, Diseño C `/estado`, referencias externas) | Actas de diseño: no se reescriben retroactivamente |
| `PLAYBOOK-MAESTRO.md` | EL método (multi-proyecto) | Se toca solo con evidencia nueva |
| `kit/skills/arquitecto-skills/menu-skills.md` | El menú curado + sus descartes de skills | Descartes de SKILLS van acá, no en REJECTED |
| `kit/skills/relevamiento/plantillas/_fuente/` | Las 4 plantillas originales del método "Cómo Arrancar un Proyecto" (creadas por Guido y aprobadas por su jefe) | **Prístinas: NUNCA se editan**, ni un typo. Solo se pisan con una versión nueva aprobada; `git diff _fuente/` muestra el cambio, limpio. Ritual: `plantillas/SYNC.md`. Los `{{LINEAS:N}}` NO son placeholders del kit |
| `tips/tanda-*.md` | Actas del observatorio (tips y chats) | Actas: no se reescriben. Las rutas viejas que citan se leen con la tabla del ADR-023 |
| `observatorio/` | Extractor + investigación: miran y proponen | Un observador nuevo = subcarpeta acá, con el mismo contrato |
| `LICENSE` · `NOTICE` | MIT pura · aviso de atribución al repo original de Guido (`guidocameraeq/vibe-kit`) | Todo el repo está bajo licencia MIT |
| `assets/` | El banner y los diagramas (SVG, estilo plano) | Se miran renderizados antes de publicar |
| `legacy/` | Todo lo superado, con lápida | Se archiva, no se borra |

## Comunicación

Español rioplatense (vos), directo y corto. **Juan es programador junior**: maneja Kotlin, Jetpack
Compose y Java; Next.js/web (creación y deploy) lo está aprendiendo — ahí explicar el *por qué* de
cada paso en 1-2 líneas. Se puede usar jerga técnica estándar sin traducirla; términos de stacks que
no maneja (web, infra, DB) se definen la primera vez. Decisiones: opciones con pros/contras + UNA
recomendación. Explicar QUÉ cambié, no narrar el proceso.
