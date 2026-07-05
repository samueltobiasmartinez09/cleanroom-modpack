@echo off
cd /d "%~dp0"
echo Removing OptiFine...
del /Q "mods\preview_OptiFine_1.12.2_HD_U_G6_pre1.jar" "mods\OptiNotFine-1.0.jar" 2>nul
echo Restoring Celeritas...
for %%f in (celeritas-forge-mc12.2-*.jar celeritasdynamiclights-*.jar celeritasextra-*.jar celeritasleafculling-*.jar) do (
    if exist "mods\%%f.disabled" ren "mods\%%f.disabled" "%%f"
)
echo Switched to Celeritas
