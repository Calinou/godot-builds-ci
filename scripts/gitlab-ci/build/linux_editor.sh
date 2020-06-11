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

# Required to find pip-installed SCons
export PATH="$HOME/.local/bin:$PATH"

# Build Linux editor
# Use recent GCC provided by the Ubuntu Toolchain PPA.
scons platform=linuxbsd tools=yes target=debug \
      udev=yes use_static_cpp=yes \
      CC="gcc-9" CXX="g++-9" "${SCONS_FLAGS[@]}"

# Create Linux editor ZIP archive.
cd "$GODOT_DIR/bin/"
strip "godot.linuxbsd.tools.64"
mv "godot.linuxbsd.tools.64" "godot"
zip -r9 "$ARTIFACTS_DIR/editor/godot-linux-nightly-x86_64.zip" "godot"

make_manifest "$ARTIFACTS_DIR/editor/godot-linux-nightly-x86_64.zip"
