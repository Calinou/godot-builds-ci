#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build Windows editor
for bits in "64" "32"; do
  scons platform=windows bits=$bits tools=yes target=release_debug use_lto=yes \
        $SCONS_FLAGS
done

# Install Inno Setup and set the path to the Inno Setup compiler
curl -O "http://files.jrsoftware.org/is/5/innosetup-5.6.1-unicode.exe"
wine "innosetup-5.6.1-unicode.exe" "/VERYSILENT" || true
export ISCC="$HOME/.wine/drive_c/Program Files (x86)/Inno Setup 5/ISCC.exe"

# Create Windows editor installers and ZIP archives
cd "$GODOT_DIR/bin/"
cp "$CI_PROJECT_DIR/resources/godot.iss" "godot.iss"
strip "godot.windows.opt.tools.64.exe" "godot.windows.opt.tools.32.exe"

mv "godot.windows.opt.tools.64.exe" "godot.exe"
zip -r9 "godot-windows-nightly-x86_64.zip" "godot.exe"
wine "$ISCC" "godot.iss"
rm "godot.exe"

mv "godot.windows.opt.tools.32.exe" "godot.exe"
zip -r9 "godot-windows-nightly-x86.zip" "godot.exe"
wine "$ISCC" "godot.iss" /DApp32Bit
rm "godot.exe"

mv \
    "godot-windows-nightly-x86_64.zip" \
    "godot-windows-nightly-x86.zip" \
    "Output/godot-setup-nightly-x86_64.exe" \
    "Output/godot-setup-nightly-x86.exe" \
    "$ARTIFACTS_DIR/editor/"
