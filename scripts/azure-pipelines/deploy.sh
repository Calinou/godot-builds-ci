#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

# Create an export templates TPZ
cp "resources/version.txt" "$SYSTEM_ARTIFACTSDIRECTORY/godot/templates/version.txt"
(
  cd "$SYSTEM_ARTIFACTSDIRECTORY/godot/"
  zip -mr9 \
      "templates/godot-templates-ios-macos-nightly.tpz" \
      "templates/"
)

# Deploy to server using SCP
scp -r "$SYSTEM_ARTIFACTSDIRECTORY/godot"/* hugo@hugo.pro:/var/www/archive.hugo.pro/builds/godot/
