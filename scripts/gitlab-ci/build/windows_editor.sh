#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# The target x86 architecture (can be "64" or "32")
bits="$1"

# The suffix to add to build products' file names
suffix="x86"

if [[ "$bits" == "64" ]]; then
  suffix="${suffix}_64"
fi

# Build Windows editor
scons platform=windows bits="$bits" tools=yes target=release_debug use_lto=yes \
      $SCONS_FLAGS

# Install Inno Setup and set the path to the Inno Setup compiler
curl -O "http://files.jrsoftware.org/is/5/innosetup-5.6.1-unicode.exe"
# Create a virtual X display (required to install Inno Setup)
Xvfb :0 & export DISPLAY=":0"
wine "innosetup-5.6.1-unicode.exe" "/VERYSILENT"
export ISCC="$HOME/.wine/drive_c/Program Files (x86)/Inno Setup 5/ISCC.exe"

# Create Windows editor installers and ZIP archives
cd "$GODOT_DIR/bin/"
cp "$CI_PROJECT_DIR/resources/godot.iss" "godot.iss"
strip "godot.windows.opt.tools.$bits.exe"

mv "godot.windows.opt.tools.$bits.exe" "godot.exe"
advzip --add --shrink-insane "godot-windows-nightly-$suffix.zip" "godot.exe"

if [[ "$bits" == "64" ]]; then
  wine "$ISCC" "godot.iss"
else
  wine "$ISCC" "godot.iss" /DApp32Bit
fi

mv \
    "godot-windows-nightly-$suffix.zip" \
    "Output/godot-setup-nightly-$suffix.exe" \
    "$ARTIFACTS_DIR/editor/"
