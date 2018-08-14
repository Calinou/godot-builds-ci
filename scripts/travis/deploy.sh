#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

"$DIR"/_setup_ssh.sh

# Fetch artifacts from the previous stage using SCP
scp -r hugo@hugo.pro:"$REMOTE_TMP_DIR" "$ARTIFACTS_DIR"

# Create an export templates TPZ
cp "$TRAVIS_BUILD_DIR/resources/version.txt" "$ARTIFACTS_DIR/templates/version.txt"
cd "$ARTIFACTS_DIR/"
zip -mr9 "$ARTIFACTS_DIR/templates/godot-templates-ios-macos-nightly.tpz" "templates/"
cd "$TRAVIS_BUILD_DIR/"

# Deploy to server using SCP
scp -r "$ARTIFACTS_DIR"/* hugo@hugo.pro:/var/www/archive.hugo.pro/builds/godot/
