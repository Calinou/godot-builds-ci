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

# Install the Emscripten SDK
wget -q "https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz"
tar xf "emsdk-portable.tar.gz"
cd "$GODOT_DIR/emsdk-portable/"
./emsdk update
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
export EMSCRIPTEN_ROOT
EMSCRIPTEN_ROOT="$(em-config EMSCRIPTEN_ROOT)"
cd "$GODOT_DIR/"

# Build HTML5 export template
scons platform=javascript tools=no target="$target" \
      $SCONS_FLAGS

# Move HTML5 export template to the artifacts directory
mv "$GODOT_DIR/bin"/godot.javascript.*.zip \
    "$ARTIFACTS_DIR/templates/webassembly_$target.zip"
