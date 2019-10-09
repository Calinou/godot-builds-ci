#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# coreutils is needed to compute SHA-256 checksums
# (will be installed as `gsha256sum`)
brew update
brew install coreutils

# Generate `version.txt` from `version.py`
curl -LO "https://raw.githubusercontent.com/godotengine/godot/3.1/version.py"
major=$(grep "major" version.py | cut -d" " -f3)
minor=$(grep "minor" version.py | cut -d" " -f3)
status=$(grep "status" version.py | cut -d" " -f3 | tr -d '"')
echo "$major.$minor.$status" > "$SYSTEM_ARTIFACTSDIRECTORY/godot/templates/version.txt"

# Create an export templates TPZ
(
  cd "$SYSTEM_ARTIFACTSDIRECTORY/godot/"
  zip -mr9 \
      "$SYSTEM_ARTIFACTSDIRECTORY/godot/templates/godot-templates-ios-macos-nightly.tpz" \
      "templates/"
)

make_template_manifest "$SYSTEM_ARTIFACTSDIRECTORY/godot/templates/godot-templates-ios-macos-nightly.tpz"

# Deploy to server using SCP
mkdir -p "$HOME/.ssh"
cp "resources/known_hosts" "$HOME/.ssh/"
scp -r "$SYSTEM_ARTIFACTSDIRECTORY/godot"/* hugo@hugo.pro:"/var/www/archive.hugo.pro/builds/godot/$GODOT_REPO_BRANCH/"
