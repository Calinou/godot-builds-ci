#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Install dependencies and prepare stuff before building

if [[ -f "/etc/redhat-release" ]]; then
  # Fedora
  dnf install -yq git cmake scons pkgconfig gcc-c++ curl libxml2-devel libX11-devel \
      libXcursor-devel libXrandr-devel libXinerama-devel mesa-libGL-devel \
      alsa-lib-devel pulseaudio-libs-devel freetype-devel \
      libudev-devel mesa-libGLU-devel mingw32-gcc-c++ mingw64-gcc-c++ \
      mingw32-winpthreads-static mingw64-winpthreads-static yasm openssh-clients \
      zip unzip ncurses-compat-libs wine xz innoextract
else
  # Ubuntu
  apt-get update -qq
  apt-get install -qqq software-properties-common
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
  apt-get update -qq

  apt-get install -qqq git cmake zip unzip build-essential scons pkg-config \
      libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libcairo2 \
      libglu-dev libasound2-dev libpulse-dev libfreetype6-dev \
      libssl-dev libudev-dev libxrandr-dev libxi-dev curl yasm \
      gcc-8 g++-8
fi

git clone --depth=1 "$GODOT_REPO_URL"
mkdir -p "$ARTIFACTS_DIR/"{editor,server,templates}/

# Copy user-supplied modules into the Godot directory
# (don't fail in case no modules are present)
cp "$CI_PROJECT_DIR"/modules/* "$GODOT_DIR/modules/" || true

# Print information about the commit to build
printf -- "-%.0s" {0..72}
echo ""
git -C "$CI_PROJECT_DIR/godot/" log --max-count 1
printf -- "-%.0s" {0..72}
echo ""
