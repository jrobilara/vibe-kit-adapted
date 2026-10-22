# Session Handoff — vibe-kit (Adaptación Antigravity v2)

> **Save game** del proyecto madre. `/cierre` lo sobreescribe entero; la regla `inicio-sesion` (o `/inicio`) lo lee al abrir cada chat nuevo en esta carpeta.

**Última sesión cerrada:** 2026-10-21 (Diseño con `/arquitecto` Modo B + auditoría `redteam-spec`).
Se diseñó, auditó y aprobó el plano completo para adaptar esta versión evolucionada de `vibe-kit` (Misiones 3 y 4 de Guido) al flujo de Juan en **Antigravity (Gemini)**. No se tocó `kit/` todavía (solo diseño).

## Dónde estamos

- ✅ **Spec listo para construir**: [`docs/SPEC-adaptacion-antigravity.md`](SPEC-adaptacion-antigravity.md) está en **`Estado: READY`** tras pasar por entrevista de decisiones y una ronda de `redteam-spec` (5 hallazgos corregidos e integrados al plano).
- 🧭 **Qué define el spec**:
  - **Base Misión 3 completa** adaptada a `AGENTS.md` y `.agents/` + atribución explícita a Guido (`guidocameraeq/vibe-kit`) bajo licencia 100% MIT (reemplazando `docs-fyd` por `docs-personales` desde `C:\Users\Usuario\Desktop\vibe-kit-main`).
  - **Mejoras cerradas de Misión 4 activas en el kit**:
    - **Diseño A (Frenos y Correctores)**: las 4 únicas preguntas al humano + corrector contra git destructivo en `AGENTS.template.md` + encargos por referencia (`SPEC` + `archivo:línea`).
    - **Diseño C (`/estado`)**: nueva skill `/estado` y script recolector `.agents/scripts/estado-git.ps1` (`.sh`) con contrato JSON fijo (`rama`, `ultimo_commit`, `commits_recientes`, `pendientes_de_push`, `arbol_limpio`, `archivos_modificados`).
    - **Orquestación multiagente nativa de Antigravity**: `invoke_subagent` con `Workspace: "branch" | "share"`, `send_message` y Reactive Wakeup en `consultorio.md`.
  - **Sincronización y Equipador**: scripts `.agents/scripts/kit-sync.ps1` y `.sh` hacia `~/.gemini/config/skills/` (preservando `E:/Proyectos/AI Projects` instalado y dejando `{{CARPETA_DE_PROYECTOS}}` en `kit/`), nuevo **Modo DOCTOR** en `/arquitecto-skills`, y `android-cli` en `menu-skills.md`.
- 🔗 **Remotos de git**: el remoto original de Guido quedó renombrado como `upstream` (`https://github.com/guidocameraeq/vibe-kit.git`) para evitar pushes accidentales al repo de Guido. Queda listo para que Juan agregue su propio `origin` en GitHub cuando quiera publicar su fork adaptado.

## Próximo paso: construir `docs/SPEC-adaptacion-antigravity.md`

**Título de la sesión: `vibe-kit · Construir adaptación Antigravity v2`**

- **Comando de arranque en chat nuevo**:
  `inicio — ejecutá el spec docs/SPEC-adaptacion-antigravity.md (está READY)`
- **Fuentes de apoyo en disco**:
  - Este repo (`C:\Users\Usuario\Desktop\vibe kit v2\vibe-kit`): base canónica de Misión 3 y Misión 4.
  - Adaptación previa (`C:\Users\Usuario\Desktop\vibe-kit-main`): fuente para portar `kit/skills/docs-personales/`, `kit/skills/redteam-spec/SKILL.md`, `docs/SPEC-docs-personales*.md` y `docs/consulta/*-personales*.md`.
- **Al terminar la construcción**: verificar los 6 criterios de aceptación del spec (incluyendo `kit-sync.ps1 sync` dando `LIMPIO` contra `~/.gemini/config/skills/`), marcar el spec como `✅ IMPLEMENTADO` y cerrar con `/cierre`.

## Bloqueos

Ninguno.
