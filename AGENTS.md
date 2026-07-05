# Agent Context - Cleanroom Modpack

## Goal
Mantener modpack CleanroomMC 1.12.2 con packwiz: JRE Zulu 25 bundleado, Celeritas como renderer requerido, scripts switch que instalan OptiFine externamente.

## State Actual
- JRE Zulu 25.0.3 CRaC bundleado en `minecraft/jre25/`
- Celeritas mods REQUERIDOS (no optional)
- OptiFine/NotFine eliminados del pack, se instalan externamente via scripts switch
- `.packwizignore` excluye `.github/`, `scripts/`, `packwiz`, `.github_token`
- Hashes verificados contra instancia Prism en `/opt/PrismLauncher/instances/cleanroom-modpack-v1.0.0-linux/`

## Mod Sources
- 69 mods en CurseForge (`mode = "metadata:curseforge"`)
- Celeritas-related migrados a CurseForge excepto celeritas-forge que va a GitHub kappa-maintainer
- 3 assets propios mantienen GitHub Release: `Fix_Textures_OptiFine.zip`, `Fix_Vintage_Vainilla.zip`, `SEUS-Renewed-v1.0.1.zip`

## Git State
- Branch: main (commit `10261d3`)
- Remote: https://github.com/samueltobiasmartinez09/cleanroom-modpack.git
- Token: `.github_token` (local, ignorado por git via `.gitignore`, no trackeado)
- Release v1.0.0 creada en GitHub con 3 assets propios

## Changes Completed
1. **celeritas-forge** → GitHub kappa-maintainer (Celery auto-build, `celeritas-auto-build.pw.toml`)
2. **celeritasdynamiclights** → CurseForge (`celeritas-dynamic-lights.pw.toml`)
3. **celeritasextra** → CurseForge v0.6.1 (`celeritas-extra.pw.toml`)
4. **celeritasleafculling** → CurseForge (`celeritasleafculling.pw.toml`)
5. **entitythreading** → CurseForge (`threading-entity-mod.pw.toml`) + MixinBooter dep
6. **logcleaner**, **missingvariantaccessfix** eliminados
7. **Switch scripts** actualizados: OptiFine → `optifine.net/downloadx`, OptiNotFine → CurseForge CDN
8. **celeritasextra** filename corregido a v0.6.1 en scripts
9. **.github_token** removido de git tracking, añadido a `.gitignore`
10. **Historia git** limpiada (filter-branch removió token de todos los commits)
11. **Push** a GitHub (force push tras filter-branch)
12. **Release v1.0.0** creada con 3 assets: Fix_Textures_OptiFine.zip, Fix_Vintage_Vainilla.zip, SEUS-Renewed-v1.0.1.zip

================================================================================
## PLAN: Workflows solo commitean al repo (sin rebuild de zips)
================================================================================

### Arquitectura final
- **Una vez**: 3 zips (linux/windows/macos) se construyen manualmente y suben a Release
- **CI solo commitea** al repo: mmc-pack.json, JREs, scripts cuando hay updates
- **packwiz-installer** en runtime descarga los mods más recientes del repo
- **Los zips nunca se reconstruyen** — usuarios descargan 1 vez, packwiz actualiza lo demás

### Files a crear en minecraft/ (archivos estáticos)

| Archivo | Contenido |
|---|---|
| `minecraft/pre-launch.sh` | Ejecuta packwiz-installer con pack.toml, copia mmc-pack.json |
| `minecraft/pre-launch.bat` | Ídem Windows |
| `minecraft/switch-to-optifine.sh` | Descarga OptiFine/NotFine, deshabilita Celeritas con wildcards |
| `minecraft/switch-to-optifine.bat` | Ídem Windows |
| `minecraft/switch-to-celeritas.sh` | Elimina OptiFine/NotFine, restaura Celeritas con wildcards |
| `minecraft/switch-to-celeritas.bat` | Ídem Windows |

Los switch scripts usan WILDCARDS para ser version-agnostic:
```sh
# en vez de celeritas-forge-mc12.2-2.4.0-dev.jar
for f in celeritas-forge-mc12.2-*.jar celeritasdynamiclights-*.jar \
         celeritasextra-*.jar celeritasleafculling-*.jar; do ...
```
Esto evita que los scripts se desactualicen cuando cambian versiones de mods.

### .gitignore a actualizar
```gitignore
minecraft/*
!minecraft/jre25/
!minecraft/jre25-win/
!minecraft/jre25-mac/
!minecraft/pre-launch.sh
!minecraft/pre-launch.bat
!minecraft/switch-to-optifine.sh
!minecraft/switch-to-optifine.bat
!minecraft/switch-to-celeritas.sh
!minecraft/switch-to-celeritas.bat
release
packwiz
.github_token
```

### check-cleanroom-update.yml — cambios
ELIMINAR (~100 líneas):
- Build de zips (loop for os in linux windows macos)
- Creación inline de scripts (pre-launch, switch scripts)
- Subida a Release
- cp -r $GITHUB_WORKSPACE

MANTENER:
- Fetch latest Cleanroom release
- Download mmc-pack.json
- Patch cachedVersion/version a 14.23.5.2860
- Update hash en mmc-pack.json.pw.toml
- Guardar nueva versión en cleanroom-version.txt
- git add + commit: mmc-pack.json, mmc-pack.json.pw.toml, cleanroom-version.txt

### check-zulu-update.yml — cambios
ELIMINAR:
- Build de zips (loop for os)
- Creación inline de scripts
- Subida a Release
- cp -r $GITHUB_WORKSPACE

MANTENER:
- Fetch latest Zulu JRE 25 para linux, windows, macos
- download_and_extract() function

CAMBIAR:
- En vez de build de zips, extraer cada JRE a su directorio en el repo:
  - Linux → `minecraft/jre25/`
  - Windows → `minecraft/jre25-win/`
  - macOS → `minecraft/jre25-mac/`
- Update instance.cfg (JavaVersion)
- git add + commit: minecraft/jre25/, minecraft/jre25-win/, minecraft/jre25-mac/, instance.cfg

### Construcción manual de los 3 zips (1 vez)
Script local que:
1. Crea `minecraft/jre25-win/` temporal renombrado a `jre25/` para Windows
2. Crea `minecraft/jre25-mac/` temporal renombrado a `jre25/` para macOS
3. Incluye solo los scripts correspondientes a cada plataforma:
   - Linux: pre-launch.sh, switch-to-optifine.sh, switch-to-celeritas.sh
   - macOS: pre-launch.sh, switch-to-optifine.sh, switch-to-celeritas.sh
   - Windows: pre-launch.bat, switch-to-optifine.bat, switch-to-celeritas.bat
4. Cada zip incluye SOLO su JRE nativo + scripts nativos
5. Subir los 3 zips a Release v1.0.0

## Relevant Files
- `.github/workflows/check-cleanroom-update.yml` - workflow cleanroom
- `.github/workflows/check-zulu-update.yml` - workflow zulu
- `.packwizignore` - exclude .github/, scripts/, packwiz, .github_token
- `.gitignore` - exclude .github_token + track minecraft scripts/jres
- `minecraft/pre-launch.sh` - script pre-lanzamiento Linux/macOS
- `minecraft/pre-launch.bat` - script pre-lanzamiento Windows
- `minecraft/switch-to-optifine.sh` - switch a OptiFine Linux/macOS
- `minecraft/switch-to-optifine.bat` - switch a OptiFine Windows
- `minecraft/switch-to-celeritas.sh` - switch a Celeritas Linux/macOS
- `minecraft/switch-to-celeritas.bat` - switch a Celeritas Windows
- `mods/celeritas-auto-build.pw.toml` - celeritas-forge kappa-maintainer
- `mods/celeritas-dynamic-lights.pw.toml` - CurseForge
- `mods/celeritas-extra.pw.toml` - CurseForge v0.6.1
- `mods/celeritasleafculling.pw.toml` - CurseForge
- `mods/threading-entity-mod.pw.toml` - CurseForge
- `mods/mixin-booter.pw.toml` - CurseForge (MixinBooter v11.2)
- `resourcepacks/fix-textures-optifine.pw.toml` - GitHub Release propio
- `resourcepacks/fix-vintage-vainilla.pw.toml` - GitHub Release propio
- `shaderpacks/seus-renewed.pw.toml` - GitHub Release propio

## Deleted from pack (no .pw.toml)
- `mods/optifine.pw.toml`
- `mods/optinotfine.pw.toml`
- `mods/missingvariantaccessfix.pw.toml`
- `mods/logcleaner.pw.toml`
- `mods/mixinbooter.pw.toml` (Modrinth, reemplazado por CurseForge v11.2)
