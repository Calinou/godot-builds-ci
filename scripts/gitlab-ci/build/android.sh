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

# The target type ("debug" or "release")
target="$1"

if [[ "$target" == "debug" ]]; then
  scons_target="template_debug"
else
  scons_target="template_release"
fi

# Install OpenJDK
dnf install -yq java-1.8.0-openjdk-devel

# Install the Android SDK
mkdir -p "$CI_PROJECT_DIR/android/"
cd "$CI_PROJECT_DIR/android/"
curl -fsSLO "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
unzip -q sdk-tools-linux-*.zip
rm sdk-tools-linux-*.zip
export ANDROID_HOME="$CI_PROJECT_DIR/android"

# Install Android SDK components

mkdir -p "$HOME/.android"
echo "count=0" > "$HOME/.android/repositories.cfg"
{ yes | "$ANDROID_HOME/tools/bin/sdkmanager" --licenses || true; } > /dev/null
{ yes | "$ANDROID_HOME/tools/bin/sdkmanager" "tools" "platform-tools" "build-tools;28.0.3" || true; } > /dev/null

# Install the Android NDK
curl -fsSLO "https://dl.google.com/android/repository/android-ndk-r20-linux-x86_64.zip"
unzip -q android-ndk-*-linux-x86_64.zip
rm android-ndk-*-linux-x86_64.zip
mv ./*ndk* ndk/
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk"

cd "$GODOT_DIR/"

# Build Android export template
for arch in "armv7" "arm64v8"; do
scons platform=android target="$scons_target" android_arch="$arch" \
      "${SCONS_FLAGS[@]}"
done

cd "$GODOT_DIR/platform/android/java/"

# `master` or `vulkan` branch
# Create an APK
./gradlew generateGodotTemplates

# Move the generated Android source ZIP (for the new exporting method).
# This one will contain only one AAR depending on the current target,
# so we have to copy the current AAR to a temporary location for merging
# in the `deploy` job.
mv "$GODOT_DIR/bin/android_source.zip" \
  "$ARTIFACTS_DIR/templates/"

# Move the generated Android AAR to a temporary location, so that both AARs
# can be added to the final `android_source.zip`
mkdir -p "$ARTIFACTS_DIR/libs/$target/"
mv "$GODOT_DIR/platform/android/java/app/libs/$target/godot-lib.$target.aar" \
    "$ARTIFACTS_DIR/libs/$target/"

# Move the generated APK to the artifacts directory
mv "$GODOT_DIR/bin/android_$target.apk" \
      "$ARTIFACTS_DIR/templates/"
