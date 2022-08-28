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

# Generate `version.txt` from `version.py`
curl -LO "https://raw.githubusercontent.com/godotengine/godot/master/version.py"
major=$(grep "major" version.py | cut -d" " -f3)
minor=$(grep "minor" version.py | cut -d" " -f3)
status=$(grep "status" version.py | cut -d" " -f3 | tr -d '"')
echo "$major.$minor.$status" > "$ARTIFACTS_DIR/templates/version.txt"

# Add both Android AARs to `android_source.zip`
# (see bottom of `build/android.sh` for details),
# then create an export templates TPZ.
# Allow failure for the Android libs ZIP, as it may not be present if the Android
# build failed.
(
  cd "$ARTIFACTS_DIR/"
  zip -r \
    "$ARTIFACTS_DIR/templates/android_source.zip" \
    "libs/" || true
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
scp -r "$ARTIFACTS_DIR"/* hugo@45.147.98.122:"/var/www/archive.hugo.pro/builds/godot/$GODOT_REPO_BRANCH/"
