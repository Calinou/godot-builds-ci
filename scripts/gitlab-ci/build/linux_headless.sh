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

# Build Linux headless editor
scons platform=server tools=yes target=release_debug \
      use_static_cpp=yes \
      LINKFLAGS="-fuse-ld=gold" \
      "${SCONS_FLAGS[@]}"

# Create Linux headless editor .tar.xz archive
cd "$GODOT_DIR/bin/"
strip "godot_server.x11.opt.tools.64"
mv "godot_server.x11.opt.tools.64" "godot-headless"
tar cfJ "$ARTIFACTS_DIR/server/godot-linux-headless-nightly-x86_64.tar.xz" "godot-headless"

make_manifest "$ARTIFACTS_DIR/server/godot-linux-headless-nightly-x86_64.tar.xz"
