#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Create an export templates TPZ
cp "resources/version.txt" "$ARTIFACTS_DIR/templates/version.txt"
(
  cd "$ARTIFACTS_DIR/" &&
  7z a -r -mx9 \
      "$ARTIFACTS_DIR/templates/godot-templates-ios-macos-nightly.tpz"
     "templates/"
)

# Deploy to server using SCP
scp -r "$ARTIFACTS_DIR"/* hugo@hugo.pro:/var/www/archive.hugo.pro/builds/godot/
