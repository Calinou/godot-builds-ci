#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# This script is always sourced before any other script

# The directory where build artifacts are stored
export ARTIFACTS_DIR
ARTIFACTS_DIR="$CI_PROJECT_DIR/artifacts"

# Disable WINE debugging for better performance and more concise output
export WINEDEBUG="-all"
