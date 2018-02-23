#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build macOS export templates
for target in "release_debug" "release"; do
  scons platform=osx tools=no target=$target \
        $SCONS_FLAGS
done

# Create macOS export templates ZIP archive
mkdir -p "templates/"
mv "misc/dist/osx_template.app/" "osx_template.app/"
mkdir -p "osx_template.app/Contents/MacOS/"
mv "bin/godot.osx.opt.debug" "osx_template.app/Contents/MacOS/godot_osx_debug"
mv "bin/godot.osx.opt" "osx_template.app/Contents/MacOS/godot_osx_release"
zip -r9 "templates/osx.zip" "osx_template.app/"
zip -r9 "$ARTIFACTS_DIR/templates/godot-templates-macos-nightly.tpz" "templates/"
