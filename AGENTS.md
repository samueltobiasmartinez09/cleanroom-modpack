# Agent Context - Cleanroom Modpack

## Goal
Mantener modpack CleanroomMC 1.12.2 con packwiz: JRE Zulu 25 bundleado, Celeritas como renderer requerido, scripts switch que instalan OptiFine externamente.

## State
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
- Branch: main (commit `0ac4ab1`)
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
7. **Switch scripts** actualizados: OptiFine → `optifine.net/downloadx`, OptiNotFine → CurseForge CDN (`media.forgecdn.net/files/7438/360/OptiNotFine-1.0.jar`)
8. **celeritasextra** filename corregido a v0.6.1 en scripts
9. **.github_token** removido de git tracking, añadido a `.gitignore`
10. **Historia git** limpiada (filter-branch removió token de todos los commits)
11. **Push** a GitHub (force push tras filter-branch)
12. **Release v1.0.0** creada con 3 assets: Fix_Textures_OptiFine.zip, Fix_Vintage_Vainilla.zip, SEUS-Renewed-v1.0.1.zip

## Relevant Files
- `.github/workflows/check-cleanroom-update.yml` - workflow cleanroom (switch scripts actualizados)
- `.github/workflows/check-zulu-update.yml` - workflow zulu (switch scripts actualizados)
- `.packwizignore` - exclude .github/, scripts/, packwiz, .github_token
- `.gitignore` - exclude .github_token
- `mods/celeritas-auto-build.pw.toml` - celeritas-forge desde kappa-maintainer GitHub
- `mods/celeritas-dynamic-lights.pw.toml` - CurseForge (celeritas-dynamic-lights)
- `mods/celeritas-extra.pw.toml` - CurseForge (celeritas-extra) v0.6.1
- `mods/celeritasleafculling.pw.toml` - CurseForge (celeritasleafculling)
- `mods/threading-entity-mod.pw.toml` - CurseForge (threading-entity-mod)
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
