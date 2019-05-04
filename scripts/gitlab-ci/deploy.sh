#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

# Generate `version.txt` from `version.py`
curl -LO "https://raw.githubusercontent.com/godotengine/godot/master/version.py"
major=$(grep "major" version.py | cut -d" " -f3)
minor=$(grep "minor" version.py | cut -d" " -f3)
status=$(grep "status" version.py | cut -d" " -f3 | tr -d '"')
echo "$major.$minor.$status" > "$ARTIFACTS_DIR/templates/version.txt"

# Create an export templates TPZ
(
  cd "$ARTIFACTS_DIR/"
  zip -mr9 \
      "$ARTIFACTS_DIR/templates/godot-templates-android-html5-linux-windows-nightly.tpz" \
      "templates/"
)

make_template_manifest "$ARTIFACTS_DIR/templates/godot-templates-android-html5-linux-windows-nightly.tpz"

# Deploy to server using SCP
# `$SSH_PRIVATE_KEY` is a secret variable defined in the GitLab CI settings
mkdir -p "$HOME/.ssh"
echo "$SSH_PRIVATE_KEY" > "$HOME/.ssh/id_rsa"
chmod 600 "$HOME/.ssh/id_rsa"
cp "$CI_PROJECT_DIR/resources/known_hosts" "$HOME/.ssh/"
scp -r "$ARTIFACTS_DIR"/* hugo@hugo.pro:/var/www/archive.hugo.pro/builds/godot/
