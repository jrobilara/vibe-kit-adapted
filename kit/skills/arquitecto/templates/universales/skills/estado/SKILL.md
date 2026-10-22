---
name: estado
description: Reporte de estado de {{PROYECTO}} (Diseño C) — cruza los datos mecánicos de git (`estado-git.ps1`) con `docs/SESSION_HANDOFF.md` y `docs/TODO.md`, mostrando arriba de todo qué espera decisión del usuario, qué se hizo, qué sigue, qué está trabado y la tabla de tiempos/estimación de la iniciativa activa. Usar cuando el usuario dice "estado", "/estado", "¿cómo vamos?", "¿en qué estamos?" o pide el avance del proyecto o de una feature.
---

# /estado — saber cómo van las cosas sin ruido (Diseño C)

Esta skill responde "¿cómo vamos?" combinando datos mecánicos reales de git con el estado de `docs/TODO.md` y `docs/SESSION_HANDOFF.md` (o el `docs/SPEC-*.md` de la iniciativa en curso).

## 1. De dónde salen los datos (regla anti-alucinación)

1. **Corré primero el recolector mecánico de git** (jamás inventes SHAs, fechas ni estado del árbol):
   - Windows (PowerShell): `powershell -ExecutionPolicy Bypass -File .agents/scripts/estado-git.ps1`
   - Linux/macOS/Git Bash: `bash .agents/scripts/estado-git.sh`
   - Devuelve JSON fijo: `rama`, `ultimo_commit`, `commits_recientes`, `pendientes_de_push`, `arbol_limpio`, `archivos_modificados`.
2. **Cruzá con los documentos vivos**: `docs/SESSION_HANDOFF.md`, `docs/TODO.md` y, si hay una feature/iniciativa activa, su `docs/SPEC-*.md`.
3. **Solo lectura y rápido**: `/estado` no modifica archivos ni corre suites pesadas de tests.

## 2. Dos alturas de reporte

- **`/estado`** (sin nombre, o con el nombre del proyecto): vista corta con "Te espera" arriba de todo, estado git y una línea por iniciativa/tarea activa. Si este chat ya está trabajando en una iniciativa puntual, muestra esa iniciativa por contexto.
- **`/estado <iniciativa>`**: vista completa de esa iniciativa/spec con la tabla de tareas, tiempos medidos y estimación de lo que falta.

## 3. Formato obligatorio de salida

### A. Arriba de todo: `🔔 Te espera`
Lo que necesita respuesta del humano ahora mismo (solo las **4 preguntas permitidas** en `AGENTS.md` —borrar datos reales, tocar plata, manejar claves, mandar algo hacia afuera a su nombre— o una decisión de diseño/negocio). Si no hay nada: `Nada pendiente de tu lado.`

### B. La parte común (4 bullets cortos)
- **Git**: `<rama>` · último commit `<sha>` (`<fecha>`) · sin subir: `<pendientes_de_push>` · árbol: `<limpio / N modificados>`.
- **Qué se hizo**: apoyado en `commits_recientes` y el handoff.
- **Qué sigue**: próxima acción concreta del `TODO.md` o spec activo.
- **Qué está trabado**: bloqueos reales (o `Ninguno`).

### C. Tabla de la iniciativa y tiempos

| Tarea | Estado | Estimado | Real máquina | Real con vos | Complejidad vs previsto (y por qué) |
|---|---|---|---|---|---|
| `<tarea hecha>` | ✅ Hecho | `<est>` | `<según timestamps de commits>` | `<min/h>` | `<igual / más / menos — razón corta>` |
| `<tarea pendiente>` | ⏳ Falta | `<estimación del director>` | — | — | `<comparación contra las hechas>` |

> **Regla de estimación:** el script entrega los timestamps crudos de git; **la estimación de lo que falta la hace el agente director** comparando la complejidad de cada ítem pendiente contra lo que ya tardaron las tareas terminadas. Separar siempre horas de máquina vs horas con el humano presente.
