#!/bin/sh
SCRIPT_DIR="$(dirname "$0")"

if [ ! -x "$SCRIPT_DIR/jre25/bin/java" ]; then
    "$SCRIPT_DIR/install-java.sh" || exit 1
fi

"$SCRIPT_DIR/jre25/bin/java" -jar "$SCRIPT_DIR/packwiz-installer-bootstrap.jar" --timeout 0 "https://raw.githubusercontent.com/samueltobiasmartinez09/cleanroom-modpack/main/pack.toml"
if [ -d "$SCRIPT_DIR/patches" ]; then
    mkdir -p "$SCRIPT_DIR/../patches"
    cp -rf "$SCRIPT_DIR/patches"/* "$SCRIPT_DIR/../patches/"
fi
