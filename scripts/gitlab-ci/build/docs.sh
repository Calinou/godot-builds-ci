#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../_common.sh"

# Build documentation in HTML format
make html SPHINXBUILD="$HOME/.local/bin/sphinx-build"
mv "_build/html/" "docs/"
zip -r9 "$ARTIFACTS_DIR/docs/html.zip" "docs/"
