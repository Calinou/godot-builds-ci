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

# The target type ("debug" or "release")
target="$1"

if [[ "$target" == "debug" ]]; then
  scons_target="template_debug"
else
  scons_target="template_release"
fi

# Build Linux export templates
# Link libpng statically to avoid dependency issues.
# Use recent GCC provided by the Ubuntu Toolchain PPA.
scons platform=linuxbsd target="$scons_target" \
      udev=yes builtin_libpng=yes use_static_cpp=yes \
      CC="gcc-9" CXX="g++-9" "${SCONS_FLAGS[@]}"

strip bin/godot.linuxbsd.*.x86_64

# Move Linux export templates to the artifacts directory.
# Pretend 64-bit binaries are 32-bit binaries to avoid errors in the editor's Export dialog.
# (There are no plans to add 32-bit Linux binaries to the build roster.)
cp "$GODOT_DIR/bin"/godot.linuxbsd.* "$ARTIFACTS_DIR/templates/linux_x11_x86_64_${target}"
mv "$GODOT_DIR/bin"/godot.linuxbsd.* "$ARTIFACTS_DIR/templates/linux_x11_x86_32_${target}"
