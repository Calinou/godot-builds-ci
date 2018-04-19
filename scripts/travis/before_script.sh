#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Install dependencies
brew update
brew install scons yasm

git clone --depth=1 "$GODOT_REPO_URL"
mkdir -p "$ARTIFACTS_DIR/editor" "$ARTIFACTS_DIR/templates"

# Copy user-supplied modules into the Godot directory
# (don't fail in case no modules are present)
cp $TRAVIS_BUILD_DIR/modules/* "$GODOT_DIR/modules/" || true
