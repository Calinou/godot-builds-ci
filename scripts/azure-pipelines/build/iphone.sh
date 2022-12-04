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

cp -r "$HOME/VulkanSDK/MoltenVK/MoltenVK.xcframework" misc/dist/ios_xcode/
rm -rf misc/dist/ios_xcode/MoltenVK.xcframework/{macos,tvos}*

# Build iOS export templates
# Compile only 64-bit ARM binaries, as all Apple devices supporting
# OpenGL ES 3.0 have 64-bit ARM processors anyway
# An empty `data.pck` file must be included in the export template ZIP as well
for target in "template_debug" "template_release"; do
  scons platform=iphone arch=arm64 target=$target \
        "${SCONS_FLAGS[@]}"
done

# Create iOS export templates ZIP archive
mv "bin/libgodot.iphone.template_debug.arm64.a" "libgodot.iphone.debug.fat.a"
mv "bin/libgodot.iphone.template_release.arm64.a" "libgodot.iphone.release.fat.a"
touch "data.pck"
zip -r9 \
    "$BUILD_ARTIFACTSTAGINGDIRECTORY/templates/iphone.zip" \
    "libgodot.iphone.debug.fat.a" \
    "libgodot.iphone.release.fat.a" \
    "data.pck"
