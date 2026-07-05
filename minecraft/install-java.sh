#!/bin/sh
DIR="$(cd "$(dirname "$0")" && pwd)"
JRE_DIR="$DIR/jre25"

if [ -d "$JRE_DIR" ] && [ -x "$JRE_DIR/bin/java" ]; then
    exit 0
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="x64"

case "$OS" in
    linux*)
        AZUL_OS="linux"
        CRAC="true"
        ;;
    darwin*)
        AZUL_OS="macos"
        CRAC="false"
        ;;
    *)
        echo "Unsupported OS: $OS" >&2
        exit 1
        ;;
esac

API="https://api.azul.com/metadata/v1/zulu/packages/?java_version=25&os=$AZUL_OS&arch=$ARCH&java_package_type=jre&javafx_bundled=false&release_status=ga&availability_types=CA&latest=true"
[ "$CRAC" = "true" ] && API="${API}&crac_supported=true"

URL=$(curl -sL "$API" | grep -o '"download_url":"[^"]*"' | sed 's/"download_url":"//;s/"$//' | grep '\.tar\.gz$' | head -1)

if [ -z "$URL" ]; then
    echo "Failed to get JRE download URL from Azul API" >&2
    exit 1
fi

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo "Downloading Zulu JRE 25..."
curl -#L "$URL" -o jre.tar.gz || exit 1

echo "Extracting..."
mkdir -p "$JRE_DIR"
mkdir -p tmp_extract
tar -xzf jre.tar.gz -C tmp_extract

TOP_DIR=$(find tmp_extract -maxdepth 1 -type d ! -name tmp_extract | head -1)
if [ -n "$TOP_DIR" ]; then
    mv "$TOP_DIR"/* "$JRE_DIR"/
else
    mv tmp_extract/* "$JRE_DIR"/
fi

for f in DISCLAIMER readme.txt Welcome.html; do
    rm -f "$JRE_DIR/$f"
done
rm -rf "$TMP_DIR"

chmod +x "$JRE_DIR/bin/"* 2>/dev/null

if [ -x "$JRE_DIR/bin/java" ]; then
    echo "JRE installed at $JRE_DIR"
else
    echo "Failed to install JRE" >&2
    exit 1
fi
