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
wget -q "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
unzip -q ./*.zip
rm ./*.zip
mkdir -p "licenses/"
cp "$CI_PROJECT_DIR/resources/android-sdk-license" "licenses/"
export ANDROID_HOME="$CI_PROJECT_DIR/android"

# Install the Android NDK
wget -q "https://dl.google.com/android/repository/android-ndk-r18-linux-x86_64.zip"
unzip -q ./*.zip
rm ./*.zip
mv ./*ndk* ndk/
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk"
cd "$GODOT_DIR/"

# Build Android export template
scons platform=android tools=no target="$scons_target" \
      "${SCONS_FLAGS[@]}"

# Create an APK and move it to the artifacts directory
cd "$GODOT_DIR/platform/android/java/"
./gradlew build
mv "$GODOT_DIR/bin/android_$target.apk" \
    "$ARTIFACTS_DIR/templates/"
