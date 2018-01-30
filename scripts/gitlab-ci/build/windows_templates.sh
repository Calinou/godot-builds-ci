#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build Windows export templates
scons platform=windows bits=64 tools=no target=release_debug $SCONS_FLAGS
scons platform=windows bits=64 tools=no target=release $SCONS_FLAGS

# Create Windows export templates TPZ
# We're short on build times, so pretend 64-bit binaries are 32-bit binaries
# for now, to avoid errors in the editor's Export dialog
mkdir -p "templates/"
strip bin/godot.windows.*.exe
cp "bin/godot.windows.opt.debug.64.exe" "templates/windows_64_debug.exe"
mv "bin/godot.windows.opt.debug.64.exe" "templates/windows_32_debug.exe"
cp "bin/godot.windows.opt.64.exe" "templates/windows_64_release.exe"
mv "bin/godot.windows.opt.64.exe" "templates/windows_32_release.exe"

zip -r9 "$ARTIFACTS_DIR/templates/godot-templates-windows.tpz" "templates/"
