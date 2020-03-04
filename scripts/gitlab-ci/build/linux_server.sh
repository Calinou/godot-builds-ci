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

# Use recent GCC provided by the Ubuntu Toolchain PPA
export CC="gcc-8"
export CXX="g++-8"

# Build Linux dedicated server
scons platform=server tools=no target=release \
      use_static_cpp=yes \
      "${SCONS_FLAGS[@]}"

# Create Linux dedicated server .tar.xz archive
cd "$GODOT_DIR/bin/"
strip "godot_server.x11.opt.64"
mv "godot_server.x11.opt.64" "godot-server"
tar cfJ "$ARTIFACTS_DIR/server/godot-linux-server-nightly-x86_64.tar.xz" "godot-server"

make_manifest "$ARTIFACTS_DIR/server/godot-linux-server-nightly-x86_64.tar.xz"
