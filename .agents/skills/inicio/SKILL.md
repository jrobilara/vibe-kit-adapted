---
name: inicio
description: Ritual de inicio de sesión del repo vibe-kit — cruzar el handoff con la realidad (git, diff kit↔instalado con kit-sync, tandas sin procesar), confirmar en 3 líneas y esperar la misión. Usar cuando Juan dice "inicio", "retomemos", "arranquemos", "¿en qué quedamos?" o al abrir una conversación de trabajo nueva acá.
---

# /inicio — arrancar una sesión en el proyecto madre

La regla `.agents/rules/inicio-sesion.md` (`trigger: always_on`) ya ordena leer `docs/SESSION_HANDOFF.md`, las primeras 40 líneas de `docs/TODO.md` y los últimos commits al abrir la conversación. Si ya los leíste en este chat, **no los releas** (es costo puro de contexto); releé solo ante señal de drift (fecha vieja, contradicción con git).

## Pasos

1. **Cruzar el handoff con la realidad** (barato, todo local — mostrar solo lo que llame la atención):
   - `git status -sb` → ¿working tree limpio? ¿cómo está respecto a `origin/main` y `upstream/main`? ¿el último commit coincide con el handoff?
   - **`powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1`** (o `bash .agents/scripts/kit-sync.sh`) — compara las **5 skills canónicas** (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) entre `kit/skills/` y `~/.gemini/config/skills/`, ignorando la línea de la carpeta de proyectos de cada PC → **el drift más peligroso de este repo**: si no da `LIMPIO`, alguien editó `~/.gemini/config/skills/` directo (prohibido) o quedó un cierre a medias. FRENAR y mostrarlo antes de trabajar — nunca pisar a ciegas en ninguna dirección.
   - ¿Hay tandas en `tips/` con propuestas sin procesar (checkboxes `- [ ]` sin marcar)? → es trabajo pendiente que el handoff puede no mencionar.
2. **Confirmar en 3 líneas**: **Estado** / **Próxima acción** (del handoff y los pendientes de `docs/TODO.md`) / **Bloqueos**. Si no dio la misión, preguntarla.
3. **NO tocar nada hasta el OK explícito de Juan.**

## Reglas

- **Una sesión = una misión.** Si a mitad aparece una misión distinta de verdad, proponer `/cierre` y conversación nueva.
- Handoff de más de 7 días → avisar que puede estar viejo y confiar en git, no en él.
- Este repo MANTIENE el método; las apps se construyen en sus propios proyectos. Si la misión es "construir una app" → es `/arquitecto` en otro lado, no acá.
