#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Install dependencies and prepare stuff before building

if [[ -f "/etc/redhat-release" ]]; then
  # Fedora
  dnf install -y git cmake scons pkgconfig gcc-c++ curl libxml2-devel libX11-devel \
      libXcursor-devel libXrandr-devel libXinerama-devel mesa-libGL-devel \
      alsa-lib-devel pulseaudio-libs-devel freetype-devel \
      libudev-devel mesa-libGLU-devel mingw32-gcc-c++ mingw64-gcc-c++ \
      mingw32-winpthreads-static mingw64-winpthreads-static yasm openssh-clients \
      wget zip unzip ncurses-compat-libs wine xz Xvfb
else
  # Ubuntu
  apt-get update -yqq
  apt-get install -yqq software-properties-common
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
  apt-get update -yqq

  apt-get install -y git cmake wget zip unzip build-essential scons pkg-config \
      libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev \
      libglu-dev libasound2-dev libpulse-dev libfreetype6-dev \
      libssl-dev libudev-dev libxrandr-dev libxi-dev yasm \
      gcc-8 g++-8
fi

git clone --depth=1 "$GODOT_REPO_URL"
mkdir -p "$ARTIFACTS_DIR/editor" "$ARTIFACTS_DIR/templates"

# Copy user-supplied modules into the Godot directory
# (don't fail in case no modules are present)
cp $CI_PROJECT_DIR/modules/* "$GODOT_DIR/modules/" || true
