#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Use recent GCC provided by the Ubuntu Toolchain PPA
export CC="gcc-8"
export CXX="g++-8"

# The target type ("debug" or "release")
target="$1"

if [[ "$target" == "debug" ]]; then
  scons_target="release_debug"
else
  scons_target="release"
fi

# Build Linux export templates
# Link libpng statically to avoid dependency issues
scons platform=x11 tools=no target="$scons_target" \
        udev=yes builtin_libpng=yes use_static_cpp=yes \
        "${SCONS_FLAGS[@]}"

strip bin/godot.x11.*.64

# Move Linux export templates to the artifacts directory
# Pretend 64-bit binaries are 32-bit binaries for now, to avoid errors
# in the editor's Export dialog
cp "$GODOT_DIR/bin"/godot.x11.* "$ARTIFACTS_DIR/templates/linux_x11_64_${target}"
mv "$GODOT_DIR/bin"/godot.x11.* "$ARTIFACTS_DIR/templates/linux_x11_32_${target}"
