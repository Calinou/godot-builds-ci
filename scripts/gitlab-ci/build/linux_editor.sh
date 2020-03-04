#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build Linux editor
# Use recent GCC provided by the Ubuntu Toolchain PPA.
scons platform=x11 tools=yes target=release_debug \
      udev=yes use_static_cpp=yes \
      CC="gcc-9" CXX="g++-9" "${SCONS_FLAGS[@]}"

# Create Linux editor AppImage
strip "bin/godot.x11.opt.tools.64"
mkdir -p "appdir/usr/bin/" "appdir/usr/share/icons/hicolor/scalable/apps/"
cp "bin/godot.x11.opt.tools.64" "appdir/usr/bin/godot"
cp "misc/dist/linux/org.godotengine.Godot.desktop" "appdir/godot.desktop"
cp "icon.svg" "appdir/usr/share/icons/hicolor/scalable/apps/godot.svg"
curl -fsSLO "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod +x "linuxdeployqt-continuous-x86_64.AppImage"
./linuxdeployqt-continuous-x86_64.AppImage \
    --appimage-extract-and-run \
    "appdir/godot.desktop" -appimage

mv \
    "Godot_Engine-"*"-x86_64.AppImage" \
    "$ARTIFACTS_DIR/editor/godot-linux-nightly-x86_64.AppImage"

make_manifest "$ARTIFACTS_DIR/editor/godot-linux-nightly-x86_64.AppImage"
