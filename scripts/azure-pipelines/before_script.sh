#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$DIR/_common.sh"

# Install dependencies and upgrade to Bash 4
# coreutils is needed to compute SHA-256 checksums
# (will be installed as `gsha256sum`)
brew update
brew install bash coreutils scons
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
sudo chsh -s "$(brew --prefix)/bin/bash"
"$(brew --prefix)/bin/bash" -c "cd $PWD"
git clone --depth 1 --branch "$GODOT_REPO_BRANCH" "$GODOT_REPO_URL"
mkdir -p "$BUILD_ARTIFACTSTAGINGDIRECTORY"/{editor,templates}/

# Print information about the commit to build
printf -- "-%.0s" {0..72}
echo ""
git -C "godot/" log --max-count 1
printf -- "-%.0s" {0..72}
echo ""
