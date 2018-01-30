#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build Windows editor
scons platform=windows bits=64 tools=yes target=release_debug $SCONS_FLAGS
scons platform=windows bits=32 tools=yes target=release_debug $SCONS_FLAGS

# Install InnoSetup
curl -o "$CI_PROJECT_DIR/innosetup.zip" "https://archive.hugo.pro/.public/godot-builds/innosetup-5.5.9-unicode.zip"
unzip -q "$CI_PROJECT_DIR/innosetup.zip" -d "$CI_PROJECT_DIR/"
rm "$CI_PROJECT_DIR/innosetup.zip"
export ISCC="$CI_PROJECT_DIR/innosetup/ISCC.exe"

# Create Windows editor installers and ZIP archives
cd "$GODOT_DIR/bin/"
cp "$CI_PROJECT_DIR/resources/godot.iss" "godot.iss"
strip "godot.windows.opt.tools.64.exe" "godot.windows.opt.tools.32.exe"

mv "godot.windows.opt.tools.64.exe" "godot.exe"
zip -r9 "godot-windows-x86_64.zip" "godot.exe"
wine "$ISCC" "godot.iss"
rm "godot.exe"

mv "godot.windows.opt.tools.32.exe" "godot.exe"
zip -r9 "godot-windows-x86.zip" "godot.exe"
wine "$ISCC" "godot.iss" /DApp32Bit
rm "godot.exe"

mv \
    "godot-windows-x86_64.zip" \
    "godot-windows-x86.zip" \
    "Output/godot-windows-x86_64.exe" \
    "Output/godot-windows-x86.exe" \
    "$ARTIFACTS_DIR/editor/"
