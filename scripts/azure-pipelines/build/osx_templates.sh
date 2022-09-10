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

# Build macOS export templates
for target in "release_debug" "release"; do
  scons platform=osx tools=no target=$target \
      use_volk=no VULKAN_SDK_PATH="$HOME/VulkanSDK" \
      "${SCONS_FLAGS[@]}"
done

strip bin/godot.osx.*.x86_64

# Create macOS export templates ZIP archive
mv "misc/dist/osx_template.app/" "osx_template.app/"
mkdir -p "osx_template.app/Contents/MacOS/"
mv "bin/godot.osx.opt.debug.x86_64" "osx_template.app/Contents/MacOS/godot_osx_debug.x86_64"
mv "bin/godot.osx.opt.x86_64" "osx_template.app/Contents/MacOS/godot_osx_release.x86_64"
zip -r9 "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates/osx.zip" "osx_template.app/"
