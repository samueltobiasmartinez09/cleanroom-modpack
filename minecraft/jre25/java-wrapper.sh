#!/bin/sh
SCRIPT_DIR="$(dirname "$0")"
JRE_DIR="$SCRIPT_DIR"

if [ ! -x "$JRE_DIR/bin/java" ]; then
    "$(dirname "$SCRIPT_DIR")/install-java.sh"
fi

exec "$JRE_DIR/bin/java" "$@"
