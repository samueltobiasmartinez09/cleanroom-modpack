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
    git clone "https://github.com/samueltobiasmartinez09/cleanroom-modpack.git" "$TMP_DIR/repo" --depth 1
    cd "$TMP_DIR/repo"

    rm -rf scripts/ .github/
    rm -f packwiz AGENTS.md cleanroom-version.txt

    if [ "$PLATFORM" = "windows" ]; then
        rm -f minecraft/*.sh
        sed -i 's|PreLaunchCommand=.*|PreLaunchCommand=cmd.exe /c $INST_DIR\\minecraft\\pre-launch.bat|' instance.cfg
    else
        rm -f minecraft/*.bat
    fi

    cd "$TMP_DIR/repo"
    rm -rf .git
    zip -r "$RELEASE_DIR/$ZIP_NAME" . > /dev/null
    cd /tmp
    rm -rf "$TMP_DIR"
    echo "  -> $ZIP_NAME built ($(ls -lh "$RELEASE_DIR/$ZIP_NAME" | awk '{print $5}'))"
}

build_zip "linux"
build_zip "macos"
build_zip "windows"

echo "=== All zips in $RELEASE_DIR/ ==="
ls -lh "$RELEASE_DIR"/
