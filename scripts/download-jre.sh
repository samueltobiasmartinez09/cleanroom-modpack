#!/bin/sh
set -e

JAVA_VER="25"
DEST="$(cd "$(dirname "$0")/.." && pwd)/minecraft/jre25"

echo "=== Downloading Zulu JRE $JAVA_VER for Linux ==="

JSON=$(curl -sL "https://api.azul.com/metadata/v1/zulu/packages/?java_version=$JAVA_VER&os=linux&arch=x86&archive_type=tar.gz&java_package_type=jre&javafx=false&latest=true&page_size=1")
URL=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['download_url'])")
NAME=$(echo "$JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['name'])")

echo "Downloading $NAME ..."
curl -sL -o /tmp/zulu_jre.tar.gz "$URL"

echo "Extracting to $DEST ..."
mkdir -p "$DEST"
tar -xzf /tmp/zulu_jre.tar.gz -C /tmp/
JRE_DIR=$(find /tmp/zulu*linux* -maxdepth 1 -name "bin" -type d | head -1)
JRE_DIR=$(dirname "$JRE_DIR")
rm -f "$JRE_DIR/readme.txt" "$JRE_DIR/Welcome.html" "$JRE_DIR/DISCLAIMER"
cp -r "$JRE_DIR"/* "$DEST/"
chmod +x "$DEST/bin/java"

rm -rf /tmp/zulu_jre.tar.gz "$JRE_DIR"

echo "Done! JRE installed at $DEST"
"$DEST/bin/java" -version
