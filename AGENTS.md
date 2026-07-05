# Agent Context - Cleanroom Modpack

## Goal
Mantener modpack CleanroomMC 1.12.2 con packwiz: JRE Zulu 25 bundleado (NO en packwiz, solo en zips), Celeritas como renderer requerido, scripts switch que instalan OptiFine externamente.

## State Actual
- JRE Zulu 25.0.3 CRaC **no trackeado en git ni en packwiz** — solo va bundleado en los zips de plataforma
- Celeritas mods REQUERIDOS (no optional)
- OptiFine/NotFine eliminados del pack, se instalan externamente via scripts switch
- `.packwizignore` excluye `.github/`, `scripts/`, `packwiz`, `.github_token`, `AGENTS.md`, `minecraft/jre25/`
- 6 scripts estáticos en `minecraft/` con wildcards (version-agnostic)
- `packwiz-installer-bootstrap.jar` debe ir en `minecraft/` (no trackeado, el usuario lo coloca)
- `pre-launch.sh` usa `$(dirname "$0")/jre25/bin/java` en vez de `$INST_JAVA` (evita problemas de resolución de Prism)
- `check-zulu-update.yml` eliminado — JRE pinneado a versión actual, no se actualiza por CI

## Mod Sources
- 69 mods en CurseForge (`mode = "metadata:curseforge"`)
- Celeritas-related migrados a CurseForge excepto celeritas-forge que va a GitHub kappa-maintainer
- 3 assets propios mantienen GitHub Release: `Fix_Textures_OptiFine.zip`, `Fix_Vintage_Vainilla.zip`, `SEUS-Renewed-v1.0.1.zip`

## Git State
- Branch: main
- Remote: https://github.com/samueltobiasmartinez09/cleanroom-modpack.git
- Token: `.github_token` (local, ignorado por git via `.gitignore`, no trackeado)
- Release v1.0.0 creada en GitHub con 6 assets: 3 propios + 3 zips de plataforma

## Changes Completed
1. **celeritas-forge** → GitHub kappa-maintainer (`celeritas-auto-build.pw.toml`)
2. **celeritasdynamiclights** → CurseForge (`celeritas-dynamic-lights.pw.toml`)
3. **celeritasextra** → CurseForge v0.6.1 (`celeritas-extra.pw.toml`)
4. **celeritasleafculling** → CurseForge (`celeritasleafculling.pw.toml`)
5. **entitythreading** → CurseForge (`threading-entity-mod.pw.toml`) + MixinBooter dep
6. **logcleaner**, **missingvariantaccessfix** eliminados
7. **.github_token** removido de tracking, historia git limpiada
8. **6 scripts estáticos** en `minecraft/` con wildcards (pre-launch, switch-optifine, switch-celeritas) — cross-platform
9. **Workflows**: `check-cleanroom-update.yml` solo commitea mmc-pack.json; `check-zulu-update.yml` eliminado
10. **JREs**: removidos de packwiz y de git — solo van en los 3 zips de plataforma
11. **3 zips** construidos con JREs descargados de Azul, scripts filtrados por OS, subidos a Release v1.0.0
12. **pre-launch.sh/.bat** corregidos: usan `dirname $0`/`%~dp0` para encontrar JRE bundleado y packwiz-installer-bootstrap.jar

## Arquitectura final
- **3 zips** (linux/windows/macos) construidos 1 vez manualmente, cada uno con su JRE nativo y scripts nativos
- **CI solo commitea** al repo: mmc-pack.json (check-cleanroom-update.yml)
- **packwiz-installer** en runtime descarga los mods más recientes del repo
- **JRE fijo** — no se actualiza vía CI, va solo en los zips
- **Los zips nunca se reconstruyen automáticamente** — usuarios descargan 1 vez, packwiz actualiza los mods

## Scripts en minecraft/
| Archivo | Contenido |
|---|---|
| `minecraft/pre-launch.sh` | Ejecuta packwiz-installer con jre25 bundleado y dirname |
| `minecraft/pre-launch.bat` | Ídem Windows con %~dp0 |
| `minecraft/switch-to-optifine.sh` | Descarga OptiFine/NotFine, deshabilita Celeritas con wildcards |
| `minecraft/switch-to-optifine.bat` | Ídem Windows |
| `minecraft/switch-to-celeritas.sh` | Elimina OptiFine/NotFine, restaura Celeritas con wildcards |
| `minecraft/switch-to-celeritas.bat` | Ídem Windows |

## Construcción de zips (script local)
1. Descargar JREs Win/Mac desde Azul API (Linux JRE se descarga igual, no hay en repo)
2. Copiar repo base, reemplazar minecraft/jre25/ por cada JRE nativo
3. Incluir solo scripts nativos: Linux/macOS → .sh, Windows → .bat
4. Windows: cambiar PreLaunchCommand a cmd.exe
5. Subir los 3 zips a Release v1.0.0

## Relevant Files
- `.github/workflows/check-cleanroom-update.yml` - workflow cleanroom
- `.packwizignore` - exclude .github/, scripts/, packwiz, .github_token, AGENTS.md, minecraft/jre25/
- `.gitignore` - exclude .github_token + minecraft/jre25/ + Win/Mac JREs; solo trackea scripts en minecraft/
- `minecraft/pre-launch.sh`
- `minecraft/pre-launch.bat`
- `minecraft/switch-to-optifine.sh`
- `minecraft/switch-to-optifine.bat`
- `minecraft/switch-to-celeritas.sh`
- `minecraft/switch-to-celeritas.bat`
- `mods/celeritas-auto-build.pw.toml` - GitHub kappa-maintainer
- `mods/celeritas-dynamic-lights.pw.toml` - CurseForge
- `mods/celeritas-extra.pw.toml` - CurseForge v0.6.1
- `mods/celeritasleafculling.pw.toml` - CurseForge
- `mods/threading-entity-mod.pw.toml` - CurseForge
- `mods/mixin-booter.pw.toml` - CurseForge MixinBooter v11.2
- `resourcepacks/fix-textures-optifine.pw.toml` - GitHub Release
- `resourcepacks/fix-vintage-vainilla.pw.toml` - GitHub Release
- `shaderpacks/seus-renewed.pw.toml` - GitHub Release
