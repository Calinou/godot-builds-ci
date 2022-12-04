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

# Download and install the MoltenVK DMG to link it statically in the binaries compiled below.
VULKAN_SDK_VERSION="1.2.189.0"
curl -LO "https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VERSION/mac/vulkansdk-macos-$VULKAN_SDK_VERSION.dmg"
hdiutil attach "vulkansdk-macos-$VULKAN_SDK_VERSION.dmg"
sudo "/Volumes/vulkansdk-macos-$VULKAN_SDK_VERSION/InstallVulkan.app/Contents/MacOS/InstallVulkan" \
    --root "$HOME/VulkanSDK" --accept-licenses --default-answer --confirm-command install

# Build macOS editor
scons platform=osx target=editor debug_symbols=yes \
    use_volk=no VULKAN_SDK_PATH="$HOME/VulkanSDK" \
    "${SCONS_FLAGS[@]}"

# Create macOS editor DMG image
mkdir -p godot_dmg/
cp -r misc/dist/osx_tools.app/ godot_dmg/Godot.app/
mkdir -p godot_dmg/Godot.app/Contents/MacOS/

cp bin/godot.osx.editor.x86_64 godot_dmg/Godot.app/Contents/MacOS/Godot
hdiutil create -volname Godot -srcfolder godot_dmg/Godot.app/ -ov "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/godot-macos-nightly-x86_64.dmg"

make_manifest "$BUILD_ARTIFACTSTAGINGDIRECTORY/editor/godot-macos-nightly-x86_64.dmg"
