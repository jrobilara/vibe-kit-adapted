---
trigger: always_on
description: Al abrir una conversación nueva en {{PROYECTO}}, leer el estado antes de tocar nada (reemplaza el hook SessionStart).
---

# Inicio de sesión — leer el estado primero

Al empezar una conversación nueva en este proyecto (o tras compactar contexto con `/compact`), **antes de responder o tocar archivos**:

1. Leer `docs/SESSION_HANDOFF.md` (si no existe, decir "sin handoff todavía").
2. Leer las primeras 40 líneas de `docs/TODO.md` (única fuente de pendientes; tope de lectura para no saturar contexto).
3. Correr `git log --oneline -5` y `git status -sb`.
4. Seguir el ritual de `.agents/skills/inicio/SKILL.md`: cruzar handoff con la realidad y confirmar en 3 líneas (**Estado** / **Próxima acción** / **Bloqueos**).

No modificar código ni docs hasta el OK explícito del usuario.
