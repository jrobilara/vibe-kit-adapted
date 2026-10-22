---
trigger: always_on
description: Al abrir una conversación nueva en este repo, leer el estado antes de tocar nada (reemplaza el hook SessionStart).
---

# Inicio de sesión — leer el estado primero

Al empezar una conversación nueva en este repo, **antes de responder o tocar archivos**:

1. Leer `docs/SESSION_HANDOFF.md` (si no existe, decir "sin handoff todavía").
2. Leer las primeras 40 líneas de `docs/TODO.md` (única fuente de pendientes).
3. Correr `git log --oneline -5` y `git status -sb`.
4. Ejecutar la skill `/inicio` (cruza el handoff con la realidad y `kit-sync`, y confirma en 3 líneas).

No modificar nada hasta el OK explícito de Juan.
