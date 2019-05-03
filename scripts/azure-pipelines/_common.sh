#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# This script is always sourced before any other script

# Writes a JSON manifest containing build information such as the commit hash
# the file was built from.
# FIXME: This function should be called in a Git repository for the
# commit hash retrieval to work.
make_manifest() {
  cat > "$1.manifest.json" << EOF
{
  "commit": "$(git rev-parse HEAD)",
  "sha256": "$(sha256sum "$1" | cut -d ' ' -f 1)"
}
EOF
}
