<p align="center">
  <img src="assets/banner.svg" alt="vibe-kit — Dirigí tu agente de IA con método" width="100%">
</p>

<p align="center">
  <a href="docs/CHANGELOG.md"><img alt="versión" src="https://img.shields.io/github/v/tag/guidocameraeq/vibe-kit?sort=semver&style=flat-square&label=base%20upstream&color=1d5aa6"></a>
  <a href="https://github.com/jrobilara/vibe-kit-adapted/commits/main"><img alt="último cambio" src="https://img.shields.io/github/last-commit/jrobilara/vibe-kit-adapted?style=flat-square&label=%C3%BAltimo%20cambio&color=1d5aa6"></a>
  <a href="LICENSE"><img alt="licencia" src="https://img.shields.io/badge/licencia-MIT-1d5aa6?style=flat-square"></a>
  <img alt="adaptado para Antigravity" src="https://img.shields.io/badge/adaptado%20para-Google%20Antigravity-4285F4?style=flat-square">
  <a href="https://github.com/guidocameraeq/vibe-kit"><img alt="obra original de Guido" src="https://img.shields.io/badge/obra%20original-guidocameraeq%2Fvibe--kit-d97757?style=flat-square"></a>
</p>

<p align="center">
  <b>Un método para construir y mantener proyectos con agentes de IA sin perder el control</b>, y las skills que lo vuelven mecánico.<br>
  Probado en proyectos reales: cada regla lleva escrito dónde dolió.
</p>

<p align="center">
  <a href="#cómo-funciona">Cómo funciona</a> ·
  <a href="#las-piezas">Las piezas</a> ·
  <a href="#un-día-de-trabajo">Un día de trabajo</a> ·
  <a href="#instalar">Instalar</a> ·
  <a href="#la-adaptación-a-google-antigravity-portabilidad">Portabilidad</a> ·
  <a href="#agradecimientos-y-autoría">Agradecimientos</a> ·
  <a href="GUIA-DE-USO.md">Guía de uso</a> ·
  <a href="docs/TODO.md">Hoja de ruta</a>
</p>

---

> [!NOTE]
> **Adaptación a Google Antigravity / Gemini del `vibe-kit` de Guido.** Este repositorio
> ([`jrobilara/vibe-kit-adapted`](https://github.com/jrobilara/vibe-kit-adapted), mantenido por Juan) es la
> adaptación para **Google Antigravity** del proyecto original
> [`guidocameraeq/vibe-kit`](https://github.com/guidocameraeq/vibe-kit), creado por **Guido** tras
> meses de uso real y auditorías de sesiones. Conserva íntegro el método, las plantillas de
> `/relevamiento` (creadas por Guido y aprobadas por su jefe) y las actas históricas, adaptando las reglas,
> herramientas y skills al entorno de Antigravity (`AGENTS.md`, `.agents/`, `~/.gemini/config/skills/`)
> y sumando `docs-personales` (100% MIT).

## El problema

Dirigir un agente de IA en proyectos que duran semanas funciona… hasta que se rompe, y siempre por los mismos lados:
chats eternos que se compactan y se olvidan, el "estado actual" escrito en seis lugares que se
contradicen, la misma corrección explicada diez veces, proyectos que arrancan sin plano.

**vibe-kit parte de una idea: el contexto vive en archivos, no en la conversación.** El chat se
descarta; lo que importa queda escrito y cualquier chat nuevo lo retoma. Sobre eso, un puñado de
skills que hacen el trabajo ordenado sin que tengas que acordarte.

## Cómo funciona

<p align="center">
  <img src="assets/flujo.svg" alt="Cómo se conectan las piezas: relevamiento, arquitecto, tu proyecto, observatorio, kit y equipador" width="100%">
</p>

1. **Antes de construir, un plano.** Si el pedido viene de otra persona, `/relevamiento` lo entiende
   primero; si es una idea tuya, vas directo a `/arquitecto`, que te entrevista y monta el proyecto.
2. **Cada proyecto trabaja igual**: un chat por misión, que arranca con `inicio`, consulta git en criollo con `/estado` cuando hace falta, y termina con
   `cierre`. El chat se tira; el proyecto recuerda.
3. **El sistema aprende del uso real.** El observatorio mira los chats y los tips, deja actas con
   propuestas, y lo que aprobás entra al kit. El Equipador lo lleva a cada PC.

## Las piezas

Cada pieza es una *skill*: instrucciones que Antigravity carga cuando las llamás.

| | Pieza | Qué hace |
|---|---|---|
| 📐 | **`/arquitecto`** | Piensa antes de hacer. Proyecto nuevo → entrevista, plano y montaje completo. Feature grande sobre algo que ya anda → explora el código y escribe qué cambia y qué no. ¿No sabés cómo pedir algo? → te arma el pedido |
| 📋 | **`/relevamiento`** | Cuando te piden algo en el laburo: ordena la charla en 4 documentos con un PDF por etapa, y decide con evidencia si hace falta software (construir es solo una de seis salidas) |
| 🧰 | **`/arquitecto-skills`** · el Equipador | Prepara la PC: instala las skills de un menú curado, las actualiza, diagnostica la instalación (`doctor`) y se actualiza a sí mismo (`actualizate`) |
| 🔁 | **`inicio` / `cierre` / `/estado`** | Los rituales de cada chat: arrancar sabiendo dónde quedaste, consultar en qué estado está git en criollo sin tocar nada (`/estado`), y cerrar con todo guardado, commiteado y listo para tirar el chat |
| 🛡️ | **`/redteam-spec`** | Revisor adversarial de solo-lectura para atacar planos (`SPEC-0` o spec delta) antes de marcarlos `READY` cuando tocan plata, permisos o datos sensibles |
| 🗂️ | **`/docs-personales`** | La documentación técnica de un repo (10 documentos en `docs-personales/`), sacada del código; lo que el código no sabe, te lo pregunta con opciones |
| 🔭 | **El observatorio** | Mira y anota, no toca: extrae tips de videos e investiga los chats reales para proponer mejoras ([más](observatorio/)) |

## Un día de trabajo

```text
vos          /arquitecto quiero una app para controlar los remitos del depósito
antigravity  (te entrevista de a una pregunta, te muestra el plano, y con tu OK monta el proyecto)

             ── al otro día, chat nuevo en la carpeta del proyecto ──

vos          inicio
antigravity  Estado: plano listo, nada construido · Próximo: la carga de remitos · Bloqueos: ninguno
vos          dale, arrancá con la carga de remitos
antigravity  (trabaja, prueba, te muestra la evidencia)
vos          /estado
antigravity  Rama main · último commit hace 10 min · 2 archivos tocados sin commitear · nada pendiente de push
vos          cierre
antigravity  (deja los docs al día, commitea y sube) Chat listo para descartar.
```

Las recetas para cada situación ("me pidieron algo", "quiero una feature grande", "estoy en una PC
nueva"…) están en la **[guía de uso](GUIA-DE-USO.md)**.

## Instalar

Hace falta: **Google Antigravity** funcionando y `git`.

1. Clonar este repo (`git clone https://github.com/jrobilara/vibe-kit-adapted.git`).
2. Abrir Antigravity en `kit/` y pegar el prompt de [`kit/INSTALAR.md`](kit/INSTALAR.md). Copia las
   5 skills a `~/.gemini/config/skills/`, pregunta en qué carpeta guardás tus proyectos y verifica todo.
3. Al final ofrece equipar la máquina con el menú curado de skills.

¿Ya lo tenés? Decile **`actualizate`** al Equipador y baja lo último (o **`doctor`** para chequear en 5 segundos que las 5 skills estén al día).

> [!IMPORTANT]
> **La regla de la casa:** este repo es la fuente; `~/.gemini/config/skills/` es una copia. Los cambios se hacen en
> `kit/` y se sincronizan con `.agents/scripts/kit-sync.ps1 sync`; nunca se edita `~/.gemini/config/skills/` directo.

## La adaptación a Google Antigravity (portabilidad)

El detalle técnico completo vive en [`docs/PORTABILIDAD-ANTIGRAVITY.md`](docs/PORTABILIDAD-ANTIGRAVITY.md) y el plano de construcción en [`docs/SPEC-adaptacion-antigravity.md`](docs/SPEC-adaptacion-antigravity.md) (ADR-024). Acá tenés el resumen de qué se adaptó y qué pasos se ejecutaron:

### 1. Equivalencias de plataforma

| Concepto en el método original | Adaptación en Google Antigravity | Ubicación en este repo |
|---|---|---|
| Reglas de comportamiento del proyecto | `AGENTS.md` | [`AGENTS.md`](AGENTS.md), [`observatorio/extractor/AGENTS.md`](observatorio/extractor/AGENTS.md) y [`AGENTS.template.md`](kit/skills/arquitecto/templates/universales/AGENTS.template.md) |
| Lectura automática de estado al abrir sesión | Regla `trigger: always_on` | [`.agents/rules/inicio-sesion.md`](.agents/rules/inicio-sesion.md) y template universal |
| Skills locales de cada proyecto | `.agents/skills/<skill>/SKILL.md` | [`.agents/skills/`](.agents/skills/) (`inicio`, `cierre`, `estado`) |
| Skills globales de la máquina | `~/.gemini/config/skills/` | Fuente canónica en [`kit/skills/`](kit/skills/) |
| Entrevista interactiva por opciones | Herramienta `ask_question` (`is_multi_select`) | `/arquitecto`, `/arquitecto-skills`, `/relevamiento`, `/docs-personales` |
| Gate de aprobación antes de construir | Modo Planning + artifact `implementation_plan.md` (`RequestFeedback=true`) | [`kit/skills/arquitecto/SKILL.md`](kit/skills/arquitecto/SKILL.md) (Pasos 4 y B) |
| Orquestación de subagentes y ramas | `invoke_subagent`, `send_message`, `Workspace: "branch" \| "share"`, Reactive Wakeup | [`kit/skills/arquitecto/anexos/consultorio.md`](kit/skills/arquitecto/anexos/consultorio.md) y `/redteam-spec` |

### 2. Pasos realizados en la portabilidad v2

1. **Adopción íntegra de la estructura de Misión 3:** se organizó el repositorio con [`observatorio/`](observatorio/) (`extractor/` e `investigacion/`), [`manuales/`](manuales/), [`docs/consulta/`](docs/consulta/), [`docs/TODO.md`](docs/TODO.md) y [`docs/CHANGELOG.md`](docs/CHANGELOG.md), actualizando los scripts de medición (`repos.py`, `flota.py`, `huella.py`) para inspeccionar proyectos tanto de Antigravity como de Claude Code.
2. **Incorporación de las mejoras cerradas de Misión 4 (Diseños A y C):**
   - **Diseño A (Frenos y correctores):** `AGENTS.md` y `AGENTS.template.md` incluyen de fábrica las **4 preguntas en humano** antes de toda acción irreversible (qué cambia, qué se puede perder, cómo se vuelve atrás, si toca algo que hoy anda) y el **corrector contra git destructivo** (prohibición de `reset --hard`, `clean -f`, `push --force` y `stash`).
   - **Diseño C (Estado determinístico):** se creó la skill universal `/estado` junto con el script [`.agents/scripts/estado-git.ps1`](.agents/scripts/estado-git.ps1) (y `.sh`), que extrae en JSON determinístico la rama, último commit, pendientes de push y archivos modificados para informar en criollo sin adivinar.
3. **Sincronización mecánica multi-PC (`kit-sync`) y `Modo DOCTOR`:**
   - [`.agents/scripts/kit-sync.ps1`](.agents/scripts/kit-sync.ps1) (y `.sh`) compara y sincroniza las 5 skills canónicas (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) hacia `~/.gemini/config/skills/`, preservando la carpeta de proyectos configurada en cada PC mientras en el repo se mantiene el placeholder `{{CARPETA_DE_PROYECTOS}}`.
   - El Equipador (`/arquitecto-skills`) incorpora el **`Modo DOCTOR`** (diagnóstico rápido de solo-lectura) y un esquema de **dos remotos** (`origin` para este fork adaptado y `upstream` apuntando al repositorio original de Guido).
4. **Documentación técnica `/docs-personales` (100% MIT) y menú actualizado:** se integró la skill [`kit/skills/docs-personales/`](kit/skills/docs-personales/) para generar y auditar 10 documentos técnicos regenerables por repositorio bajo licencia 100% MIT, y se sumó `android-cli` al menú curado de [`menu-skills.md`](kit/skills/arquitecto-skills/menu-skills.md).
5. **Preservación estricta de fuentes y actas históricas:** las 4 plantillas originales de [`kit/skills/relevamiento/plantillas/_fuente/`](kit/skills/relevamiento/plantillas/_fuente/) y la totalidad de las actas de investigación ([`tips/`](tips/), [`docs/mision-4/`](docs/mision-4/), [`legacy/`](legacy/)) se mantuvieron 100% intactas (0 bytes modificados).

## Principios

- **El contexto vive en archivos.** Un chat por misión; el que retoma lee, no recuerda.
- **Cada regla lleva su cicatriz.** Nada entra sin la evidencia de dónde dolió.
- **Lo mecánico frena; la prosa no.** Lo que se sigue rompiendo escrito en prosa se vuelve script, regla
  o campo obligatorio.
- **Evidencia o "no verificado".** Nunca "listo" a secas.
- **Vos decidís.** Las herramientas proponen con opciones y una recomendación; nada se aplica sin tu OK.

## En qué anda

- 🧭 **Hoja de ruta y pendientes:** [`docs/TODO.md`](docs/TODO.md)
- 🔄 **Documentación de portabilidad:** [`docs/PORTABILIDAD-ANTIGRAVITY.md`](docs/PORTABILIDAD-ANTIGRAVITY.md) y [`docs/SPEC-adaptacion-antigravity.md`](docs/SPEC-adaptacion-antigravity.md)
- 📜 **Qué cambió y cuándo:** [`docs/CHANGELOG.md`](docs/CHANGELOG.md) · **por qué es como es:**
  [`docs/DECISIONS.md`](docs/DECISIONS.md) · **para qué existe:** [`docs/MISION-Y-VISION.md`](docs/MISION-Y-VISION.md)

<details>
<summary><b>Qué hay en cada carpeta</b></summary>

| Carpeta / archivo | Qué es |
|---|---|
| [`GUIA-DE-USO.md`](GUIA-DE-USO.md) | Recetas por situación y frases para decirle a Antigravity. **Empezá por acá** |
| [`PLAYBOOK-MAESTRO.md`](PLAYBOOK-MAESTRO.md) | El método completo: documentación y sistema de trabajo, con su porqué |
| [`kit/`](kit/) | **La fuente** de lo instalable: las 5 skills (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) y el instalador |
| [`manuales/`](manuales/) | El detalle a fondo de cada pieza |
| [`observatorio/`](observatorio/) | El Extractor de tips y la investigación de chats |
| [`tips/`](tips/) | Las actas del observatorio, con propuestas para aprobar |
| [`docs/`](docs/) | Pendientes, historia, decisiones, descartes y planos ([índice](docs/README.md)) |
| [`assets/`](assets/) | El banner y los diagramas |
| [`legacy/`](legacy/) | Lo superado, archivado con su lápida (no se borra) |
| `AGENTS.md` · `.agents/` | Las reglas para Antigravity en este repo, sus rituales (`inicio`, `cierre`, `estado`) y los scripts (`kit-sync`, `estado-git`) |

</details>

## Agradecimientos y autoría

Un agradecimiento especial a **Guido** ([`@guidocameraeq`](https://github.com/guidocameraeq)), creador y autor original de **[`guidocameraeq/vibe-kit`](https://github.com/guidocameraeq/vibe-kit)**:

- **El método y la filosofía de trabajo** ("el contexto vive en archivos, no en la conversación", "cada regla lleva su cicatriz", "lo mecánico frena; la prosa no") nacieron de sus auditorías reales en Hermes y Perseo y de su investigación empírica de sesiones (Misiones 1 a 4).
- **El diseño del Arquitecto (`/arquitecto`), el Equipador (`/arquitecto-skills`), el Playbook Maestro y el Observatorio** son obra suya y constituyen la base íntegra sobre la que corre esta adaptación.
- **El método de 4 etapas de `/relevamiento` ("Cómo Arrancar un Proyecto") y sus plantillas originales** en [`kit/skills/relevamiento/plantillas/_fuente/`](kit/skills/relevamiento/plantillas/_fuente/) fueron creados por Guido y aprobados por su jefe.

**Adaptación a Google Antigravity / Gemini, scripts PowerShell y `/docs-personales`:** **Juan** ([`@jrobilara`](https://github.com/jrobilara)).

## Licencia

Distribuido íntegramente bajo licencia **[MIT](LICENSE)** (ver aviso de atribución en [`NOTICE`](NOTICE)).
