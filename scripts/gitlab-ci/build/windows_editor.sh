#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

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
      "${SCONS_FLAGS[@]}"

# Install innoextract (used to extract Inno Setup without using a virtual X display)
tmp="$(mktemp)"
curl -fsSL \
    "http://constexpr.org/innoextract/files/snapshots/innoextract-1.8-dev-2018-09-09/innoextract-1.8-dev-2018-09-09-linux.tar.xz" \
    -o "$tmp"
tar xf "$tmp"
mv innoextract* /opt/innoextract/

# Install Inno Setup and create a launcher script
curl -fsSLO "http://files.jrsoftware.org/is/5/innosetup-5.6.1-unicode.exe"
/opt/innoextract/innoextract -md "/opt/innosetup" "innosetup-5.6.1-unicode.exe"
echo "wine \"/opt/innosetup/app/ISCC.exe\" \"\$@\"" \
    > "/usr/local/bin/iscc"
chmod +x "/usr/local/bin/iscc"

# Create Windows editor installers and ZIP archives
cd "$GODOT_DIR/bin/"
cp "$CI_PROJECT_DIR/resources/innosetup"/* "."
strip "godot.windows.opt.tools.$bits.exe"

mv "godot.windows.opt.tools.$bits.exe" "godot.exe"
zip -r9 "godot-windows-nightly-$suffix.zip" "godot.exe"

if [[ "$bits" == "64" ]]; then
  iscc "godot.iss"
else
  iscc "godot.iss" /DApp32Bit
fi

mv \
    "godot-windows-nightly-$suffix.zip" \
    "Output/godot-setup-nightly-$suffix.exe" \
    "$ARTIFACTS_DIR/editor/"
