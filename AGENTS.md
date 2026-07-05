# Agent Context - Cleanroom Modpack

## Goal
Mantener modpack CleanroomMC 1.12.2 con packwiz: JRE Zulu 25 bundleado, Celeritas como renderer requerido, scripts switch que instalan OptiFine externamente.

## State Actual
- JRE Zulu 25.0.3 CRaC bundleado en `minecraft/jre25/` (Linux, trackeado en repo)
- Win/Mac JREs >100MB, NO trackeados en repo — solo van en los zips de plataforma
- Celeritas mods REQUERIDOS (no optional)
- OptiFine/NotFine eliminados del pack, se instalan externamente via scripts switch
- `.packwizignore` excluye `.github/`, `scripts/`, `packwiz`, `.github_token`, `AGENTS.md`
- 6 scripts estáticos en `minecraft/` con wildcards (version-agnostic)
- Hashes verificados contra instancia Prism en `/opt/PrismLauncher/instances/cleanroom-modpack-v1.0.0-linux/`

## Mod Sources
- 69 mods en CurseForge (`mode = "metadata:curseforge"`)
- Celeritas-related migrados a CurseForge excepto celeritas-forge que va a GitHub kappa-maintainer
- 3 assets propios mantienen GitHub Release: `Fix_Textures_OptiFine.zip`, `Fix_Vintage_Vainilla.zip`, `SEUS-Renewed-v1.0.1.zip`

## Git State
- Branch: main (commit `20bc963`)
- Remote: https://github.com/samueltobiasmartinez09/cleanroom-modpack.git
- Token: `.github_token` (local, ignorado por git via `.gitignore`, no trackeado)
- Release v1.0.0 creada en GitHub con 6 assets: 3 propios + 3 zips de plataforma

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
13. **6 scripts estáticos** creados en `minecraft/` con wildcards (pre-launch, switch-optifine, switch-celeritas)
14. **Workflows refactorizados**: solo commitean al repo, sin build de zips
15. **JREs Win/Mac** descargados, 3 zips de plataforma construidos y subidos a Release v1.0.0
16. **AGENTS.md** añadido a `.packwizignore`
17. **.gitignore** actualizado: trackea scripts + Linux JRE, Win/Mac JREs excluidos (>100MB)
18. **check-zulu-update.yml**: solo actualiza Linux JRE en repo (Win/Mac solo en zips)

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

### .gitignore actual
```gitignore
minecraft/*
!minecraft/jre25/
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

NOTA: Win/Mac JREs >100MB, NO trackeados en repo — solo van en los zips de plataforma.

### check-cleanroom-update.yml — implementado
- Solo commitea mmc-pack.json + mmc-pack.json.pw.toml + cleanroom-version.txt
- Sin build de zips, sin scripts inline, sin subida a Release

### check-zulu-update.yml — implementado
- Descarga Linux JRE → extrae a `minecraft/jre25/` → commitea
- Solo Linux JRE en repo (Win/Mac >100MB, no trackeables)
- Actualiza JavaVersion en instance.cfg

### Construcción manual de los 3 zips (ejecutado)
1. Descargar JREs Win/Mac desde Azul API
2. Copiar repo base, reemplazar jre25/ por cada JRE nativo
3. Incluir solo scripts nativos: Linux/macOS → .sh, Windows → .bat
4. Windows: cambiar PreLaunchCommand a cmd.exe
5. Subir a Release v1.0.0

## Relevant Files
- `.github/workflows/check-cleanroom-update.yml` - workflow cleanroom
- `.github/workflows/check-zulu-update.yml` - workflow zulu
- `.packwizignore` - exclude .github/, scripts/, packwiz, .github_token, AGENTS.md
- `.gitignore` - exclude .github_token + track minecraft scripts/Linux JRE (Win/Mac JREs >100MB excluidos)
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
