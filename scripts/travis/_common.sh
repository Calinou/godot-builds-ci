#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# This script is always sourced before any other script

# The directory where build artifacts are stored
export ARTIFACTS_DIR
ARTIFACTS_DIR="$TRAVIS_BUILD_DIR/artifacts"

# The directory the Godot Git repository will be cloned into
export GODOT_DIR
GODOT_DIR="$TRAVIS_BUILD_DIR/godot"

# The remote directory where intermediate build artifacts are stored
export REMOTE_TMP_DIR
REMOTE_TMP_DIR="/tmp/travis/godot"
