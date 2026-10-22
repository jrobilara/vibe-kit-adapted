# SPEC: Adaptación y Refactor v2 para Antigravity (Gemini) — vibe-kit
Adaptar la versión evolucionada de `vibe-kit` (Misiones 3 y 4 de Guido) al ecosistema Antigravity / Gemini (`AGENTS.md`, `.agents/`, `~/.gemini/config/`), conservando la atribución a Guido y sumando soporte propio de instalación, sincronización y auto-actualización desde el repo de Juan.
- Estado: READY
- Fecha: 2026-10-21

## Por qué (el dolor)
Juan tiene en el Escritorio una adaptación anterior (`vibe-kit-main`, del 10/10/2026) que llevó el kit a Antigravity (`AGENTS.md`, `docs-personales`, `redteam-spec` como skill, rutas `~/.gemini/config/skills/`). Sin embargo, el repositorio original de Guido (`vibe-kit`, actualizado al 21/10/2026) evolucionó muchísimo con la Misión 3 (portada pública, licencia MIT, `observatorio/`, `manuales/`, `docs/TODO.md`, `docs/CHANGELOG.md`, `docs/MISION-Y-VISION.md`, script `kit-sync.sh`) y la Misión 4 (radiografía Director/Obrero, inventario de flota, referencias externas `gentle-ai`/`agency-agents`/`MetaGPT`, Diseño A de frenos/correctores y Diseño C de `/estado`). Hace falta hacer un refactor a conciencia sobre esta versión nueva: decidir qué archivos conservar, adaptar o descartar, traducir la comunicación multiagente y frenos a la infraestructura nativa de Antigravity, y dejar andando el circuito de instalación y auto-actualización contra un repositorio propio de Juan en GitHub.

## Contexto del código (de la exploración — nombres REALES)
- **Repo actual (`C:\Users\Usuario\Desktop\vibe kit v2\vibe-kit` — versión Guido 2026-10-21)**:
  - Raíz: `CLAUDE.md`, `README.md` (portada con `assets/banner.svg` y `assets/flujo.svg`), `GUIA-DE-USO.md`, `PLAYBOOK-MAESTRO.md`, `LICENSE` (MIT de `guidocameraeq`) y `NOTICE` (exclusión de `referencia-prompts-fyd.md`).
  - Configuración local Claude: `.claude/settings.json`, `.claude/hooks/session-start.sh`, `.claude/scripts/kit-sync.sh` (compara y sincroniza `kit/` ↔ `~/.claude/` preservando `**Carpeta de proyectos de esta máquina**`), `.claude/skills/inicio/SKILL.md`, `.claude/skills/cierre/SKILL.md`.
  - `kit/` (fuente canónica):
    - `kit/INSTALAR.md`
    - `kit/agents/redteam-spec.md`
    - `kit/skills/arquitecto/` (`SKILL.md`, `anexos/`, `templates/universales/CLAUDE.template.md`, `settings.template.json`, `hooks/check-code.js`, `hooks/session-start.sh`, `skills/inicio`, `skills/cierre`, `docs/`)
    - `kit/skills/arquitecto-skills/` (`SKILL.md`, `menu-skills.md` — apunta a `guidocameraeq/vibe-kit`)
    - `kit/skills/docs-fyd/` (`SKILL.md`, `deteccion.md`, `prompts-fyd.md`, `plantillas/`)
    - `kit/skills/relevamiento/` (`SKILL.md`, `anexos/`, `plantillas/` + `_fuente/`)
  - `manuales/`: `COMO-USAR-EL-ARQUITECTO.md`, `HOJA-DE-MANO-relevamiento.md`.
  - `observatorio/`: `README.md`, `extractor/` (`CLAUDE.md`, `COMO-USAR-EL-EXTRACTOR.md`, `transcribe-vps.sh`) e `investigacion/` (`METODO.md`, `LECTOR.md`, `costos.md`, scripts Python `condensar.py`, `costos.py`, `flota.py`, `huella.py`, `repos.py`).
  - `docs/`: `MISION-Y-VISION.md`, `TODO.md`, `CHANGELOG.md`, `DECISIONS.md` (23 ADRs), `REJECTED.md`, `SESSION_HANDOFF.md`, `README.md`, `SPEC-docs-fyd.md`, `SPEC-docs-fyd-v2.md`, `SPEC-investigacion-chats.md`, `SPEC-profesionalizar-repo.md`, `SPEC-relevamiento.md`, `consulta/` (`EVALUACION-docs-fyd-v2.md`, `referencia-prompts-fyd.md`) y `mision-4/` (`PLAN.md`, `TABLERO.md`, `FLOTA.md`, `REPOS.md`, `PLATAFORMA.md`, `RADIOGRAFIA-director-obrero.md`, `REFERENCIAS-EXTERNAS.md`, `DISENO-A-frenos.md`, `DISENO-C-salida-hacia-Guido.md`).
  - `tips/` y `legacy/`.
- **Repo anterior adaptado (`C:\Users\Usuario\Desktop\vibe-kit-main` — versión Juan 2026-10-10)**:
  - Portabilidad base documentada en `docs/PORTABILIDAD-ANTIGRAVITY.md`: `CLAUDE.md` → `AGENTS.md`, `.claude/` → `.agents/`, `~/.claude/skills/` → `~/.gemini/config/skills/`, `redteam-spec` como skill, y `docs-fyd` → `docs-personales` (incluyendo `docs/SPEC-docs-personales.md` y `docs/SPEC-docs-personales-v2.md`).

## AGREGA (lo nuevo)
- **Configuración Antigravity del repo madre (`.agents/` y `AGENTS.md`)**:
  - `AGENTS.md` en la raíz (con la tabla completa de `docs/TODO.md`, `docs/CHANGELOG.md`, `docs/MISION-Y-VISION.md`, `observatorio/`, `manuales/` de la Misión 3 + el perfil de Juan: Kotlin/Compose/Java y Next.js/web en aprendizaje) y `observatorio/extractor/AGENTS.md`.
  - `.agents/rules/inicio-sesion.md` (`trigger: always_on`): ordena leer `docs/SESSION_HANDOFF.md`, las primeras 40 líneas de `docs/TODO.md` y el estado git al abrir cada conversación.
  - `.agents/skills/inicio/SKILL.md` y `.agents/skills/cierre/SKILL.md` adaptadas para Antigravity y conectadas con `kit-sync`.
  - `.agents/scripts/kit-sync.ps1` (PowerShell nativo para Windows) y `.agents/scripts/kit-sync.sh` (Bash): comparan y sincronizan las 5 skills canónicas (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) entre `kit/skills/` y `~/.gemini/config/skills/`, preservando intacta la línea `**Carpeta de proyectos de esta máquina**`.
- **Nueva skill `/estado` y script recolector de git (Misión 4 — Diseño C)**:
  - `.agents/skills/estado/SKILL.md` (en el repo madre) y `kit/skills/arquitecto/templates/universales/skills/estado/SKILL.md` (en el molde para todos los proyectos nuevos).
  - Scripts recolectores mecánicos `.agents/scripts/estado-git.ps1` + `.agents/scripts/estado-git.sh` y sus equivalentes en `kit/skills/arquitecto/templates/universales/scripts/estado-git.ps1` + `estado-git.sh`: devuelven un objeto JSON con claves fijas (`rama`, `ultimo_commit`, `commits_recientes`, `pendientes_de_push`, `arbol_limpio`, `archivos_modificados`). No ejecutan suites de tests pesadas ni asumen fichas de subproyecto (Racimo H aún no diseñado); la tabla de tiempos y estimación la mantiene el director en la sección de estado de la iniciativa o `TODO.md` apoyándose en los timestamps reales de `commits_recientes`.
- **Skills adaptadas del kit (`kit/skills/`) y templates universales**:
  - `kit/skills/docs-personales/` (portada desde `vibe-kit-main`, reemplazando a `kit/skills/docs-fyd/`).
  - `kit/skills/redteam-spec/SKILL.md` (reemplazando a `kit/agents/redteam-spec.md`).
  - `kit/skills/arquitecto/templates/universales/AGENTS.template.md` y `rules/inicio-sesion.md` (incorporando de fábrica las **4 únicas preguntas al humano** de `DISENO-A-frenos.md`: borrar datos reales, tocar plata, manejar claves, mandar algo afuera a nombre del usuario; y el corrector contra git destructivo `reset --hard`, `clean -f`, `stash`).
- **Documentación de portabilidad, specs y consulta (`docs/`)**:
  - `docs/PORTABILIDAD-ANTIGRAVITY.md` v2: documenta equivalencias de plataforma (Misiones 1-4), subagentes con `Workspace: "branch" | "share"`, Reactive Wakeup, slash commands reales de Antigravity (`/compact`, `/plan`, `/goal`, `/schedule`, `/grill-me`, `/teamwork-preview`, `/boost`, `/learn`), y el esquema de dos remotos (`origin` de Juan / `upstream` de Guido).
  - `docs/SPEC-docs-personales.md`, `docs/SPEC-docs-personales-v2.md`, `docs/consulta/referencia-prompts-personales.md` y `docs/consulta/EVALUACION-docs-personales-v2.md` (portados de `vibe-kit-main`, reemplazando todos los archivos equivalentes de `docs-fyd`).

## MODIFICA (lo existente que se toca)
- **Eliminación de carpetas y archivos exclusivos de Claude Code y de FyD Sistemas**:
  - Se eliminan `.claude/`, `CLAUDE.md`, `observatorio/extractor/CLAUDE.md`, `kit/agents/redteam-spec.md`, `kit/skills/docs-fyd/`, `docs/SPEC-docs-fyd.md`, `docs/SPEC-docs-fyd-v2.md`, `docs/consulta/referencia-prompts-fyd.md`, `docs/consulta/EVALUACION-docs-fyd-v2.md`, y de los templates del Arquitecto se eliminan `CLAUDE.template.md`, `settings.template.json`, `hooks/check-code.js` y `hooks/session-start.sh`. Efecto colateral a cuidar: actualizar todas las filas y referencias en `README.md`, `docs/README.md`, `GUIA-DE-USO.md` y `manuales/`.
- **`kit/INSTALAR.md`**:
  - Se adapta a Antigravity tomando la base de `vibe-kit-main/kit/INSTALAR.md` (`~/.gemini/config/skills/`, las 5 skills incluidas `docs-personales` y `redteam-spec`, y reemplazo de `{{CARPETA_DE_PROYECTOS}}`). Efecto colateral a cuidar: conservar el placeholder `{{CARPETA_DE_PROYECTOS}}` en `kit/skills/arquitecto/SKILL.md` para que el instalador y `kit-sync` funcionen igual que en Misión 3.
- **`kit/skills/arquitecto/SKILL.md`, `anexos/` y `templates/`**:
  - En `kit/skills/arquitecto/SKILL.md`: se adapta a Antigravity (`AGENTS.md`, `.agents/`, `ask_question` con `is_multi_select`, modo Planning con `implementation_plan.md` + `RequestFeedback`, `docs-personales`), **conservando literalmente `{{CARPETA_DE_PROYECTOS}}` en la línea 20 del archivo en `kit/`** (nunca hardcodear `E:/Proyectos/AI Projects` dentro de `kit/`).
  - En `kit/skills/arquitecto/anexos/` (`consultorio.md`, `formato-spec.md`, `banco-de-preguntas.md`, `concerns.md`, `matriz-stacks.md`): se actualiza `consultorio.md` con la orquestación multiagente nativa de Antigravity (`invoke_subagent` con `Workspace: "inherit" | "branch" | "share"`, `send_message`, `manage_subagents`, Reactive Wakeup automático sin polling), las **4 razones con nombre para delegar** y el **encargo por referencia** (`SPEC` + `archivo:línea`, nunca parafraseado) de Misión 4 (`DISENO-A` / `REFERENCIAS-EXTERNAS`).
  - En `kit/skills/arquitecto/templates/`: se adaptan a Antigravity `LEEME.md`, `universales/skills/inicio/SKILL.md`, `universales/skills/cierre/SKILL.md`, `adaptables/smoke.contrato.md` y `adaptables/deploy.contrato.md` (sin referencias a `SessionStart`, `.claude/`, `docs-fyd` ni memoria de Claude; en `cierre/SKILL.md` se aclara que para sesiones largas existe `/compact` nativo en Antigravity pero se sigue prefiriendo `cierre parcial` + chat nuevo para mantener contexto limpio). En el Paso 5 (Montaje) y en `templates/LEEME.md` se incluye el montaje de `.agents/skills/estado/SKILL.md` y `.agents/scripts/estado-git.*`.
- **`kit/skills/arquitecto-skills/SKILL.md` y `menu-skills.md`**:
  - Rutas apuntando a `~/.gemini/config/skills/`.
  - **Modo AUTO-ACTUALIZAR EL KIT**: clona desde el repo de GitHub de Juan (`origin`, configurable o definido en la skill) manteniendo `upstream` (`guidocameraeq/vibe-kit`) documentado para sincronizar mejoras del método madre.
  - **Nuevo Modo DOCTOR** (de `REFERENCIAS-EXTERNAS.md` §1 / Racimo E): diagnóstico de solo lectura que verifica `~/.gemini/config/skills/`, versión de herramientas (`node`, `git`, `bash`), identidad git, línea de carpeta de proyectos y ejecuta `kit-sync` en modo `diff` sin tocar ningún archivo.
  - `menu-skills.md`: suma `android-cli` (para el stack Kotlin/Android de Juan), cambia `docs-fyd` → `docs-personales`, y actualiza la lista de capacidades y comandos nativos de Antigravity.
- **`kit/skills/relevamiento/` y `manuales/` (`COMO-USAR-EL-ARQUITECTO.md`, `HOJA-DE-MANO-relevamiento.md`)**:
  - Adaptación a Antigravity (`ask_question`, `~/.gemini/config/skills/`, `AGENTS.md`), manteniendo la corrección de autoría de plantillas de la Misión 3 (creadas por Guido, adaptadas para el flujo de Juan en Antigravity).
- **`observatorio/` (`extractor/` e `investigacion/`)**:
  - `observatorio/extractor/CLAUDE.md` → `observatorio/extractor/AGENTS.md` y ajuste de `COMO-USAR-EL-EXTRACTOR.md`.
  - En `observatorio/investigacion/`: ajuste en `repos.py` y `flota.py` para detectar tanto `AGENTS.md`/`.agents/` como `CLAUDE.md`/`.claude/`; en `huella.py` actualización de las constantes `UNIVERSALES = {"inicio", "cierre", "estado"}` y `DEL_KIT = {"arquitecto", "arquitecto-skills", "docs-personales", "redteam-spec", "relevamiento"}` (soportando `.agents/skills/` y `.claude/skills/`); y nota en `METODO.md` sobre la ubicación de los transcripts JSONL en Antigravity (`~/.gemini/antigravity/brain/<id>/.system_generated/logs/transcript.jsonl`).
- **Portada, atribución y licencia (`README.md`, `LICENSE`, `NOTICE`, `GUIA-DE-USO.md`, `PLAYBOOK-MAESTRO.md`, `docs/MISION-Y-VISION.md`, `docs/README.md`)**:
  - `README.md`, `GUIA-DE-USO.md` y `PLAYBOOK-MAESTRO.md` adaptados a Antigravity (`AGENTS.md`, `/estado`, frenos de Diseño A, subagentes con `Workspace`, comandos `/compact`, `/plan`, `/goal`, `/boost`).
  - Atribución destacada a **Guido (`guidocameraeq/vibe-kit`)** en `README.md`, `LICENSE` y `NOTICE` como autor original del método y del kit para Claude Code. Al eliminar todos los archivos `-fyd` y reemplazarlos por `-personales`, `NOTICE` pasa a ser exclusivamente el aviso de atribución al proyecto original de Guido y el repo queda 100% bajo licencia MIT.

## NO SE TOCA (obligatoria — el seguro de no romper)
- **`kit/skills/relevamiento/plantillas/_fuente/`**: las 4 plantillas base quedan **100% prístinas** (ni un byte tocado; `git diff kit/skills/relevamiento/plantillas/_fuente/` debe dar vacío).
- **Actas históricas e informes de investigación (`tips/tanda-*.md`, `docs/mision-4/*.md`, `docs/SPEC-investigacion-chats.md`, `docs/SPEC-relevamiento.md`, `docs/SPEC-profesionalizar-repo.md`, `docs/DECISIONS.md` ADRs 001..023, `docs/REJECTED.md`)**: son actas e investigaciones pasadas; no se reescriben (solo se agrega ADR-024 en `docs/DECISIONS.md` documentando el refactor v2 para Antigravity).
- **Archivo histórico (`legacy/`)**: queda intacto con sus snapshots y documentos de v1.
- **El flujo core de entrevista del Arquitecto (1 pregunta por vez con `ask_question`, borrador incremental en disco, YAGNI, gate en modo Planning antes de montar)**: intacto.

## Criterios de aceptación (3-8, verificables)
1. **Regresión (`NO SE TOCA`)**: `git diff kit/skills/relevamiento/plantillas/_fuente/`, `git diff tips/`, `git diff legacy/` y `git diff docs/mision-4/` deben dar **vacío** (0 cambios).
2. **Cero rastros operativos huérfanos de Claude Code o FyD en el kit vivo**: no deben existir `.claude/`, `CLAUDE.md`, `observatorio/extractor/CLAUDE.md`, `kit/agents/`, `kit/skills/docs-fyd/`, `docs/SPEC-docs-fyd*.md` ni `docs/consulta/*-fyd*.md`. Un grep de `~/.claude` o `docs-fyd` en `kit/`, `.agents/`, `AGENTS.md`, `README.md`, `GUIA-DE-USO.md`, `PLAYBOOK-MAESTRO.md` y `manuales/` debe dar 0 ocurrencias.
3. **Sincronización automática (`kit-sync`) verificada en camino feliz y de fallo**:
   - `kit/skills/arquitecto/SKILL.md` contiene literalmente `{{CARPETA_DE_PROYECTOS}}` en la línea `**Carpeta de proyectos de esta máquina**`.
   - Al correr `powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1 sync`, copia las 5 skills de `kit/skills/` a `~/.gemini/config/skills/`, preserva la ruta `E:/Proyectos/AI Projects` en `~/.gemini/config/skills/arquitecto/SKILL.md`, y devuelve `kit ↔ ~/.gemini/config: LIMPIO` (exit code 0).
   - Si se altera temporalmente una línea en `~/.gemini/config/skills/arquitecto-skills/SKILL.md` y se corre `powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1` (modo `diff`), devuelve `SUCIO` con exit code `1`.
4. **Mejoras de Misión 4 activas en el kit**:
   - `kit/skills/arquitecto/templates/universales/AGENTS.template.md` incluye las 4 únicas preguntas al humano y el corrector contra git destructivo (Diseño A).
   - Existen `.agents/skills/estado/SKILL.md`, `kit/skills/arquitecto/templates/universales/skills/estado/SKILL.md`, `.agents/scripts/estado-git.ps1` y `.agents/scripts/estado-git.sh` (más sus copias en `templates/universales/scripts/`). Al ejecutar `powershell -ExecutionPolicy Bypass -File .agents/scripts/estado-git.ps1`, devuelve JSON válido con las claves `rama`, `ultimo_commit`, `commits_recientes`, `pendientes_de_push`, `arbol_limpio` y `archivos_modificados`.
   - `kit/skills/arquitecto/anexos/consultorio.md` incluye la orquestación nativa de subagentes de Antigravity (`Workspace: "branch" | "share"`, Reactive Wakeup), las 4 razones para delegar y el encargo por referencia.
5. **Menú y Equipador actualizados**: `kit/skills/arquitecto-skills/menu-skills.md` incluye `android-cli` y `docs-personales`, y `kit/skills/arquitecto-skills/SKILL.md` incluye el nuevo **Modo DOCTOR** de solo lectura y la configuración de actualización con `origin` (repo de Juan) y `upstream` (`guidocameraeq/vibe-kit`).
6. **Atribución y licencia 100% MIT**: `README.md`, `LICENSE` y `NOTICE` incluyen la atribución clara a Guido (`guidocameraeq/vibe-kit`) como creador del kit original para Claude Code, y `docs/consulta/` + `docs/` contienen únicamente las versiones `docs-personales`.

## Supuestos
- [BAJO] Asumimos que mientras Juan no defina la URL definitiva de su nuevo repo en GitHub, dejamos configurado el remoto actual como `upstream` (`https://github.com/guidocameraeq/vibe-kit.git`) y un slot claro `<tu-usuario>/vibe-kit` en el Modo AUTO-ACTUALIZAR del Equipador (listo para apuntar a `origin` apenas cree el repo en GitHub).
- [BAJO] Asumimos que los scripts de soporte nuevos (`kit-sync` y `estado-git`) se proveen tanto en `.ps1` (PowerShell nativo para Windows) como en `.sh` (Bash).

## Riesgos y decisiones ⚠️
- ⚠️ **Esquema de dos remotos (`origin` de Juan / `upstream` de Guido)**: al reemplazar `CLAUDE.md` por `AGENTS.md` y `docs-fyd` por `docs-personales`, futuros `git merge upstream/main` tendrán conflictos en archivos renombrados si se hacen a ciegas. Consecuencia: las novedades futuras de `upstream` (`guidocameraeq/vibe-kit`, ej. cuando Guido cierre la Misión 5) se traen con `git fetch upstream` e inspección selectiva (`git diff upstream/main -- docs/mision-4/ kit/`) en lugar de un `git pull` ciego.
- ⚠️ **Incorporar Diseño A (frenos) y Diseño C (`/estado`) antes de que Guido cierre la Misión 5**: nos adelanta los beneficios reales ya decididos en Misión 4 (4 preguntas únicas, corrector de git destructivo, `/estado` con tiempos y script git, encargos por referencia), adaptados a la infraestructura nativa de Antigravity. Consecuencia: cuando Guido diseñe el Racimo H (fichas por subproyecto), se podrá extender `/estado` si hace falta.
- ⚠️ **`/compact` nativo en Antigravity vs `cierre parcial`**: en la versión actual de Antigravity sí existe el comando `/compact`, a diferencia de lo que asumía `vibe-kit-main`. Consecuencia: se documenta `/compact` como existente, pero en `/cierre` y en el Playbook se mantiene la recomendación de `cierre parcial` + chat nuevo para misiones largas porque el handoff en disco preserva mejor la precisión que resumir el chat en memoria.

### Alternativas evaluadas y descartadas
- **Portar solo Misión 3 y dejar Misión 4 solo en papeles**: descartado por Juan — ya que hacemos el refactor a conciencia, aprovechamos para llevar al kit ejecutable las mejoras cerradas de Misión 4 (Diseño A, Diseño C y orquestación multiagente nativa de Antigravity).
- **Repo minimalista descartando `observatorio/`, `tips/` y `legacy/`**: descartado — `observatorio/investigacion/` (`repos.py`, `flota.py`, `huella.py`) sirve directamente para medir la salud de los repos de Juan con mínimos ajustes para `AGENTS.md`, y `tips/` + `legacy/` son la trazabilidad de por qué existe cada regla.
- **Promover `/smoke` a skill universal en todos los proyectos**: descartado por Juan en esta iteración — se mantiene como contrato adaptable en `templates/adaptables/smoke.contrato.md`.
