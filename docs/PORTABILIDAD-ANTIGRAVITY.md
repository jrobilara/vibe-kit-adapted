# Portabilidad a Antigravity (Gemini) — v2

> Qué se cambió en el kit para que funcione en **Google Antigravity** (con Gemini) a partir del
> `vibe-kit` original de Guido (`guidocameraeq/vibe-kit`), por qué, y qué partes de las Misiones 3 y 4
> se incorporaron. Sirve para que una sesión futura entienda el criterio y no "arregle" de vuelta lo
> que es intencional.
> Estado: v2 aplicada y verificada sobre la estructura de Misión 3 + diseños cerrados A y C de Misión 4 (2026-10-21, ADR-024).

## 1. Equivalencias de concepto

| En Claude Code (`upstream`) | En Google Antigravity (`origin`) | Dónde quedó |
|---|---|---|
| `CLAUDE.md` (reglas del proyecto) | `AGENTS.md` | raíz del repo, `observatorio/extractor/` y template `AGENTS.template.md` |
| `.claude/skills/<n>/SKILL.md` (skills del proyecto) | `.agents/skills/<n>/SKILL.md` | `.agents/skills/{inicio,cierre,estado}` |
| `~/.claude/skills/` (skills globales) | `~/.gemini/config/skills/` | las 5 skills del kit (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) |
| Hook `SessionStart` (inyecta el handoff) | Regla `always_on` en `.agents/rules/` | `.agents/rules/inicio-sesion.md` y template universal |
| `.claude/settings.json` + `hooks/` | Reglas en `AGENTS.md` (Diseño A: frenos en criollo + corrector de git) y `.agents/rules/` | `AGENTS.md` y `AGENTS.template.md` |
| `.claude/scripts/kit-sync.sh` | `.agents/scripts/kit-sync.ps1` (+ `.sh`) | compara y sincroniza las 5 skills preservando `**Carpeta de proyectos de esta máquina**` |
| Script determinístico de git (Diseño C) | `.agents/scripts/estado-git.ps1` (+ `.sh`) + skill `/estado` | `.agents/scripts/` y templates universales del Arquitecto |
| Agente `kit/agents/redteam-spec.md` | Skill `kit/skills/redteam-spec/SKILL.md` | se invoca en un subagente aparte con `invoke_subagent` |
| `/docs-fyd` (auditoría corporativa FyD) | `/docs-personales` (documentación técnica propia, 100% MIT) | `kit/skills/docs-personales/` y `docs/SPEC-docs-personales*.md` |
| `EnterPlanMode` / `ExitPlanMode` | Modo Planning + artifact `implementation_plan.md` con `RequestFeedback=true` | Arquitecto, Pasos 4 y B |
| `AskUserQuestion` (`multiSelect`) | `ask_question` (`is_multi_select`) | Arquitecto, Equipador, `/relevamiento`, `docs-personales` |
| Subagentes / Agent Teams de Claude | `invoke_subagent`, `send_message`, `Workspace: "branch" \| "share"`, Reactive Wakeup | `kit/skills/arquitecto/anexos/consultorio.md` y `AGENTS.template.md` |
| `/compact` | Slash command `/compact` del usuario o corte con `cierre parcial` + chat nuevo | `/cierre`, playbook, guías |
| `claude` (CLI) | `agy` | `kit/INSTALAR.md` |

## 2. Qué se cambió en la v2 y por qué

1. **Estructura de Misión 3 adoptada íntegra.** El Extractor y los scripts de investigación viven bajo `observatorio/` (`observatorio/extractor/` y `observatorio/investigacion/`), los manuales en `manuales/`, el material de referencia en `docs/consulta/`, y los pendientes e historia en `docs/TODO.md` y `docs/CHANGELOG.md`.
2. **Paridad garantizada con `kit-sync.ps1` (y `.sh`).** En Windows/PowerShell y bash, `.agents/scripts/kit-sync.ps1` compara y sincroniza las 5 skills propias (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) entre `kit/skills/` y `~/.gemini/config/skills/`, preservando la línea `**Carpeta de proyectos de esta máquina**` de la PC local mientras en el repo queda el placeholder `{{CARPETA_DE_PROYECTOS}}`.
3. **Diseño A (Misión 4) adaptado a `AGENTS.md`.** Como Antigravity no usa `.claude/settings.json`, los frenos del Diseño A viven en `AGENTS.md` y `AGENTS.template.md`: las **4 preguntas en humano** antes de toda acción irreversible (qué va a cambiar, qué se puede perder, cómo se vuelve atrás, si toca algo que hoy anda) y el **corrector de git destructivo** (prohibición de `reset --hard`, `checkout --`, `restore`, `clean -f`, `branch -D`, `push --force` y `stash`).
4. **Diseño C (Misión 4) implementado con `/estado` y `estado-git.ps1`.** Se sumó la skill universal `/estado` respaldada por `.agents/scripts/estado-git.ps1` (y `.sh`), que devuelve un JSON determinístico con rama, último commit, pendientes de push y árbol limpio/sucio para responder en criollo sin que el modelo adivine. Además, `/inicio` avisa en 1 línea si hay commits sin subir o cambios sueltos.
5. **Orquestación nativa de Antigravity en el Consultorio (Modo C).** Se incorporaron las 4 razones con nombre para delegar en subagentes (contexto limpio, paralelo real, modelo más liviano `flash`/`flash_lite`, aislamiento en rama con `Workspace: "branch"`), el handoff por referencia (pasar rutas y líneas en vez de copiar bloques largos) y el patrón de Reactive Wakeup (sin polling).
6. **Equipador con `Modo DOCTOR`, doble remoto (`origin` / `upstream`) y `android-cli`.** `/arquitecto-skills` suma el chequeo rápido de solo-lectura (`doctor` / `chequeá el kit`), soporte para actualizar desde `origin` o `upstream` sin pisar la adaptación a Antigravity, y la skill `android-cli` en el menú curado para el stack Kotlin/Android de Juan.
7. **100% MIT (`docs-personales` en lugar de `docs-fyd`) y atribución a Guido.** Se reemplazó `docs-fyd` por `docs-personales`, eliminando la única excepción de licencia propietaria (`referencia-prompts-fyd.md`), y se documentó la autoría original de Guido (`guidocameraeq/vibe-kit`) en `README.md`, `LICENSE` y `NOTICE`, manteniendo la autoría de Guido sobre el método y las plantillas de `/relevamiento`.

## 3. Lo que NO se toca (a propósito)

- **Las plantillas fuente (`kit/skills/relevamiento/plantillas/_fuente/`):** son los originales del método "Cómo Arrancar un Proyecto" de Guido aprobados por su jefe y permanecen byte a byte idénticos a `upstream`.
- **Archivo histórico y actas (`legacy/`, `tips/`, `docs/mision-4/`, ADRs 001..023 y SPECs cerrados):** conservan la terminología original de Claude Code y de Guido porque son registro histórico real de dónde salieron las reglas y mediciones del método.

## 4. Flujo de trabajo resultante en Antigravity

1. Abrir Antigravity en la raíz del repo o del proyecto (carga `AGENTS.md` y `.agents/rules/inicio-sesion.md`).
2. Conversación nueva → `inicio` → misión → `cierre` → descartar el chat (y `/estado` en cualquier momento para consultar git en criollo).
3. Si se tocó `kit/`, correr `.agents/scripts/kit-sync.ps1 sync` y verificar que `.agents/scripts/kit-sync.ps1 diff` termine en `LIMPIO` (exit 0).
4. Nunca editar `~/.gemini/config/skills/` directo; se edita en `kit/skills/`.
