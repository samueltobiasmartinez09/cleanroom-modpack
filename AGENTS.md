# Agent Context - Cleanroom Modpack

## Goal
Mantener modpack CleanroomMC 1.12.2 con packwiz: JRE Zulu 25 CRaC descargado via script al primer launch (NO en repo, NO en zips), Celeritas como renderer requerido, scripts switch que instalan OptiFine externamente.

## Arquitectura final
- **JRE descargado al primer launch**: `install-java.sh`/`.bat` usa API de Azul para obtener Zulu 25 CRaC (Linux) o Zulu 25 JRE (Win/Mac), extrae a `minecraft/jre25/`
- **3 zips pequeños** (~5MB, sin JRE) construidos solo con repo + scripts nativos filtrados
- **CI solo commitea** al repo: mmc-pack.json (check-cleanroom-update.yml)
- **packwiz-installer** en runtime descarga los mods más recientes del repo
- **Los zips nunca se reconstruyen automáticamente** — usuarios descargan 1 vez, packwiz actualiza los mods

## Cómo funciona
1. Usuario descarga zip de plataforma (contiene repo + scripts + packwiz-installer-bootstrap.jar)
2. `pre-launch.sh`/`.bat` → llama `install-java.sh`/`.bat` (descarga JRE si no existe) → `jre25/bin/java` → packwiz-installer → mods + Minecraft
3. **Wrapper script** en `JavaPath`: `java-wrapper.sh` descarga JRE al detection time de Prism, así Prism ve Java 25 y lo usa para Minecraft también
4. Scripts switch: `switch-to-optifine`/`switch-to-celeritas` (wildcards version-agnostic)

## Problemas detectados en tests (v1.0.0-linux.zip)
### Problema 1: `packwiz-installer-bootstrap.jar` no está en el zip
- **Causa**: build-zips.sh usa `git clone` → solo archivos trackeados. El jar no estaba trackeado → no aparece en zips.
- **Fix A (elegido)**: Trackear el jar en git (excepción en `.gitignore`), ya que packwiz-installer-bootstrap ya no se actualiza.

### Problema 2: Java wrapper para detection time de Prism
- **Causa**: `JavaPath=./minecraft/jre25/bin/java` no existe al detection time (el JRE se descarga en pre-launch, que ocurre DESPUÉS de la detección). Prism falla a jre-legacy → usa Java 8 u otro.
- **Fix**: Wrapper script `minecraft/jre25/java-wrapper.sh` como `JavaPath`. Prism llama al wrapper para detectar versión → wrapper descarga JRE si no existe → `exec bin/java -version`. Luego Prism llama al mismo wrapper para lanzar Minecraft → wrapper ve JRE existente → `exec bin/java` con args de MC.

## State Actual
- JRE Zulu 25.0.3 CRaC descargado via script al runtime, no en repo ni zips
- Celeritas mods REQUERIDOS (no optional)
- OptiFine/NotFine eliminados del pack, se instalan externamente via scripts switch
- `.packwizignore` excluye `.github/`, `scripts/`, `packwiz`, `.github_token`, `AGENTS.md`, `minecraft/jre25/`
- 9 scripts estáticos en `minecraft/` con wildcards (+ java-wrapper.sh)
- `packwiz-installer-bootstrap.jar` **trackeado en git**, viene en zips

## Mod Sources
- 69 mods en CurseForge (`mode = "metadata:curseforge"`)
- Celeritas-related migrados a CurseForge excepto celeritas-forge que va a GitHub kappa-maintainer
- 3 assets propios mantienen GitHub Release: `Fix_Textures_OptiFine.zip`, `Fix_Vintage_Vainilla.zip`, `SEUS-Renewed-v1.0.1.zip`

## Git State
- Branch: main
- Remote: https://github.com/samueltobiasmartinez09/cleanroom-modpack.git
- Token: `.github_token` (local, ignorado por git via `.gitignore`, no trackeado)
- Release v1.0.0 creada en GitHub con 6 assets: 3 propios + 3 zips de plataforma

## Scripts en minecraft/
| Archivo | Contenido |
|---|---|
| `minecraft/pre-launch.sh` | Llama install-java.sh, luego packwiz-installer con jre25 |
| `minecraft/pre-launch.bat` | Ídem Windows |
| `minecraft/install-java.sh` | Descarga Zulu 25 CRaC (Linux) o JRE (macOS) desde API de Azul, extrae a jre25/ |
| `minecraft/install-java.bat` | Ídem Windows con PowerShell |
| `minecraft/jre25/java-wrapper.sh` | Wrapper llamado por Prism como JavaPath; descarga JRE si no existe y exec bin/java |
| `minecraft/switch-to-optifine.sh` | Descarga OptiFine/NotFine, deshabilita Celeritas con wildcards |
| `minecraft/switch-to-optifine.bat` | Ídem Windows |
| `minecraft/switch-to-celeritas.sh` | Elimina OptiFine/NotFine, restaura Celeritas con wildcards |
| `minecraft/switch-to-celeritas.bat` | Ídem Windows |

## Construcción de zips (scripts/build-zips.sh)
1. Clonar repo, limpiar scripts/ .github/ + packwiz/ AGENTS.md
2. Filtrar scripts nativos: Linux/macOS → solo .sh, Windows → solo .bat
3. Windows: cambiar PreLaunchCommand en instance.cfg a cmd.exe
4. Eliminar .git/ antes de zipear
5. Subir a Release con --clobber

## Relevant Files
- `.github/workflows/check-cleanroom-update.yml`
- `.packwizignore` - exclude .github/, scripts/, packwiz, .github_token, AGENTS.md, minecraft/jre25/
- `.gitignore` - exclude .github_token + minecraft/jre25/; trackea 9 scripts + jar + build-zips.sh
- `minecraft/pre-launch.sh` / `.bat`
- `minecraft/install-java.sh` / `.bat`
- `minecraft/jre25/java-wrapper.sh` — JavaPath wrapper
- `minecraft/packwiz-installer-bootstrap.jar` — trackeado en git
- `minecraft/switch-to-optifine.sh` / `.bat`
- `minecraft/switch-to-celeritas.sh` / `.bat`
- `scripts/build-zips.sh`
- `mods/celeritas-auto-build.pw.toml` - GitHub kappa-maintainer
- `mods/celeritas-dynamic-lights.pw.toml` - CurseForge
- `mods/celeritas-extra.pw.toml` - CurseForge v0.6.1
- `mods/celeritasleafculling.pw.toml` - CurseForge
- `mods/threading-entity-mod.pw.toml` - CurseForge
- `mods/mixin-booter.pw.toml` - CurseForge MixinBooter v11.2
- `resourcepacks/fix-textures-optifine.pw.toml` - GitHub Release
- `resourcepacks/fix-vintage-vainilla.pw.toml` - GitHub Release
- `shaderpacks/seus-renewed.pw.toml` - GitHub Release
