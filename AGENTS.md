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
- 3 assets propios mantienen GitHub Release: `fix-textures-optifine.zip`, `fix-vintage-vainilla.zip`, `SEUS-Renewed-v1.0.1.zip`

## Git State (commit 92d5047)
- Branch: main
- Remote: https://github.com/samueltobiasmartinez09/cleanroom-modpack.git
- Token: `.github_token` (en raíz, ignorado por packwiz, trackeado por git)
- Pending: push to GitHub + crear Release v1.0.0 con solo 3 assets propios

## Pending Work
### 1. Migrar celeritas-forge a GitHub kappa-maintainer
- Repo: `kappa-maintainer/Celeritas-auto-build`
- Asset: `celeritas-forge-mc12.2-2.4.0-dev.jar` (1639107 bytes)
- URL: `https://github.com/kappa-maintainer/Celeritas-auto-build/releases/download/release/2.4.0-dev.4-7-gfadd0c40-20260617T021234/celeritas-forge-mc12.2-2.4.0-dev.jar`
- Packwiz cmd: `packwiz github add kappa-maintainer/Celeritas-auto-build --regex "celeritas-forge-mc12\\.2.*\\.jar"`

### 2. Actualizar scripts switch (en .github/workflows/check-*.yml)
- switch-to-optifine.sh/bat: descargar OptiFine desde `https://optifine.net/downloadx?f=preview_OptiFine_1.12.2_HD_U_G6_pre1.jar&x=57ce0cdd0c77666d893a09f5c8971bcd`
- switch-to-optifine.sh/bat: descargar OptiNotFine desde CurseForge slug `optinotfine`
- switch-to-celeritas.sh/bat: eliminar OptiFine/NotFine, restaurar Celeritas (ya está bien)

### 3. packwiz refresh
- Después de cambios, regenerar index.toml

### 4. Push + Release v1.0.0
- Push a GitHub
- Crear Release v1.0.0 con solo 3 assets:
  - `fix-textures-optifine.zip` (de instancia Prism)
  - `fix-vintage-vainilla.zip` (de instancia Prism)
  - `SEUS-Renewed-v1.0.1.zip` (de instancia Prism)

## Relevant Files
- `.github/workflows/check-cleanroom-update.yml` - workflow cleanroom
- `.github/workflows/check-zulu-update.yml` - workflow zulu
- `.packwizignore` - exclude .github/, scripts/, packwiz, .github_token
- `mods/celeritas-forge.pw.toml` - pending GitHub source change
- `mods/*.pw.toml` - otros mods (CurseForge)
- `mods/entitythreading.pw.toml` - ya en CurseForge (threading-entity-mod)
- `mods/celeritasdynamiclights.pw.toml` - ya en CurseForge (celeritas-dynamic-lights)
- `mods/celeritasextra.pw.toml` - ya en CurseForge (celeritas-extra) v0.6.1
- `mods/celeritasleafculling.pw.toml` - ya en CurseForge (celeritasleafculling)
- `resourcepacks/fix-textures-optifine.pw.toml` - GitHub Release propio
- `resourcepacks/fix-vintage-vainilla.pw.toml` - GitHub Release propio
- `shaderpacks/seus-renewed.pw.toml` - GitHub Release propio

## Deleted from pack (no .pw.toml)
- `mods/optifine.pw.toml`
- `mods/optinotfine.pw.toml`
- `mods/missingvariantaccessfix.pw.toml`
- `mods/logcleaner.pw.toml`
