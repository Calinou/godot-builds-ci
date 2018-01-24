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

# Create Windows editor ZIP archives
cd "$GODOT_DIR/bin/"
strip "godot.windows.opt.tools.64.exe" "godot.windows.opt.tools.32.exe"

mv "godot.windows.opt.tools.64.exe" "godot.exe"
zip -r9 "godot-windows-x86_64.zip" "godot.exe"
rm "godot.exe"

mv "godot.windows.opt.tools.32.exe" "godot.exe"
zip -r9 "godot-windows-x86.zip" "godot.exe"
rm "godot.exe"

mv "godot-windows-x86_64.zip" "godot-windows-x86.zip" "$ARTIFACTS_DIR/editor/"
