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

# The target type ("debug" or "release")
target="$1"

if [[ "$target" == "debug" ]]; then
  scons_target="release_debug"
else
  scons_target="release"
fi

# Install the Emscripten SDK
git clone --depth=1 "https://github.com/juj/emsdk.git" "$GODOT_DIR/emsdk/"
cd "$GODOT_DIR/emsdk/"
./emsdk install latest
./emsdk activate latest
export EMSCRIPTEN_ROOT
EMSCRIPTEN_ROOT="$(em-config EMSCRIPTEN_ROOT || true)"
cd "$GODOT_DIR/"

# Build HTML5 export template
scons platform=javascript tools=no target="$scons_target" \
      "${SCONS_FLAGS[@]}"

# Move HTML5 export template to the artifacts directory
mv "$GODOT_DIR/bin"/godot.javascript.*.zip \
    "$ARTIFACTS_DIR/templates/webassembly_$target.zip"
