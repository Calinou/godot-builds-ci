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

# Download and mount the MoltenVK DMG to link it statically in the binaries compiled below.
VULKAN_SDK_VERSION="1.2.182.0"
curl -LO "https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VERSION/mac/vulkansdk-macos-$VULKAN_SDK_VERSION.dmg"
hdiutil attach "vulkansdk-macos-$VULKAN_SDK_VERSION.dmg"

# Build macOS editor
scons platform=osx tools=yes target=debug \
    use_static_mvk=yes VULKAN_SDK_PATH="/Volumes/vulkansdk-macos-$VULKAN_SDK_VERSION/" \
    "${SCONS_FLAGS[@]}"

# Create macOS editor DMG image
mkdir -p godot_dmg/
cp -r misc/dist/osx_tools.app/ godot_dmg/Godot.app/
mkdir -p godot_dmg/Godot.app/Contents/MacOS/

cp bin/godot.osx.tools.64 godot_dmg/Godot.app/Contents/MacOS/Godot
hdiutil create -volname Godot -srcfolder godot_dmg/Godot.app/ -ov "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/godot-macos-nightly-x86_64.dmg"

# Remove temporary uncompressed DMG image created by hdiutil.
rm "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/rw.godot-macos-nightly-x86_64.dmg"

make_manifest "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/godot-macos-nightly-x86_64.dmg"
