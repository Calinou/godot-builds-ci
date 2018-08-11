#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build Windows export templates
for target in "release_debug" "release"; do
  scons platform=windows bits=64 tools=no target=$target use_lto=yes \
        $SCONS_FLAGS
done

strip bin/godot.windows.*.exe

# Move Windows export templates to the artifacts directory
# We're short on build times, so pretend 64-bit binaries are 32-bit binaries
# to avoid errors in the editor's Export dialog
cp "$GODOT_DIR/bin/godot.windows.opt.debug.64.exe" "$ARTIFACTS_DIR/templates/windows_64_debug.exe"
mv "$GODOT_DIR/bin/godot.windows.opt.debug.64.exe" "$ARTIFACTS_DIR/templates/windows_32_debug.exe"
cp "$GODOT_DIR/bin/godot.windows.opt.64.exe" "$ARTIFACTS_DIR/templates/windows_64_release.exe"
mv "$GODOT_DIR/bin/godot.windows.opt.64.exe" "$ARTIFACTS_DIR/templates/windows_32_release.exe"
