#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$DIR/../_common.sh"

# Build macOS export templates
for target in "release_debug" "release"; do
  scons platform=osx tools=no target=$target \
        "${SCONS_FLAGS[@]}"
done

strip bin/godot.osx.*.64

# Create macOS export templates ZIP archive
mv "misc/dist/osx_template.app/" "osx_template.app/"
mkdir -p "osx_template.app/Contents/MacOS/"
mv "bin/godot.osx.opt.debug.64" "osx_template.app/Contents/MacOS/godot_osx_debug.64"
mv "bin/godot.osx.opt.64" "osx_template.app/Contents/MacOS/godot_osx_release.64"
zip -r9 "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates/osx.zip" "osx_template.app/"
