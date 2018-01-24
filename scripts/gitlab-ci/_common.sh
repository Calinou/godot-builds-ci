#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# This script is always sourced before any other script

# The build date in YYYY-MM-DD format (UTC)
export BUILD_DATE
BUILD_DATE="$(date -u +%Y-%m-%d)"

# The directory where build artifacts are stored
export ARTIFACTS_DIR
ARTIFACTS_DIR="$GODOT_DIR/$BUILD_DATE"
