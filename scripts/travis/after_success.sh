#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# This script deploys intermediate artifacts to a SFTP server

set -euo pipefail

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/_common.sh"

"$DIR"/_setup_ssh.sh

# Deploy to server using SCP
scp -r "$ARTIFACTS_DIR"/* hugo@hugo.pro:"$REMOTE_TMP_DIR"
