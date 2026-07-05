#!/bin/sh
SCRIPT_DIR="$(dirname "$0")"
"$SCRIPT_DIR/jre25/bin/java" -jar "$SCRIPT_DIR/packwiz-installer-bootstrap.jar" --timeout 0 "https://raw.githubusercontent.com/samueltobiasmartinez09/cleanroom-modpack/main/pack.toml"
cp -f "$SCRIPT_DIR/mmc-pack.json" "$SCRIPT_DIR/../mmc-pack.json"
