#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INST_DIR="$(dirname "$SCRIPT_DIR")"

# Copy java-bootstrap wrapper to Prism root so JavaPath resolves correctly
PRISM_ROOT="$(cd "$INST_DIR/../.." && pwd)"
if [ ! -x "$PRISM_ROOT/java-bootstrap" ] && [ -x "$INST_DIR/java-bootstrap" ]; then
    cp "$INST_DIR/java-bootstrap" "$PRISM_ROOT/java-bootstrap" 2>/dev/null
fi

if [ ! -x "$SCRIPT_DIR/jre25/bin/java" ]; then
    "$SCRIPT_DIR/install-java.sh" || exit 1
fi

"$SCRIPT_DIR/jre25/bin/java" -jar "$SCRIPT_DIR/packwiz-installer-bootstrap.jar" --timeout 0 "https://raw.githubusercontent.com/samueltobiasmartinez09/cleanroom-modpack/main/pack.toml"
if [ -d "$SCRIPT_DIR/patches" ]; then
    mkdir -p "$INST_DIR/patches"
    cp -rf "$SCRIPT_DIR/patches"/* "$INST_DIR/patches/"
fi

# Copy updated instance.cfg from packwiz download to instance root
if [ -f "$SCRIPT_DIR/instance.cfg" ]; then
    cp "$SCRIPT_DIR/instance.cfg" "$INST_DIR/instance.cfg"
fi

# Enable Java override for next launch (avoids "couldn't be found" error on first run)
if grep -q "^OverrideJavaLocation=false" "$INST_DIR/instance.cfg" 2>/dev/null; then
    sed -i 's/^OverrideJavaLocation=false/OverrideJavaLocation=true/' "$INST_DIR/instance.cfg"
    sed -i 's|^JavaPath=.*|JavaPath=./java-bootstrap|' "$INST_DIR/instance.cfg"
fi

# Set resource packs based on active renderer
OPTIONS_FILE="$SCRIPT_DIR/options.txt"
if [ -f "$SCRIPT_DIR/mods/preview_OptiFine_1.12.2_HD_U_G6_pre1.jar" ]; then
    RPACKS='["Fix_Textures_OptiFine.zip","Fix_Vintage_Vainilla.zip"]'
else
    RPACKS='["Fix_Vintage_Vainilla.zip"]'
fi

if [ ! -f "$OPTIONS_FILE" ]; then
    echo "resourcePacks:$RPACKS" > "$OPTIONS_FILE"
else
    if grep -q "^resourcePacks:" "$OPTIONS_FILE" 2>/dev/null; then
        sed -i "s|^resourcePacks:.*$|resourcePacks:$RPACKS|" "$OPTIONS_FILE"
    else
        echo "resourcePacks:$RPACKS" >> "$OPTIONS_FILE"
    fi
fi
