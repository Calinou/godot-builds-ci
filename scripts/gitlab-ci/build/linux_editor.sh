#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Use recent GCC provided by the Ubuntu Toolchain PPA
export CC="gcc-7"
export CXX="g++-7"

# Build Linux editor
# Link OpenSSL statically to avoid a build error
scons platform=x11 tools=yes target=release_debug builtin_openssl=yes use_static_cpp=yes $SCONS_FLAGS

# Create Linux editor AppImage
strip "bin/godot.x11.opt.tools.64"
mkdir -p "appdir/usr/bin/" "appdir/usr/share/icons"
cp "bin/godot.x11.opt.tools.64" "appdir/usr/bin/godot"
cp "misc/dist/appimage/godot.desktop" "appdir/godot.desktop"
cp "icon.svg" "appdir/usr/share/icons/godot.svg"
wget -q "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod +x "linuxdeployqt-continuous-x86_64.AppImage"
./linuxdeployqt-continuous-x86_64.AppImage --appimage-extract
./squashfs-root/AppRun "appdir/godot.desktop" -appimage

mv "Godot_Engine-x86_64.AppImage" "$ARTIFACTS_DIR/editor/godot-linux-x86_64.AppImage"
