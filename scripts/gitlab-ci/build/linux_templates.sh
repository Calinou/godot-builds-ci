#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Use recent GCC provided by the Ubuntu Toolchain PPA
export CC="gcc-8"
export CXX="g++-8"

# Build Linux export templates
# Link libpng statically to avoid dependency issues
for target in "release_debug" "release"; do
  scons platform=x11 tools=no target=$target \
        builtin_libpng=yes use_static_cpp=yes \
        LINKFLAGS="-fuse-ld=gold" \
        $SCONS_FLAGS
done

strip bin/godot.x11.*.64

# Move Linux export templates to the artifacts directory
# Pretend 64-bit binaries are 32-bit binaries for now, to avoid errors
# in the editor's Export dialog
cp "$GODOT_DIR/bin/godot.x11.opt.debug.64" "$ARTIFACTS_DIR/templates/linux_x11_64_debug"
mv "$GODOT_DIR/bin/godot.x11.opt.debug.64" "$ARTIFACTS_DIR/templates/linux_x11_32_debug"
cp "$GODOT_DIR/bin/godot.x11.opt.64" "$ARTIFACTS_DIR/templates/linux_x11_64_release"
mv "$GODOT_DIR/bin/godot.x11.opt.64" "$ARTIFACTS_DIR/templates/linux_x11_32_release"
