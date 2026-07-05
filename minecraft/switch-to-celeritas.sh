#!/bin/sh
cd "$(dirname "$0")" || exit 1
echo "Removing OptiFine..."
rm -f "mods/preview_OptiFine_1.12.2_HD_U_G6_pre1.jar" "mods/OptiNotFine-1.0.jar"
echo "Restoring Celeritas..."
for f in celeritas-forge-mc12.2-*.jar celeritasdynamiclights-*.jar celeritasextra-*.jar celeritasleafculling-*.jar; do
    [ -f "mods/$f.disabled" ] && mv "mods/$f.disabled" "mods/$f"
done
echo "Switched to Celeritas"
