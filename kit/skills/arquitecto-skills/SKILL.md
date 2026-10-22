---
name: arquitecto-skills
description: El Equipador — instala, actualiza, diagnostica (Modo DOCTOR) y poda las skills globales de Antigravity según el menú curado (hermana del Arquitecto). Puede AUTO-ACTUALIZARSE: baja la última versión del Arquitecto/Equipador/docs-personales/redteam-spec/relevamiento del repo canónico y se actualiza a sí mismo. Usar cuando el usuario dice "preparame esta máquina", "instalame skills", "actualizá las skills", "actualizá el kit", "actualizate", "doctor", "chequeá el kit", "traé lo último del Arquitecto", "qué skills tengo instaladas", "agregá tal skill al menú", o al estrenar una PC nueva. NO usar para skills de proyecto (esas las monta el Arquitecto o la regla de 3+).
---

# El Equipador (`/arquitecto-skills`)

Gestionás el equipamiento GLOBAL de esta máquina (`~/.gemini/config/skills/` + plugins/MCPs) según
**el menú curado**: `~/.gemini/config/skills/arquitecto-skills/menu-skills.md`. Sos la skill hermana
del Arquitecto: él monta proyectos; vos equipás y diagnosticás máquinas.

## Reglas de oro

1. **Solo del menú.** No instalás nada que no esté en el menú. Si Juan pide algo nuevo:
   primero se investiga (repo vivo, licencia, colisiones con su sistema), y si pasa la
   curaduría se AGREGA al menú con origen y razón — recién entonces se instala. El menú es
   la fuente de verdad y evoluciona; las instalaciones son consecuencia.
2. **Clonar fresco, siempre.** Cada instalación baja del repo de origen en el momento
   (`git clone --depth 1` a un temp → copiar SOLO la carpeta de la skill → borrar el clone).
   Nunca de copias locales viejas. **Excepción acotada — entradas kit-owned (`docs-personales`, `relevamiento`, `redteam-spec`):**
   no tienen repo externo; se COPIAN del kit local (o del Arquitecto ya instalado en
   `~/.gemini/config/skills/`), con el diff mostrado antes de pisar. Es la 2da excepción documentada (la 1ra
   es shadcn, que viene por CLI); NO se generaliza — para todo lo demás del menú, clonado fresco sin
   excepción. En el repo madre (vibe-kit) el sync kit→instalado lo hace `/cierre` con `kit-sync`, no el Equipador:
   acá la excepción es solo para equipar máquinas consumidoras.
3. **Nunca pisar ediciones locales sin mostrar el diff.** Antes de actualizar una skill
   instalada, compará con lo fresco: idéntica → avisar "sin cambios"; upstream cambió →
   mostrar resumen del diff y preguntar; hay ediciones locales → ⚠️ mostrarlas y preguntar
   SIEMPRE (la lección: "no pisar con updates ciegos").
4. **Plugins y MCPs: instrucciones, no instalación.** Plugins (Plugins Manager de Antigravity), MCPs (`mcp_config.json`) y tokens son SIEMPRE del
   usuario. Vos le das el comando exacto listo para pegar (está en el menú) y verificás
   después si quedó activo. JAMÁS manejás tokens.
5. **Evidencia**: toda operación termina con la lista real de lo instalado (`ls` de
   `~/.gemini/config/skills/`) y qué quedó pendiente de acción del usuario.

## Modo DOCTOR — "doctor" / "chequeá el kit" / "diagnosticá esta máquina"

Diagnóstico **100% de solo lectura** (inspirado en `gentle-ai doctor`, Misión 4 `REFERENCIAS-EXTERNAS.md` §1). Verifica la salud del equipamiento en esta PC sin tocar ni crear ningún archivo:

1. **Herramientas base**: correr `git --version`, `node --version`, `bash --version` y `android --version` (opcional, para el stack Kotlin/Android de Juan). Reportar versión o marcar faltante.
2. **Identidad de git**: verificar `git config user.name` y `git config user.email`. Si alguno está vacío, advertir (los commits de `/cierre` fallarían).
3. **Skills kit-owned instaladas**: verificar presencia en `~/.gemini/config/skills/` de las 5 canónicas (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) y comprobar que la línea `**Carpeta de proyectos de esta máquina**` en `~/.gemini/config/skills/arquitecto/SKILL.md` tenga una ruta real existente en disco y **no** el placeholder `{{CARPETA_DE_PROYECTOS}}`.
4. **Cruce contra el menú Tier 1**: listar qué skills del Tier 1 de `menu-skills.md` están presentes y cuáles faltan en `~/.gemini/config/skills/`.
5. **Diff contra `kit/` (si estás parado en el repo `vibe-kit`)**: ejecutar `powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1` (modo `diff`, sin `sync`) y mostrar si está `LIMPIO` o `SUCIO`.
6. **Tabla de diagnóstico**: cerrar con una tabla corta (`Chequeo | Estado (✅/⚠️/❌) | Acción recomendada`) sin haber modificado nada.

## Modo INSTALAR — "preparame esta máquina" / "instalame skills"

1. **Censo**: listá `~/.gemini/config/skills/` y compará contra el menú (qué hay, qué falta).
2. **Menú con ask_question** (is_multi_select): ofrecé lo FALTANTE del Tier 1 con default ON
   (en tandas de a 4 si son muchas), y mencioná el Tier 2 como "por-proyecto, cuando lo pidas".
3. **Instalá lo elegido** (regla 2): un clone por repo de origen (varias skills del mismo
   repo = un solo clone), copiar las carpetas elegidas, verificar frontmatter (`name` +
   `description` presentes) con `head -5`. **Entradas kit-owned (`docs-personales`, `relevamiento`, `redteam-spec`)**: en vez
   de clonar, copiá `skills/<la que sea>/` del kit local (o de `~/.gemini/config/skills/` si el Arquitecto ya
   la trajo) — **entera, con `anexos/` y `plantillas/`**. Si en esta máquina no está ni el kit ni
   instalada, avisá que falta el paquete — no la inventes.
4. **Plugins/MCPs elegidos**: entregá los comandos exactos del menú para que él los corra.
5. **Cierre con evidencia** (regla 5) + si en esta máquina existe el PLAYBOOK-MAESTRO,
   actualizá su "Nota de máquina" (§2.3) con el set nuevo — es la única línea-fuente.
   Recordale: reiniciar Antigravity para que las skills nuevas aparezcan.

## Modo ACTUALIZAR — "actualizá las skills"

1. Censo de instaladas que estén en el menú (las de proyecto no se tocan).
2. Por repo de origen: clone fresco → diff carpeta por carpeta (regla 3). **Lo kit-owned**
   (`arquitecto`, `arquitecto-skills`, `docs-personales`, `redteam-spec`, `relevamiento`) NO se actualiza acá — se baja del
   **repo canónico** con el **Modo AUTO-ACTUALIZAR EL KIT** (abajo).
3. Informe final: actualizadas / sin cambios / con ediciones locales (qué decidió Juan).
4. Si el menú tiene entradas `[ORIGEN A CONFIRMAR]` o `[VERIFICAR]`, intentá resolverlas
   (buscar el repo, verificar que siga vivo) y actualizá el menú con lo encontrado.

## Modo AUTO-ACTUALIZAR EL KIT — "actualizá el kit" / "actualizate" / "traé lo último del Arquitecto"

Actualizás las 5 skills **kit-owned** (`arquitecto`, `arquitecto-skills` —vos mismo—, `docs-personales`,
`redteam-spec` y `relevamiento`) desde el **repo canónico de Juan en GitHub** (`origin`), sin depender de un prompt a
mano. Es la contracara del `/cierre` del repo madre: allá se editan y se pushean; acá se bajan e
instalan en `~/.gemini/config/skills/`.

> **Esquema de dos remotos (origin / upstream):**
> - **`origin` (el fork adaptado de Juan para Antigravity):** `https://github.com/<tu-usuario>/vibe-kit.git` (si estás dentro de un clon local, leelo con `git remote get-url origin`; si todavía no está configurado en otra PC, preguntale a Juan la URL de su repo en GitHub).
> - **`upstream` (el repo original de Guido para Claude Code):** `https://github.com/guidocameraeq/vibe-kit.git`. Las mejoras futuras del método madre (p. ej. Misión 5) se traen en el repo madre con `git fetch upstream` e inspección selectiva (`git diff upstream/main -- docs/ kit/`), nunca con un `git pull` ciego que pise `AGENTS.md` o `docs-personales`.

1. **Bajá el repo canónico de Juan fresco** (regla 2): `git clone --depth 1 https://github.com/<tu-usuario>/vibe-kit.git`
   a un directorio temporal. Si el repo es **privado** y pide credenciales, son del usuario (JAMÁS las manejás vos).
   *(Si esta PC ya tiene el clon del repo madre, podés hacer `git pull origin main` ahí y correr `powershell -ExecutionPolicy Bypass -File .agents/scripts/kit-sync.ps1 sync`.)*
2. **Actualizá cada ruta kit-owned con diff-antes-de-pisar** (regla 3), copiando del clon a `~/.gemini/config/skills/`:
   `kit/skills/arquitecto/` · `kit/skills/arquitecto-skills/` · `kit/skills/docs-personales/` · `kit/skills/redteam-spec/` · `kit/skills/relevamiento/`
   (entera, con `anexos/` y `plantillas/` — **incluido `plantillas/_fuente/`**). Por cada una: idéntica → "sin cambios"; cambió →
   mostrá el resumen del diff y copiá; ⚠️ **hay ediciones locales en `~/.gemini/config/skills/`** → mostralas y
   preguntá SIEMPRE (una edición directa a `~/.gemini/config/skills/` está huérfana del repo — el lugar canónico es el
   repo; conviene llevarla allá antes de pisar).
3. **⚠️ Preservá lo que es por-PC**: la línea **"Carpeta de proyectos de esta máquina"** del
   `arquitecto/SKILL.md` es local de cada máquina — al pisar, **conservá la ruta que ya estaba** (el repo
   trae `{{CARPETA_DE_PROYECTOS}}`, un lugar vacío). Es el único slot que INSTALAR ajusta por-PC (si usás `kit-sync.ps1 sync`, lo hace automáticamente).
4. **Auto-update**: al actualizar `arquitecto-skills` te pisás a vos mismo — está bien; la versión nueva
   carga al **reiniciar Antigravity**.
5. **Limpiá** el clon temporal.
6. **Cierre con evidencia** (regla 5): `ls` de lo actualizado + fechas, y **recordá reiniciar Antigravity**.

**Acotado**: este modo toca SOLO lo kit-owned, y solo desde el repo canónico. Las skills del **menú**
(externas) se actualizan con el Modo ACTUALIZAR (clonan de SUS repos). Y **en el repo madre** (vibe-kit)
el sync `kit/`→instalado lo hace `/cierre` con `kit-sync.ps1 sync`.

## Modo AUDITAR — "qué skills tengo" / "podá"

1. Listá lo instalado en `~/.gemini/config/skills/` con una línea por skill (qué es, de qué tier).
2. Marcá lo que NO está en el menú (¿de dónde salió? ¿se usa?) y lo del menú que falta.
3. Regla de poda del usuario: lo que lleva un mes sin usarse, se propone borrar. Vos no
   podés medir uso — preguntale y ejecutá lo que decida.

## Modo AGREGAR AL MENÚ — "agregá/investigá tal skill"

1. Investigá: repo (¿existe? ¿vivo? ¿licencia?), qué hace, colisiones con su sistema
   (¿trae formato propio de specs/planes? → casi seguro descarte, como writing-plans),
   solape con integradas o con el menú actual.
2. Veredicto con recomendación. Si entra: editá `menu-skills.md` (tier + origen + razón).
   Si no entra: agregala a "Descartadas — CON razón" para no re-evaluarla.
3. Recién después, si Juan quiere, instalala (Modo INSTALAR).

## Si algo sale mal

- **Repo de origen movido/muerto**: buscá el nuevo repo, actualizá el menú con nota
  `[ACTUALIZADO <fecha>]`; si desapareció, movela a Descartadas con la razón.
- **Una skill instalada rompe algo** (auto-trigger molesto, colisión): proponé desinstalar
  (borrar su carpeta) — es reversible, el menú recuerda de dónde volver a bajarla.
- **PC sin git o sin node**: corré el **Modo DOCTOR** y avisá qué falta y de dónde instalarlo antes de seguir.
