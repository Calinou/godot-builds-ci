#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# The target type ("debug" or "release")
target="$1"

if [[ "$target" == "debug" ]]; then
  scons_target="release_debug"
else
  scons_target="release"
fi

# Install OpenJDK
dnf install -yq java-1.8.0-openjdk-devel

# Install the Android SDK
mkdir -p "$CI_PROJECT_DIR/android/"
cd "$CI_PROJECT_DIR/android/"
curl -fsSLO "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
unzip -q ./*.zip
rm ./*.zip
mkdir -p "licenses/"
cp "$CI_PROJECT_DIR/resources/android-sdk-license" "licenses/"
export ANDROID_HOME="$CI_PROJECT_DIR/android"

# Install the Android NDK
curl -fsSLO "https://dl.google.com/android/repository/android-ndk-r19-linux-x86_64.zip"
unzip -q ./*.zip
rm ./*.zip
mv ./*ndk* ndk/
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk"
cd "$GODOT_DIR/"

# Install base Android SDK components
mkdir -p "$HOME/.android" && echo "count=0" > "$HOME/.android/repositories.cfg"
yes | "$ANDROID_HOME/tools/bin/sdkmanager" --licenses > /dev/null
yes | "$ANDROID_HOME/tools/bin/sdkmanager" "tools" > /dev/null
yes | "$ANDROID_HOME/tools/bin/sdkmanager" "platform-tools" > /dev/null
yes | "$ANDROID_HOME/tools/bin/sdkmanager" "build-tools;28.0.1" > /dev/null

# Build Android export template
for arch in "armv7" "arm64v8" "x86"; do
scons platform=android tools=no target="$scons_target" android_arch="$arch" \
      "${SCONS_FLAGS[@]}"
done

# Create an APK and move it to the artifacts directory
cd "$GODOT_DIR/platform/android/java/"
./gradlew build
mv "$GODOT_DIR/bin/android_$target.apk" \
    "$ARTIFACTS_DIR/templates/"
