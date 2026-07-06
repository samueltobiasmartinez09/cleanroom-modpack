# Agent Context - Cleanroom Modpack

## Goal
Modpack CleanroomMC 1.12.2 con packwiz: JRE Zulu 25 CRaC descargado al runtime via java-bootstrap binario, Celeritas como renderer requerido, scripts switch que instalan OptiFine externamente.

## Arquitectura final
- **Bootstrap binario C** (`minecraft/jre25/java-bootstrap` 15K ELF, `java-bootstrap.exe` 19K PE) como `JavaPath` en `instance.cfg`
- **Prism llama al bootstrap** para detection (`-version`) y launch (args de MC) → bootstrap descarga JRE si falta → `exec bin/java`
- **JRE descargado al detection time**: `java-bootstrap` corre `install-java.sh`/`.bat` via `system()`, extrae a `minecraft/jre25/`
- **No requiere configurar Java manualmente en Prism** — Prism detecta Java 25 automáticamente via bootstrap
- **pre-launch.sh** como safety: checkea si JRE existe antes de packwiz (bootstrap ya lo descargó)
- **3 zips chicos** (~144KB, sin JRE) construidos con git clone desde GitHub, bootstrap binario incluido
- **packwiz-installer-bootstrap.jar** runtime descarga los mods más recientes del repo

## Cómo funciona
1. Usuario importa zip en Prism
2. Prism detection time → `JavaPath=./minecraft/jre25/java-bootstrap -version` → bootstrap descarga JRE si no existe → `exec bin/java -version` → Prism ve Java 25
3. User lanza instancia → `pre-launch.sh` → checkea JRE (ya existe) → packwiz-installer descarga mods
4. Prism lanza Minecraft → `JavaPath=./minecraft/jre25/java-bootstrap <MC args>` → bootstrap ve JRE existente → `exec bin/java <MC args>`
5. Scripts switch: `switch-to-optifine`/`switch-to-celeritas` (wildcards version-agnostic)

## Bootstrap binario (java-bootstrap.c)
- Cross-platform C: Linux (`/proc/self/exe`), macOS (`_NSGetExecutablePath`), Windows (`GetModuleFileNameA`)
- Compilado dinámico para Linux (15K, solo libc), estático para Windows (19K, mingw-w64)
- `readlink` path propio → `dirname` → check `./bin/java` existe y es ejecutable
- Si no: `system("sh install-java.sh")` en Unix, `system("install-java.bat")` en Windows
- `execv(bin_java, argv)` pasa todos los flags que Prism mande (-version, args MC, etc.)
- En Windows: `CreateProcessA` con wait + exit code

## Archivos clave trackeados en git
- `minecraft/jre25/java-bootstrap` — Linux ELF 15K
- `minecraft/jre25/java-bootstrap.exe` — Windows PE 19K
- `minecraft/jre25/java-bootstrap.c` — source code
- `minecraft/pre-launch.sh` / `.bat` — packwiz installer con safety JRE
- `minecraft/install-java.sh` / `.bat` — descarga JRE desde API Azul
- `minecraft/packwiz-installer-bootstrap.jar` — bootstrap del packwiz-installer
- `minecraft/switch-to-optifine.sh` / `.bat`
- `minecraft/switch-to-celeritas.sh` / `.bat`
- `scripts/build-zips.sh` — construye 3 zips OS-específicos

## Excluidos de packwiz (.packwizignore)
`.github/`, `scripts/`, `packwiz`, `.github_token`, `AGENTS.md`, `minecraft/jre25/`, `release/`, `instance.cfg`, `mmc-pack.json`, `mmc-pack.json.pw.toml`, `cleanroom-version.txt`, scripts en `minecraft/`, `packwiz-installer-bootstrap.jar`

## Excluidos de git (.gitignore)
`minecraft/*` excepto scripts + bootstrap + packwiz-installer-bootstrap.jar. `minecraft/jre25/*` excepto bootstrap binarios. `release`, `packwiz`, `.github_token`.

## instance.cfg
```
JavaPath=./minecraft/jre25/java-bootstrap
OverrideJavaLocation=true
IgnoreJavaCompatibility=true
PreLaunchCommand=/bin/sh $INST_DIR/minecraft/pre-launch.sh
```
Windows build: s/windows: JavaPath → `java-bootstrap.exe`, PreLaunchCommand → `cmd.exe`

## Mod Sources
- 69 mods en CurseForge (mode = "metadata:curseforge")
- Celeritas-related en CurseForge + GitHub kappa-maintainer
- 3 assets propios GitHub Release: Fix_Textures_OptiFine.zip, Fix_Vintage_Vainilla.zip, SEUS-Renewed-v1.0.1.zip

## Git State
- Branch: main
- Remote: https://github.com/samueltobiasmartinez09/cleanroom-modpack.git
- Token: .github_token (local, ignorado por git, no trackeado)
- Release v1.0.0 con 6 assets: 3 assets propios + 3 zips de plataforma

## Construcción de zips
1. `./packwiz refresh` (actualiza hashes si cambió index.toml)
2. `bash scripts/build-zips.sh` (git clone desde GitHub → filtra OS → zipea)
3. `gh release upload v1.0.0 release/*.zip --clobber`

## Testing verificado
- packwiz compilado desde source (Go) para packwiz refresh
- Bootstrap compilado con gcc (Linux) y mingw-w64 (Windows)
- E2E test: fresh zip extract → bootstrap descarga JRE 25 CRaC → pre-launch corre packwiz → 61+ mods descargados en 15s. 0 errores.
