#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build macOS editor
scons platform=osx bits=64 tools=yes target=release_debug $OPTIONS

# Create macOS editor ZIP archive
cd "bin/"
mv "godot.osx.opt.tools.64" "godot"
zip -r9 "$ARTIFACTS_DIR/editor/godot-osx-x86_64.zip" "godot"
