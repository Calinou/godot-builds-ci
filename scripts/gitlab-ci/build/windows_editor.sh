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

# The target x86 architecture (can be "64" or "32")
bits="$1"

# The suffix to add to build products' file names
suffix="x86"

if [[ "$bits" == "64" ]]; then
  suffix="${suffix}_64"
fi

# Install llvm-mingw.
# This is required to build the `master` branch as MinGW 8.0 or later is now needed.
curl -LO https://github.com/mstorsjo/llvm-mingw/releases/download/20201020/llvm-mingw-20201020-ucrt-ubuntu-18.04.tar.xz
tar xvf llvm-mingw-20201020-ucrt-ubuntu-18.04.tar.xz
mv llvm-mingw-20201020-ucrt-ubuntu-18.04 /opt/llvm-mingw
export PATH="/opt/llvm-mingw/bin:$PATH"

# Build Windows editor
scons platform=windows bits="$bits" target=editor debug_symbols=yes use_llvm=yes \
      "${SCONS_FLAGS[@]}"

# Install innoextract (used to extract Inno Setup without using a virtual X display)
tmp="$(mktemp)"
curl -fsSL \
    "https://constexpr.org/innoextract/files/innoextract-1.9-linux.tar.xz" \
    -o "$tmp"
tar xf "$tmp"
mv innoextract* /opt/innoextract/

# Install Inno Setup and create a launcher script
curl -fsSLO "https://files.jrsoftware.org/is/6/innosetup-6.0.5.exe"
/opt/innoextract/innoextract -md "/opt/innosetup" "innosetup-6.0.5.exe"
echo "wine \"/opt/innosetup/app/ISCC.exe\" \"\$@\"" \
    > "/usr/local/bin/iscc"
chmod +x "/usr/local/bin/iscc"

# Create Windows editor installers and ZIP archives
cd "$GODOT_DIR/bin/"
cp "$CI_PROJECT_DIR/resources/innosetup"/* "."

mv "godot.windows.editor.x86_$bits.exe" "godot.exe"
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

make_manifest "$ARTIFACTS_DIR/editor/godot-windows-nightly-$suffix.zip"
make_manifest "$ARTIFACTS_DIR/editor/godot-setup-nightly-$suffix.exe"
