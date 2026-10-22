---
name: estado
description: Reporte de estado de vibe-kit (Diseño C de Misión 4) — cruza los datos mecánicos de git (`estado-git.ps1`) con el handoff y `docs/TODO.md`, mostrando arriba de todo qué espera decisión humana, qué se hizo, qué sigue, qué está trabado y la tabla de tiempos/estimación de la iniciativa activa. Usar cuando Juan dice "estado", "/estado", "¿cómo vamos?", "¿en qué estamos?" o pide el avance de una misión o iniciativa.
---

# /estado — saber cómo van las cosas sin ruido (Diseño C)

Esta skill materializa el **Diseño C de la Misión 4**: silencio por defecto durante la ejecución, y un reporte estructurado y determinista cuando Juan pregunta `/estado` (o al final del día).

## 1. De dónde salen los datos (regla anti-alucinación)

- **Lo mecánico lo calcula el script desde git** (jamás de memoria):
  - Windows (PowerShell): `powershell -ExecutionPolicy Bypass -File .agents/scripts/estado-git.ps1`
  - Bash: `bash .agents/scripts/estado-git.sh`
  - Devuelve JSON con: `rama`, `ultimo_commit` (`sha`, `fecha`, `mensaje`), `commits_recientes`, `pendientes_de_push`, `arbol_limpio` y `archivos_modificados`.
- **Lo de criterio sale de los documentos vivos**:
  - `docs/SESSION_HANDOFF.md` y `docs/TODO.md` (o el `docs/SPEC-*.md` / `docs/mision-4/PLAN.md` de la iniciativa activa).
- **No corre suites de pruebas pesadas**: `/estado` es instantáneo y de solo lectura.

## 2. Dos alturas de reporte

- **`/estado` (sin argumento, o `/estado vibe-kit`)**: vista corta del proyecto (o de la iniciativa activa en este chat si ya está en marcha).
- **`/estado <iniciativa>`** (ej. `/estado mision-4` o `/estado adaptacion-antigravity`): reporte completo de esa iniciativa con su tabla de tareas, tiempos medidos y estimación del director.

## 3. Formato obligatorio de salida

### A. Arriba de todo: `🔔 Te espera`
Lo único que requiere decisión o acción de Juan ahora mismo (alguna de las **4 únicas preguntas al humano** de Diseño A o una decisión de diseño/negocio pendiente). Si no hay nada bloqueado esperando a Juan, escribir literal: `Ninguna decisión pendiente — podés seguir o delegar.`

### B. Resumen en 4 líneas (la parte común)
- **Git (mecánico)**: `<rama>` · último commit `<sha>` (`<fecha>`) · pendientes de push: `<N>` · árbol: `<limpio / N archivos modificados>`.
- **Qué se hizo**: lo completado desde el último corte (apoyado en `commits_recientes`).
- **Qué sigue**: la próxima tarea concreta en cola.
- **Qué está trabado**: bloqueos técnicos o externos (o `Ninguno`).

### C. Tabla de la iniciativa y tiempos (cuando aplica a la misión en curso o `/estado <iniciativa>`)

| Tarea | Estado | Estimado | Real máquina | Real con Juan | Complejidad vs previsto (y por qué) |
|---|---|---|---|---|---|
| `<tarea hecha>` | ✅ Hecho | `<est>` | `<min/h según timestamps de commits>` | `<min/h>` | `<igual / más / menos — razón corta>` |
| `<tarea pendiente>` | ⏳ Falta | `<estimación del director>` | — | — | `<por qué se estima así comparado con las hechas>` |

> **Regla de estimación (Misión 4):** el script junta los timestamps reales de `commits_recientes`, pero **la estimación de lo que falta la hace el director** comparando la complejidad de cada tarea pendiente contra las ya medidas. Separar siempre **tiempo de máquina** y **tiempo con Juan presente**.
