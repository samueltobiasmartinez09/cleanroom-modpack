#!/bin/sh
cd "$(dirname "$0")" || exit 1
echo "Downloading OptiFine..."
curl -sL -o "mods/preview_OptiFine_1.12.2_HD_U_G6_pre1.jar" "https://optifine.net/downloadx?f=preview_OptiFine_1.12.2_HD_U_G6_pre1.jar&x=57ce0cdd0c77666d893a09f5c8971bcd"
curl -sL -o "mods/OptiNotFine-1.0.jar" "https://media.forgecdn.net/files/7438/360/OptiNotFine-1.0.jar"
echo "Disabling Celeritas..."
for f in celeritas-forge-mc12.2-*.jar celeritasdynamiclights-*.jar celeritasextra-*.jar celeritasleafculling-*.jar; do
    [ -f "mods/$f" ] && mv "mods/$f" "mods/$f.disabled"
done
echo "Switched to OptiFine"
