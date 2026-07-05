#!/bin/sh
set -e
DIR="$(cd "$(dirname "$0")/.." && pwd)"
RELEASE_DIR="$DIR/release"
VERSION="v1.0.0"

echo "=== Building cleanroom-modpack zips (no JREs) ==="
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

build_zip() {
    PLATFORM="$1"
    ZIP_NAME="cleanroom-modpack-${VERSION}-${PLATFORM}.zip"
    echo "Building $ZIP_NAME ..."

    TMP_DIR=$(mktemp -d)
    cp -r "$DIR" "$TMP_DIR/repo"
    cd "$TMP_DIR/repo"
    rm -rf .git scripts/ .github/

    if [ "$PLATFORM" = "windows" ]; then
        rm -f minecraft/*.sh
        sed -i 's|PreLaunchCommand=.*|PreLaunchCommand=cmd.exe /c $INST_DIR\\minecraft\\pre-launch.bat|' instance.cfg
    else
        rm -f minecraft/*.bat
    fi

    cd "$TMP_DIR"
    zip -r "$RELEASE_DIR/$ZIP_NAME" repo/ -x "repo/.git*" > /dev/null
    rm -rf "$TMP_DIR"
    echo "  -> $ZIP_NAME built ($(ls -lh "$RELEASE_DIR/$ZIP_NAME" | awk '{print $5}'))"
}

build_zip "linux"
build_zip "macos"
build_zip "windows"

echo "=== All zips in $RELEASE_DIR/ ==="
ls -lh "$RELEASE_DIR"/
