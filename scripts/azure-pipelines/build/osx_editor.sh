#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

# Build macOS editor
scons platform=osx tools=yes target=release_debug \
      "${SCONS_FLAGS[@]}"

# Create macOS editor DMG image
mkdir -p "godot_dmg/"
cp -r "misc/dist/osx_tools.app/" "godot_dmg/Godot.app/"
mkdir -p "godot_dmg/Godot.app/Contents/MacOS/"
cp "bin/godot.osx.opt.tools.64" "godot_dmg/Godot.app/Contents/MacOS/Godot"
git clone "https://github.com/andreyvit/create-dmg.git" --depth=1
(
  cd "create-dmg/"
  ./create-dmg \
      --volname "Godot" \
      --volicon "../godot_dmg/Godot.app/Contents/Resources/Godot.icns" \
      --hide-extension "Godot.app" \
      "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/godot-macos-nightly-x86_64.dmg" \
      "../godot_dmg/"
)
