#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Install dependencies and prepare stuff before building

# Documentation is always built on Fedora
dnf install -yq \
    git wget zip unzip python3-pip make curl texlive-latex-bin \
    texlive-dvipng-bin which

pip3 install --user sphinx sphinx_rtd_theme

git clone --depth 1 --branch 3.1 "https://github.com/godotengine/godot-docs.git"
mkdir -p "$ARTIFACTS_DIR/docs"

# Print information about the commit to build
printf -- "-%.0s" {0..72}
echo ""
git -C "$CI_PROJECT_DIR/godot-docs/" log --max-count 1
printf -- "-%.0s" {0..72}
echo ""
