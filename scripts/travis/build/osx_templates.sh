#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build macOS export templates
# Pretend 64-bit templates to be fat binaries, just in case
scons platform=osx bits=64 tools=no target=release_debug $OPTIONS
scons platform=osx bits=64 tools=no target=release $OPTIONS

# Create macOS export templates ZIP archive
mv "misc/dist/osx_template.app/" "osx_template.app/"
mkdir -p "osx_template.app/Contents/MacOS/"
mv "bin/godot.osx.opt.debug.64" "osx_template.app/Contents/MacOS/godot_osx_debug.fat"
mv "bin/godot.osx.opt.64" "osx_template.app/Contents/MacOS/godot_osx_release.fat"
zip -r9 "$ARTIFACTS_DIR/templates/osx.zip" "osx_template.app/"
