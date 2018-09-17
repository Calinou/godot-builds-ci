#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# The target type ("debug" or "release")
target="$1"

# Install OpenJDK
dnf install -y java-1.8.0-openjdk-devel

# Install the Android SDK
mkdir -p "$CI_PROJECT_DIR/android/"
cd "$CI_PROJECT_DIR/android/"
wget -q "https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
unzip -q "sdk-tools-linux-3859397.zip"
rm "sdk-tools-linux-3859397.zip"
mkdir -p "licenses/"
cp "$CI_PROJECT_DIR/resources/android-sdk-license" "licenses/"
export ANDROID_HOME="$CI_PROJECT_DIR/android"

# Install the Android NDK
wget -q "https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip"
unzip -q "android-ndk-r16b-linux-x86_64.zip"
rm "android-ndk-r16b-linux-x86_64.zip"
export ANDROID_NDK_ROOT="$ANDROID_HOME/android-ndk-r16b"
cd "$GODOT_DIR/"

# Build Android export template
scons platform=android tools=no target="$target" \
      $SCONS_FLAGS

# Create an APK and move it to the artifacts directory
cd "$GODOT_DIR/platform/android/java/"
./gradlew build
mv "$GODOT_DIR/bin/android_$target.apk" \
    "$ARTIFACTS_DIR/templates/"
