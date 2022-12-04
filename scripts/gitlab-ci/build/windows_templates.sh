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

# The target type ("debug" or "release")
target="$1"

if [[ "$target" == "debug" ]]; then
  scons_target="template_debug"
else
  scons_target="template_release"
fi

# The target x86 architecture (can be "64" or "32")
bits="$2"

# Install llvm-mingw.
# This is required to build the `master` branch as MinGW 8.0 or later is now needed.
curl -LO https://github.com/mstorsjo/llvm-mingw/releases/download/20201020/llvm-mingw-20201020-ucrt-ubuntu-18.04.tar.xz
tar xvf llvm-mingw-20201020-ucrt-ubuntu-18.04.tar.xz
mv llvm-mingw-20201020-ucrt-ubuntu-18.04 /opt/llvm-mingw
export PATH="/opt/llvm-mingw/bin:$PATH"

# Build Windows export templates
scons platform=windows bits="$bits" target="$scons_target" use_llvm=yes \
      "${SCONS_FLAGS[@]}"

strip bin/godot.windows.*.exe

# Move Windows export templates to the artifacts directory
mv "$GODOT_DIR/bin"/godot.windows.*.exe "$ARTIFACTS_DIR/templates/windows_${bits}_${target}.exe"
