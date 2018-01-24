#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build Linux export templates
scons platform=x11 tools=no target=release_debug $SCONS_FLAGS
scons platform=x11 tools=no target=release $SCONS_FLAGS

# Create Linux export templates ZIP archive
# Pretend 64-bit binaries are 32-bit binaries for now, to avoid errors
# in the editor's Export dialog
cd "$GODOT_DIR/bin/"
strip godot.*.64
cp "godot.x11.opt.debug.64" "linux_x11_64_debug"
mv "godot.x11.opt.debug.64" "linux_x11_32_debug"
cp "godot.x11.opt.64" "linux_x11_64_release"
mv "godot.x11.opt.64" "linux_x11_32_release"

zip -r9 "$ARTIFACTS_DIR/templates/linux.zip" \
    "linux_x11_64_debug" \
    "linux_x11_32_debug" \
    "linux_x11_64_release" \
    "linux_x11_32_release"
