# El Arquitecto — instalación automática en esta PC

> **Cómo se usa**: descomprimí el zip (o cloná el repo) en cualquier carpeta → abrí Antigravity **en esa carpeta**
> (VSCode: Archivo → Abrir carpeta → chat de Antigravity; o en terminal, parado ahí: `agy`) →
> pegá el prompt de abajo tal cual. Antigravity instala todo, te pregunta lo único que necesita
> saber, y te confirma con evidencia. ~2 minutos.

---

## El prompt (copiá TODO el bloque de abajo)

```
Instalá el paquete "El Arquitecto" que está en esta carpeta:

1. Verificá que acá estén skills/arquitecto/SKILL.md, skills/arquitecto-skills/SKILL.md
   y skills/redteam-spec/SKILL.md. Si falta alguno, frená y avisame.
2. Copiá skills/arquitecto/ COMPLETA (con anexos/ y templates/),
   skills/arquitecto-skills/ (con su menu-skills.md) y skills/redteam-spec/ a las skills
   globales de esta máquina: ~/.gemini/config/skills/ (creá las carpetas que no existan).
   Y skills/docs-personales/ y skills/relevamiento/ SI están presentes en esta carpeta
   (son kit-owned; si el zip es viejo y no las trae, salteálas sin frenar — NO
   son requisito duro del paso 1). De relevamiento copiá la carpeta ENTERA:
   anexos/ y plantillas/, incluido plantillas/_fuente/.
   Si ya hay versiones instaladas, mostrame las fechas y preguntame antes de pisar.
3. Preguntame con opciones dónde guardo mis proyectos en ESTA máquina
   (ej: E:/Proyectos/AI Projects, D:\SAAS, Desktop\Proyectos, otra) y en la línea
   "Carpeta de proyectos de esta máquina" del SKILL.md del arquitecto
   recién instalado reemplazá {{CARPETA_DE_PROYECTOS}} por esa ruta.
4. Verificá con evidencia real: (a) listá los archivos instalados,
   (b) mostrame la línea de carpeta de proyectos ya editada, (c) chequeá que
   node --version, bash --version y git --version anden — los proyectos que el
   Arquitecto monta usan scripts y el Equipador clona repos;
   si falta alguno, decime qué instalar y de dónde. (d) chequeá que git tenga
   identidad (git config user.name) — si está vacía, preguntame nombre y email
   y configurala global: sin eso, los commits de /cierre fallan en esta máquina.
5. Al final, ofreceme equipar la máquina: corré el modo INSTALAR de
   /arquitecto-skills (el menú curado de skills universales, con is_multi_select).
6. Cerrá con el resumen de lo instalado y recordame: reiniciar Antigravity
   y probar /arquitecto en un chat nuevo.

No toques nada más de esta máquina. No borres esta carpeta (queda de backup).
```

---

## Plan B — instalación a mano (por si preferís no usar el prompt)

1. `skills/arquitecto/`, `skills/arquitecto-skills/`, `skills/redteam-spec/` (y `skills/docs-personales/` y `skills/relevamiento/` si están) → copiar adentro de `C:\Users\<usuario>\.gemini\config\skills\`
2. Abrir `C:\Users\<usuario>\.gemini\config\skills\arquitecto\SKILL.md` y en la línea **"Carpeta de proyectos de esta máquina"** reemplazar `{{CARPETA_DE_PROYECTOS}}` por la carpeta donde viven tus proyectos
3. Reiniciar Antigravity → `/arquitecto` para proyectos, `/arquitecto-skills` para equipar la máquina (o `doctor` para diagnosticar el entorno)

## Qué es este paquete

Cinco piezas que trabajan juntas. Autocontenido.

**El Arquitecto** (`/arquitecto`) — pensar ANTES de hacer, con tres puertas: **proyecto nuevo**
(entrevista con opciones, piensa lo que no ves venir: roles, listas configurables, multi-tenant ⚠️,
i18n ⚠️; plano SPEC-0 con gate de aprobación real + monta el proyecto completo: `AGENTS.md` con las 4 preguntas al humano y corrector de git destructivo, docs, skills `/inicio`, `/estado` y `/cierre`, scripts `estado-git`, regla `inicio-sesion` y primer commit), **feature sobre una app que ya anda** (explora tu código real → spec delta con su "NO SE TOCA"), y **consultorio** (cómo pedirle algo a Antigravity y cómo delegar a subagentes).

**El Equipador** (`/arquitecto-skills`) — instala las skills del menú curado, tiene **Modo DOCTOR** de diagnóstico sin escritura, y sabe auto-actualizarse desde el repo canónico.

**`redteam-spec`** — revisor adversarial de specs antes de pasarlos a `READY`.

**`/relevamiento`** — el tramo de ANTES del Arquitecto, para cuando el pedido **vino de otra
persona**: convierte una charla dictada en los 4 documentos del método de arranque, emite un PDF al
cerrar cada etapa, y decide con evidencia si eso termina en software o no. En proyectos personales no
aparece nunca.

**`/docs-personales`** — la documentación técnica personal por repositorio: los 10 artefactos de documentación técnica personal, generados desde el código.
