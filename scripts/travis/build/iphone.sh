#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build iOS export templates
# Compile only 64-bit ARM binaries, as all Apple devices supporting
# OpenGL ES 3.0 have 64-bit ARM processors anyway
# An empty `data.pck` file must be included in the export template ZIP as well
for target in "release_debug" "release"; do
  scons platform=iphone arch=arm64 tools=no target=$target \
        "${SCONS_FLAGS[@]}"
done

# Create iOS export templates ZIP archive
mv "bin/libgodot.iphone.opt.debug.arm64.a" "libgodot.iphone.debug.fat.a"
mv "bin/libgodot.iphone.opt.arm64.a" "libgodot.iphone.release.fat.a"
touch "data.pck"
zip -9 "$ARTIFACTS_DIR/templates/iphone.zip" "libgodot.iphone.debug.fat.a" "libgodot.iphone.release.fat.a" "data.pck"
