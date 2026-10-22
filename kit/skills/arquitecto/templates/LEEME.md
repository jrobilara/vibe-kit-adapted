# Templates del sistema de trabajo — qué es cada cosa

Moldes extraídos de las instancias reales de Perseo y evolucionados con la Misión 4 (Diseño A frenos y Diseño C `/estado`), materializan el PLAYBOOK-MAESTRO (repo vibe-kit). **Quién los instancia**: el Arquitecto al montar un proyecto nuevo, o el prompt de aplicación del §2.9 del playbook pegado a mano en un chat del proyecto. Instanciar = copiar al proyecto, reemplazar los `{{...}}`, borrar lo que no aplique.

## `universales/` — van en TODO proyecto, desde el día cero

| Template | Va a | Qué es |
|---|---|---|
| `skills/inicio/SKILL.md` | `.agents/skills/inicio/` | Ritual de arranque: usa el contexto de la regla `inicio-sesion`, cruza handoff vs git, 3 líneas, espera OK. |
| `skills/estado/SKILL.md` | `.agents/skills/estado/` | Reporte de avance determinista (Diseño C): cruza `estado-git.ps1` con handoff y TODO, muestra qué espera al humano y tabla de tiempos. |
| `skills/cierre/SKILL.md` | `.agents/skills/cierre/` | Ritual de cierre completo + modo `parcial` (emergencia: contexto lleno). |
| `scripts/estado-git.ps1` · `estado-git.sh` | `.agents/scripts/` | Recolectores mecánicos de git en JSON (`rama`, `ultimo_commit`, `commits_recientes`, `pendientes_de_push`, `arbol_limpio`, `archivos_modificados`). |
| `rules/inicio-sesion.md` | `.agents/rules/` | Regla `always_on`: al abrir cada conversación lee handoff + primeras 40 líneas de TODO + git (reemplaza el hook SessionStart). |
| `AGENTS.template.md` | `AGENTS.md` (raíz) | El rol: reglas de comportamiento con las 4 únicas preguntas al humano, corrector contra git destructivo y slots del proyecto. |
| `docs/*.md` | `docs/` | Esqueletos de SESSION_HANDOFF (se sobreescribe entero), TODO (única fuente de pendientes, completado→borrar) y CHANGELOG (entrada por cierre). |

## `adaptables/` — recién cuando el ritual real existe (regla de 3+)

| Template | Qué es |
|---|---|
| `smoke.contrato.md` | Contrato universal de verificación con evidencia; se instancia como `/smoke` con los pasos reales del proyecto. |
| `deploy.contrato.md` | Contrato de publicación (push → aplicar → salud → smoke); se instancia como `/deploy` o `/release`. |

## La regla molde-vs-instancia (§1.2.9 del playbook)

**Las adaptaciones son aceptables; el esqueleto, no.** Nombres, comandos y cantidad de archivos varían por proyecto — la filosofía y los reflejos (handoff único, evidencia o NO VERIFICADO, las 4 preguntas al humano, una misión por chat, cierre que deja los docs al día) son los mismos en todos. Si una instancia rompe un paso del contrato, no es adaptación: es regresión.
