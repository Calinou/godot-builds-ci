#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$DIR/_common.sh"

# Install dependencies and prepare stuff before building

if [[ -f "/etc/redhat-release" ]]; then
  # Fedora
  dnf install -yq git cmake scons pkgconfig gcc-c++ curl libxml2-devel libX11-devel \
      libXcursor-devel libXrandr-devel libXinerama-devel mesa-libGL-devel \
      alsa-lib-devel pulseaudio-libs-devel freetype-devel \
      libudev-devel mesa-libGLU-devel openssh-clients \
      zip unzip ncurses-compat-libs wine xz lbzip2 libXi-devel python
else
  # Ubuntu
  apt-get update -qq
  apt-get install -qqq software-properties-common
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
  apt-get update -qq

  # SCons will be installed using pip so it can use Python 3.
  apt-get install -qqq git cmake zip unzip build-essential pkg-config \
      libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libcairo2 \
      libglu-dev libasound2-dev libpulse-dev libfreetype6-dev \
      libssl-dev libudev-dev libxrandr-dev libxi-dev curl \
      gcc-9 g++-9 python3-pip
  pip3 install --user scons
  # Ensure SCons uses Python 3 by replacing the shebang.
  sed -i "s:#! /usr/bin/env python:#! /usr/bin/python3:" "$HOME/.local/bin/scons"
fi

git clone --depth 1 --branch "$GODOT_REPO_BRANCH" "$GODOT_REPO_URL"
mkdir -p "$ARTIFACTS_DIR"/{editor,server,templates}/

# Print information about the commit to build
printf -- "-%.0s" {0..72}
echo ""
git -C "$CI_PROJECT_DIR/godot/" log --max-count 1
printf -- "-%.0s" {0..72}
echo ""
