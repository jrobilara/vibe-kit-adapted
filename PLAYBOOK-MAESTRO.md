# PLAYBOOK MAESTRO — Documentación y sistema de trabajo con Google Antigravity

> **Qué es esto:** LA referencia única para arrancar (o reordenar) cualquier proyecto tuyo con
> Google Antigravity (adaptado del playbook original de Guido para Claude Code). Fusiona tres fuentes: el playbook de Hermes (2026-07-02, tras auditar ~4 meses /
> ~1.000 prompts), el "Sistema de Documentación Viva" original (mayo 2026), y la auditoría +
> implementación completa en Perseo (2026-07-02/03, 6 semanas / 151 MB de sesión analizados).
> Todo lo que dice acá está **probado en proyectos reales**; donde hubo teoría vs práctica,
> ganó la práctica. Detalle de la portabilidad a Antigravity: `docs/PORTABILIDAD-ANTIGRAVITY.md`.
>
> **Cómo se usa:** está partido en **dos partes independientes**. La Parte 1 (documentación) se
> aplica sola; la Parte 2 (sistema de trabajo) se aplica sola o encima de la 1. Si un proyecto ya
> tiene sistema de documentación que funciona, saltá directo a la Parte 2 y usá §1.8 para decidir
> si adaptás sus docs o los dejás como están.
>
> Reemplaza a `PLAYBOOK_CLAUDE.md` (Escritorio) y a `SISTEMA-DOCUMENTACION-VIVA.md` (v1).

---

## 0 · El principio que gobierna todo

**El contexto vive en ARCHIVOS, no en la conversación.** Un archivo no se comprime, no se pierde,
y cualquier chat nuevo lo puede leer. El chat es descartable; lo valioso queda escrito.

Esto no es filosofía: es el resultado de dos auditorías. Los chats eternos costaron, medido: un
chat de 332 MB con 35 compactaciones en Hermes y uno de 151 MB con ~11 en Perseo; re-tipear el
mismo ritual 10-25 veces; el "estado actual" viviendo en 6 lugares que se contradecían; el 30% de
los errores técnicos causados por amnesia post-compactación; y ~45 mensajes de puro "continua/dale/y?".

**Qué aplicar según el proyecto:**

| Proyecto | Qué aplicar |
|---|---|
| Nuevo, con continuidad (vas a retomar sesiones, publicar, operar) | Parte 1 + Parte 2 completas |
| Existente con docs que funcionan | Parte 2 + revisión ligera de docs (§1.8) |
| One-off de una tarde | Nada de esto. El sistema paga solo cuando hay continuidad. |

---

# PARTE 1 — EL SISTEMA DE DOCUMENTACIÓN

## 1.1 Los problemas que resuelve

1. **Drift entre sesiones**: Claude propone cosas que descartaste hace 2 semanas.
2. **Pérdida de contexto al compactar**: cada compresión pierde decisiones.
3. **Pendientes fantasmas**: te trae tareas ya resueltas.
4. **Decisiones olvidadas**: en 3 meses no recordás por qué elegiste X sobre Y.
5. **No saber dónde quedaste** al retomar tras días sin tocar el proyecto.
6. **Documentación dispersa** que no se habla entre sí.

## 1.2 Los principios (versión probada)

1. **Una sola fuente de verdad por concepto.** Pendientes solo en TODO. Estado solo en STATUS.
   **Un número vive en UN archivo** — los demás docs referencian sin repetirlo. *(Medido: todo
   número duplicado divergió — el conteo de crons de Perseo llegó a tener 3 valores en 3 docs.)*
2. **Una sola narrativa por sesión.** La historia de "qué se hizo hoy" vive en SESSION_HANDOFF
   (foto) + CHANGELOG (permanente) y en NINGÚN lado más. Los headers de STATUS/TODO son una línea.
   *(En Perseo la misma narrativa se escribía 4 veces por cierre — 40% del trabajo de cerrar.)*
3. **Lo derivable no se escribe.** Si sale del código, de `git log` o de contar rows en la DB, no
   va a un doc. *(Las "métricas" de Perseo quedaron congeladas 7 semanas: decían "4 recetas"
   cuando había 401 películas.)*
4. **DECISIONS y REJECTED separados y obligatorios.** DECISIONS = decisión técnica con
   alternativas (formato ADR). REJECTED = idea descartada por preferencia (3-5 líneas). Sin
   REJECTED, Claude re-propone lo descartado. Es el archivo más subestimado al inicio y el más
   valioso al uso.
5. **Todo archivo append-only necesita índice.** Una línea por entrada, al tope, mantenida en cada
   cierre. *(DECISIONS de Perseo llegó a 232 KB / 58 ADRs: Claude ya no podía consultarlo.)*
6. **Nada de espejos manuales.** Ni dashboards HTML que duplican markdowns, ni resúmenes que
   repiten otros docs. El drift es inevitable. *(El `master-plan.html` era la "pieza central" del
   sistema v1; se retiró de los DOS proyectos — REJ-016 en Perseo. Un dato, un lugar.)*
7. **AGENTS.md (o CLAUDE.md) es solo reglas.** Se carga en cada sesión consumiendo contexto: cuanto más liviano,
   mejor. Arquitectura, schemas y debugging van a archivos dedicados.
8. **Lo superado se archiva, no se borra.** `docs/archive/` + marca en la línea 1
   ("✅ IMPLEMENTADA <fecha>"). Un SPEC vivo que dice "implementá esto" cuando ya está hecho es una
   trampa post-compactación: el agente lo puede re-ejecutar.
9. **Las adaptaciones son aceptables; el esqueleto, no.** Nombres y cantidad de archivos varían
   por proyecto; la filosofía y los reflejos son los mismos en todos.

## 1.3 Los archivos y sus reglas de oro

```
proyecto/
├── README.md               ← identidad pública
├── AGENTS.md               ← reglas para Antigravity (Parte 2)
└── docs/
    ├── ARCHITECTURE.md     ← identidad técnica (stack, topología)
    ├── DECISIONS.md        ← ADRs, CON ÍNDICE al tope
    ├── REJECTED.md         ← descartes (anti-re-propuesta)
    ├── STATUS.md           ← estado por bloque (tabla, celdas cortas)
    ├── TODO.md             ← ÚNICA fuente de pendientes
    ├── CHANGELOG.md        ← historia, orden descendente estricto
    ├── SESSION_HANDOFF.md  ← save game (se sobreescribe entero)
    └── archive/            ← SPECs implementadas, docs superados
```

| Archivo | Regla de oro |
|---|---|
| `README.md` | Qué es + quick reference + setup. **Sin números de versión que roten** (fuente única de versión = el código o el CHANGELOG). |
| `ARCHITECTURE.md` | Se actualiza solo cuando el stack/topología cambia de verdad. |
| `DECISIONS.md` | ADR-NNN correlativo, sin reuso. **Índice de 1 línea por ADR al tope** (número — título — fecha — estado). Para saber si algo ya se decidió: buscar en el índice, no releer el archivo. |
| `REJECTED.md` | REJ-NNN, 3-5 líneas: qué, por qué no, cuándo reconsiderar. |
| `STATUS.md` | Tabla de bloques. **Celdas de máx 2 líneas** (estado + fecha + ref). Header = 1 línea. "Resueltos recientes" con cap de 5. Sin métricas. |
| `TODO.md` | **Completado → AFUERA** (la historia vive en CHANGELOG y git). Header = 1 línea. Criticidad explícita (🔴🟠🟡🟢). |
| `CHANGELOG.md` | Se alimenta en cada cierre. Added/Changed/Fixed/Removed. Orden descendente sin excepciones. |
| `SESSION_HANDOFF.md` | **Se sobreescribe ENTERO en cada cierre** — nunca se apila historia. Contenido: fecha · último commit · qué se hizo (bullets) · estado (branch/servidor/DB) · en curso · **próximo paso CONCRETO** (nunca "seguir avanzando") · bloqueos · archivos tocados · contexto que no está en otro doc. |
| `docs/archive/` | Todo doc superado, marcado en línea 1. Mover, no borrar. |

**Formato ADR (mínimo):** contexto → decisión → razón → alternativas analizadas → consecuencias.
**Formato REJ:** "No hacemos X porque Y. Reconsiderar si Z."

## 1.4 Disparadores de actualización

| Pasó esto | Se actualiza |
|---|---|
| Decisión técnica con alternativas | `DECISIONS.md` (ADR nuevo + fila en el índice) |
| Idea/enfoque descartado por preferencia | `REJECTED.md` |
| Tarea nueva accionable / completada | `TODO.md` (completada → afuera; queda en CHANGELOG) |
| Un bloque cambió de estado | `STATUS.md` (solo la fila) |
| Cierre de sesión | `SESSION_HANDOFF.md` (entero) + `CHANGELOG.md` (entrada) |
| SPEC quedó implementada | Marca en línea 1 + `docs/archive/` |
| Cambió el stack / topología | `ARCHITECTURE.md` |
| Renovaste una credencial | Matriz de vencimientos (§2.6) |
| Aprendiste algo estructural de cómo trabajás | Memoria persistente de Claude |

**Regla general:** si la información va a servir en una sesión futura Y no se deriva del código o
de git, va a un MD. Si es derivable, no se escribe.

## 1.5 Adaptación por tamaño de proyecto

- **Chico** (script, herramienta de una tarde): nada, o solo `TODO.md` + `SESSION_HANDOFF.md` si lo retomás.
- **Mediano** (app standalone, bot, módulo): el core de 6 — `CLAUDE.md`, `SESSION_HANDOFF`, `TODO`,
  `CHANGELOG`, `DECISIONS`, `REJECTED`. `STATUS` y `ARCHITECTURE` recién cuando duela no tenerlos.
- **Grande / en producción**: todo lo anterior + `RECOVERY.md` (plan de restauración **probado**,
  no supuesto), `PROTECTED_PATHS.md` (qué no se toca jamás), `CRONS.md` (fuente única de crons +
  matriz de vencimientos).
- **Con framework upstream** (bot sobre OpenClaw, fork): un doc de referencia del framework con
  URLs/versiones validadas + el **pin de versión documentado con su porqué** (en Perseo: "pineado
  a 2026.5.27, la 6.8 rompe el provider" — eso evitó dos roturas).

## 1.6 El protocolo de cierre (la mecánica que mantiene todo vivo)

Los docs de estado se actualizan **en el cierre de cada sesión**, no cuando te acordás. La
secuencia (que en la Parte 2 se convierte en el comando `/cierre`):

1. Verificar consistencia: handoff previo vs chat vs `git status` vs realidad del servidor (si se
   tocó). **La realidad gana.**
2. HANDOFF entero → CHANGELOG → TODO → STATUS (solo filas) → ADR/REJ si aplica → archivar SPECs
   implementadas.
3. Verificación de números divergentes (¿algún dato quedó en dos docs?).
4. Commit + push. Reporte con SHA y próximo paso.

## 1.7 Síntomas de que el sistema está fallando

- Claude propone algo descartado → REJECTED incompleto o no se lee.
- No sabe dónde estás al arrancar → HANDOFF viejo o no se lee.
- El mismo dato con 2 valores en 2 docs → violaste "un número, un archivo".
- Un doc append-only que ya nadie puede releer → falta índice o poda.
- Los headers de STATUS/TODO cuentan la sesión → violaste "una narrativa".
- CLAUDE.md de 250+ líneas → contenido técnico mezclado con reglas; mudar.

## 1.8 Si el proyecto YA tiene documentación

**No migres por migrar.** El objetivo es que Claude pueda mantener los docs al día, no que los
archivos se llamen igual que acá.

1. **Auditá lo que hay** (30 min, lo hace Claude): qué archivos existen, cuál está vivo vs
   abandonado (fechas vs actividad real), qué está duplicado, qué está muerto.
2. **Mapeá equivalencias**: si su "NOTES.md" cumple el rol del HANDOFF, dejalo con su nombre y
   anotá el mapa en CLAUDE.md. Los reflejos importan más que los nombres.
3. **Agregá solo lo que falte**: casi siempre faltan `SESSION_HANDOFF` (o equivalente), `REJECTED`
   y el protocolo de cierre. Con eso alcanza para arrancar.
4. **Archivá lo muerto** (docs/archive/) y desduplicá los números en su fuente única.
5. Recién entonces conectá la Parte 2 (el CLAUDE.md nuevo referencia los docs con SUS nombres).

---

# PARTE 2 — EL SISTEMA DE TRABAJO (AGENTS.md, skills, reglas y demás)

## 2.1 El ciclo de vida de una misión

```
1. Chat NUEVO en la raíz del proyecto
   → la regla .agents/rules/inicio-sesion.md orienta la lectura inicial (§2.4)
   → decís "inicio" (+ la misión). Antigravity confirma en 3 líneas (y avisa si hay pendientes de git) y espera tu OK.
2. TRABAJAR — las reglas del AGENTS.md operan solas (y "/estado" consulta git en criollo cuando quieras).
3. "cierre" → docs al día + commit + push + SHA → EL CHAT SE DESCARTA.
```

- **Cambió la tarea → cambiá el chat.** Cuando el contexto crece mucho, existe **`cierre parcial`**: guarda el estado en el handoff y te deja
  listo para abrir una conversación limpia sin cerrar todo (o usar `/compact` como emergencia).
- **Specs grandes en dos sesiones**: investigar/diseñar en una → guardar el SPEC como ARCHIVO →
  cerrar → "inicio — ejecutá el SPEC X" en sesión fresca. Nunca mega-prompts pegados a mano. Al
  implementarse, el SPEC se archiva (§1.2.8).
- **Chats paralelos** solo para trabajo genuinamente paralelo (Desktop y Mobile a la vez; un
  workflow largo corriendo aparte). No como "personas" fijas — los roles viven en `AGENTS.md`.

## 2.2 AGENTS.md = el rol (se carga solo en cada chat)

Es lo que antes pegabas a mano como "prompt de rol". Estructura probada (en este orden):

1. **Qué es el proyecto** (2 líneas) + stack + comandos clave (build/test/run/deploy).
2. **El ciclo** (referencia a las skills — sin duplicar sus pasos).
3. **Restricciones duras**: qué no se toca jamás, datos de producción, secretos.
4. **Reglas de evidencia** (abajo).
5. **Reglas operativas** del proyecto (las piedras con las que ya tropezaste).
6. **Mapa de docs** (tabla: archivo → rol → cuándo se actualiza).
7. **Comunicación**: criollo, corto, sin jerga; opciones con tradeoffs + una recomendación.

**Qué NO va**: estado, versiones, pendientes (rotan y quedan viejos — el CLAUDE.md de Hermes decía
"falta el primer release" 12 releases después), arquitectura, schemas.

**Las reglas de evidencia — el corazón, cada una pagada con dolor real:**

- **Definition-of-done dura**: un bug se declara resuelto SOLO tras reproducir E2E el caso que lo
  disparó. "Apliqué el parche" ≠ "está resuelto". *(El bug más caro de Perseo se reportó 7 veces
  como "resuelto" antes del fix real; tu frase: "me dice que hace algo cuando en realidad no lo
  hace — no es confiable".)*
- **Evidencia real o "NO VERIFICADO"**: nunca "listo" a secas. Rows, logs, capturas.
- **Los datos del usuario son LA autoridad**: taxonomías, tags, estados y títulos que creaste
  NUNCA se transforman sin mostrar antes una tabla **"esto cambio / esto preservo"** y esperar tu
  OK. *(El "error gravísimo": Claude colapsó tus 7 estados de Notion sin preguntar.)*
- **En tareas aprobadas no se frena** a pedir permiso intermedio; trabajos >2 min van en
  background con reporte al terminar. *(45 mensajes tuyos de "continua/dale/y?" = 11% de todo lo
  que escribiste en 6 semanas.)*
- **Post-compactación se asume cero archivos leídos**: Read antes de todo Edit. *(30% de los
  errores técnicos de Perseo eran Edit-sin-Read tras compactar.)*
- **Una prioridad por dictado**: si el mensaje trae 3 temas, Claude confirma el orden antes.
- **Regla de las 3 veces**: si le repetiste la misma instrucción 3 veces → va a CLAUDE.md o a una
  skill. Es la señal de que falta sistema, no memoria. *(El "explicámelo en criollo" se pidió 12
  veces antes de ser regla.)*

## 2.3 Skills = rituales convertidos en una palabra

**La regla madre: una skill nace de un ritual que ya repetiste 3+ veces con los mismos pasos.**
No se inventan skills "por las dudas".

Viven en `<raíz>/.agents/skills/<nombre>/SKILL.md` y **se versionan con el repo** (¡verificá el
.gitignore! — §2.6). Se invocan con `/nombre` o por lenguaje natural.
Mismos nombres en todos tus proyectos = memoria muscular.

| Skill | ¿Cuándo aplica? | Qué hace según el proyecto |
|---|---|---|
| `/inicio` | **Siempre** | Lee `SESSION_HANDOFF.md`, `TODO.md` y git real, detecta drift/SPECs sin archivar y avisa si hay commits sin pushear o cambios sueltos, 3 líneas, espera misión y OK. |
| `/cierre` (+ modo `parcial`) | **Siempre** | El protocolo de §1.6 completo + checklist de regresión de los bugs históricos del proyecto + commit/push/SHA. |
| `/estado` | **Siempre** | Corre `.agents/scripts/estado-git.ps1` y traduce en criollo en qué rama estás, qué se tocó y qué falta subir a GitHub, sin tocar nada (Diseño C). |
| `/smoke` | Si hay algo que verificar | Rebuild + launch + batería de pruebas reales. Siempre: reporte con evidencia (estado inicial / test 1 / fixes / test 2). |
| `/deploy` o `/release` | Si hay ritual de publicación | `/release` si publicás versiones (tags + CHANGELOG + gates). `/deploy` si aplicás a un servidor (push → pull → restart si toca runtime → health + smoke). |

Si dos proyectos comparten carpeta raíz, sufijá (`/inicio-mobile`) y anotá en cada `AGENTS.md` qué
skills le pertenecen.

> **Nota de máquina (esta PC, C:).** Set global instalado en `~/.gemini/config/skills/` (actualizado 2026-10-21):
> las 5 **kit-owned**: `arquitecto`, `arquitecto-skills` (el Equipador), `docs-personales` (doc técnica
> por repo), `redteam-spec` (revisor adversarial de specs) y `relevamiento` (el tramo de ANTES del Arquitecto)
> + el Tier 1 del menú — `brainstorming` (specs SIEMPRE en formato SPEC-0), `writing-skills`,
> `systematic-debugging`, `verification-before-completion`, `frontend-design`, `theme-factory`,
> `web-design-guidelines`, `supabase`, `supabase-postgres-best-practices`, `shadcn`,
> `codebase-to-course`, `android-cli`.
> **La curaduría canónica de skills universales es `menu-skills.md` del Equipador** (qué entra,
> qué no y por qué); esta nota solo registra qué hay ACÁ.

## 2.4 Reglas y scripts del proyecto (`.agents/`)

En `<raíz>/.agents/rules/` y `<raíz>/.agents/scripts/` (se versionan):

- **Regla `inicio-sesion.md` (`trigger: always_on`)**: le indica a Antigravity leer `SESSION_HANDOFF.md`, `TODO.md` y los últimos commits al abrir cada conversación.
- **Script `estado-git.ps1` (y `.sh`)**: devuelve en JSON determinístico el estado real de git para que `/estado` e `/inicio` no adivinen.
- **Frenos en humano y corrector de git (en `AGENTS.md`, Diseño A)**: antes de cualquier acción irreversible exige responder las 4 preguntas en criollo (qué cambia, qué se puede perder, cómo volver atrás, si toca algo que hoy anda) y prohíbe comandos destructivos de git (`reset --hard`, `clean -f`, `push --force`, `stash`).
- **Anti-secretos (en `AGENTS.md` y `.gitignore`)**: nunca ejecutar comandos con secretos literales ni versionar `.env`.

## 2.5 Permisos

- Comandos legibles (scripts en `.agents/scripts/`, wrappers claros) reducen prompts de permiso y errores.
- En "preguntar siempre": todo lo destructivo o con efecto externo (borrados, migraciones, deploys, pagos, envíos a personas reales).
- Nunca ejecutar un comando que lleve un secreto literal adentro.

## 2.6 Seguridad y red de datos (lo que nadie mira hasta que duele)

- **Claves SSH SIEMPRE en `~/.ssh/`, jamás dentro del proyecto.** Dentro del árbol del proyecto
  las lee cualquier subagente y están a un descuido del .gitignore de subirse al repo.
  Con un `Host <alias>` en `~/.ssh/config` (y otro para la IP), todos los comandos existentes
  siguen funcionando sin `-i`.
- **El `.gitignore` y `.agents/`**: versioná `.agents/skills/`, `.agents/rules/` y
  `.agents/scripts/`. *(Si el `.gitignore` ignora `.agents/`, el sistema no viaja a GitHub ni sobrevive un cambio de PC.)*
- **Backups: verificados, no supuestos.** El RECOVERY de Perseo decía "Supabase tiene backups
  diarios + PITR" — nunca verificado, y en el plan Free no existen. Regla: si toda tu data vive en
  un solo lugar, cron de `pg_dump` semanal con rotación + **una corrida de prueba real** el día
  que lo instalás. Riesgo bajo × impacto catastrófico = 1 hora bien gastada.
- **Matriz de vencimientos de credenciales** (en CRONS.md o equivalente): qué vence (OAuth,
  sesiones de WhatsApp, cookies, PATs, proxies), cómo se detecta, y el comando de renovación. Los
  watchdogs avisan cuando YA está roto; la matriz permite renovar ANTES. *(7 incidentes de "el bot
  no responde" en Perseo fueron credenciales vencidas descubiertas post-mortem.)* Hábito: al
  renovar cualquier credencial, actualizar la matriz.
- **El keystore/upload key de Android es credencial de punto único de falla**: si se pierde sin
  backup, la app no se puede actualizar NUNCA más en Play Store. Backup en el gestor de
  contraseñas del usuario (no solo dentro del proyecto) + documentar en RECOVERY/matriz el camino
  de emergencia: Play Console → App integrity → Play App Signing → "Request upload key reset"
  (verificado contra soporte oficial de Google, 2026-07-11).

## 2.7 Agentes y workflows (orquestación)

- **Para qué usarlos**: proteger el contexto del chat principal (auditorías largas, redacción de
  docs, análisis voluminosos), research web en paralelo por ángulos genuinamente distintos (el
  mejor patrón medido), y verificación.
- **Fan-out con techo: 20-30 agentes por workflow.** Censos grandes van en **chunks de 15-20 ítems
  por agente** (medido: 4× más barato que 1-agente-por-ítem). Todo workflow >30 agentes escribe
  resultados parciales a disco (resumible). *(La vez que no: ~260 subagentes reventaron el límite
  de la sesión.)*
- **Verificación adversarial obligatoria** para todo resultado de agentes que termine en escritura
  a producción o deploy. Medido: la auditoría adversarial corrigió el **46%** de los veredictos de
  una sola pasada, y la confianza autoreportada de los agentes es inútil (0 de 179 se declararon
  "baja confianza"). Auditá el subconjunto dudoso, no el censo entero.
- **Modelo barato para batch** (censos, transformaciones mecánicas); el modelo grande se reserva
  para diseño, debugging difícil y decisiones.
- Si el batch consume una cuota compartida (API del bot, etc.): declarar costo estimado ANTES.
- **Agent teams nativos** (equipos de agentes que se coordinan solos, con team lead): existen en
  Claude Code desde 2026. Anotado 2026-07-11: evaluar SOLO si aparece trabajo genuinamente
  paralelo (varios frentes de construcción a la vez); para el flujo de una misión por chat,
  sería complejidad sin ganancia.

## 2.8 Qué viaja con el repo y qué es por-máquina

| Viaja con git (clonás y está) | Por-máquina (recrear en PC nueva, ~5 min) |
|---|---|
| `.agents/skills/` (`inicio`, `cierre`, `estado`) | Clave SSH en `~/.ssh/` + `~/.ssh/config` |
| `.agents/rules/inicio-sesion.md` | Skills globales en `~/.gemini/config/skills/` |
| `.agents/scripts/` (`estado-git.ps1`, `.sh`) | PAT de GitHub / credenciales |
| `AGENTS.md`, `docs/`, `scripts/` | Configuración local de MCP (`mcp_config.json`) |

## 2.9 Receta de aplicación

> **Existen templates reales de todo lo de abajo** (skills genéricas, regla de inicio, `AGENTS.template.md`,
> docs mínimos, contratos de smoke/deploy) en `~/.gemini/config/skills/arquitecto/templates/` — ver su
> `LEEME.md`. Instanciar desde ahí, no reescribir de cero.

### Proyecto nuevo — el camino automático: `/arquitecto`

Para un proyecto nuevo de verdad (idea → app), el camino canónico es la skill global
**`/arquitecto`** (ver `legacy/PROPUESTA-VIBE-KIT-V2.md`): te entrevista, piensa
los concerns que no viste (roles, listas configurables, multi-tenant ⚠️, i18n ⚠️), escribe el
SPEC-0 con gate de aprobación real, y ejecuta esta receta completa por vos — el proyecto nace en
régimen. Los pasos de abajo quedan como referencia y para montarlo a mano.

### Proyecto nuevo a mano (~1-2 horas, lo hace Antigravity con tu OK)

1. Definir la **raíz** (donde abrís los chats = donde viven `.agents/` y `AGENTS.md`).
2. `AGENTS.md` mínimo viable (§2.2, 30 min) — instanciar `AGENTS.template.md`.
3. Docs de estado mínimos: `SESSION_HANDOFF` + `TODO` + `CHANGELOG` (el resto cuando el proyecto
   los pida — §1.5).
4. Skills que apliquen según la regla de 3+ (§2.3) — `/inicio`, `/cierre` y `/estado` van siempre; `/smoke`
   y `/deploy` recién cuando el ritual real exista (sus contratos esperan en los templates).
5. Regla `.agents/rules/inicio-sesion.md` + scripts `.agents/scripts/estado-git.*` (§2.4).
6. **Verificar el .gitignore** (§2.6) y que `git status` muestre `.agents/` trackeado.
7. Primer commit + primer ciclo completo (inicio → algo chico → cierre) para probar el sistema.

### Proyecto existente

Igual, pero antes: §1.8 (auditar y respetar los docs que ya funcionan). El `AGENTS.md` nuevo
referencia los docs con SUS nombres.

### El atajo — prompt para copiar/pegar en un chat del proyecto

> Leé `PLAYBOOK-MAESTRO.md` del repo `vibe-kit` y aplicá ese
> sistema a este proyecto: auditá cómo se trabaja acá (git, docs existentes, rituales repetidos),
> decidí qué partes aplican (Parte 1 según §1.8 si ya hay docs; Parte 2 con las skills que pasen
> la regla de 3+), y armá el `AGENTS.md`, los docs de estado, las skills (`/inicio`, `/cierre`, `/estado`), la regla de inicio y los scripts equivalentes.
> Verificá que el .gitignore no esté ignorando `.agents/`. Mostrame el plan completo antes de
> escribir nada.

### Mantenimiento (que no se pudra)

- Fuente única de versión; TODO completado → borrar; handoff = 1 foto viva.
- Regla de las 3 veces → CLAUDE.md o skill.
- Nada de espejos manuales.
- Cada ~2 semanas: *"audit del sistema de docs: verificá consistencia entre docs y código,
  corregí desfases"*.
- Al cerrar: si cambió un hecho estructural, actualizar también la memoria de Claude (sin ese
  disparador, la memoria describe código que ya no existe — pasó).

---

## Apéndice — Procedencia y validación

| Fuente | Qué aportó |
|---|---|
| **Sistema de Documentación Viva v1** (may-2026, validado en 4 proyectos) | El esqueleto de la Parte 1: capas, archivos, ADR/REJ, disparadores. Su dashboard HTML y RESUME-PROMPT murieron en la práctica y acá ya no están. |
| **Playbook de Hermes** (2026-07-02, ~4 meses / ~1.000 prompts / chat de 332 MB auditados) | El esqueleto de la Parte 2: contexto-en-archivos, skills, hooks, ciclo por misión, receta. |
| **Auditoría + implementación en Perseo** (2026-07-02/03, 6 semanas / 151 MB / 414 mensajes) | Todo lo medido: fixes fantasma, narrativa 4×, números divergentes, índices, fan-out y verificación adversarial, anti-secretos, backups verificados, matriz de vencimientos, .gitignore de .claude/, datos-del-usuario-como-autoridad. |

*Versión 2026-07-04. Si este documento contradice a la práctica de un proyecto que funciona, ganó
la práctica: actualizá esto.*