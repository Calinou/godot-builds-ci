#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Install dependencies and prepare stuff before building

# Documentation is always built on Fedora
dnf install -y git wget zip unzip python3-pip make curl texlive-latex-bin \
               texlive-dvipng-bin which
pip3 install --user sphinx sphinx_rtd_theme

git clone --depth=1 "https://github.com/godotengine/godot-docs.git"
mkdir -p "$ARTIFACTS_DIR/docs"
