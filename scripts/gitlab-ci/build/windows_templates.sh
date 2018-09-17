#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# The target type ("debug" or "release")
target="$1"

# The target x86 architecture (can be "64" or "32")
bits="$2"

# Build Windows export templates
scons platform=windows bits="$bits" tools=no target="$target" use_lto=yes \
      $SCONS_FLAGS

strip bin/godot.windows.*.exe

# Move Windows export templates to the artifacts directory
cp "$GODOT_DIR/bin"/godot.windows.*.exe "$ARTIFACTS_DIR/templates/windows_${bits}_${target}.exe"
