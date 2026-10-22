---
name: inicio
description: Ritual de inicio de sesión de {{PROYECTO}}. Usar cuando el usuario dice "inicio", "retomemos", "arranquemos", "¿en qué quedamos?" o al empezar una sesión de trabajo nueva.
---

# /inicio — arrancar una sesión de trabajo

La regla `.agents/rules/inicio-sesion.md` (`trigger: always_on`) ya ordena leer `docs/SESSION_HANDOFF.md`, las primeras 40 líneas de `docs/TODO.md` y el estado git al abrir esta conversación. Si ya los leíste en este chat, **NO los releas** (es costo puro de contexto). Releé el archivo solo ante señal de drift: fecha vieja, contradicción con git, o tras un `/compact`.

## Pasos

1. Cruzar handoff vs realidad: ¿el "último commit" del handoff coincide con `git log`? ¿Hay working tree sucio que el handoff no menciona? Detectar también: SPECs implementadas sin archivar en `docs/archive/`, TODO que contradice al handoff, drift repo↔entorno anotado.
2. Confirmar al usuario en 3 líneas: **Estado** / **Próxima acción** (del handoff) / **Bloqueos**. Si no dio la misión, preguntarla.
3. **NO tocar código ni docs hasta el OK explícito del usuario.**
4. Con la misión confirmada, y SOLO si la misión toca el sistema en vivo: correr `{{COMANDO_SALUD_OPCIONAL}}` — no-bloqueante (si falla, reportarlo y seguir; el inicio nunca se traba por esto). *(Borrá este paso si el proyecto no tiene comando de salud.)*

## Reglas

- **Una sesión = una misión.** Si a mitad de sesión aparece una misión distinta de verdad, proponer `/cierre` y conversación nueva.
- Si el handoff tiene más de 7 días, avisar que puede estar viejo y verificar contra git antes de confiar en él.
