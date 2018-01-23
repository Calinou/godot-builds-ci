# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# Install SCons and OpenSSH
# `--egg` is required for use with AppVeyor
pip install --egg scons
iex (New-Object net.webclient).downloadstring('https://get.scoop.sh')
scoop install win32-openssh

# Decrypt the SSH private key
nuget install secure-file -ExcludeVersion
secure-file\tools\secure-file -decrypt "resources\id_rsa_appveyor.enc" -secret $env:SSHKeyfilePassphrase -out "$env:USERPROFILE\.ssh\id_rsa"
# Copy the `known_hosts` file over so that it's used by the SCP client
Copy-Item "resources\known_hosts" "$env:USERPROFILE\.ssh\known_hosts"

# Clone Godot Git repository
$ErrorActionPreference = "SilentlyContinue"
git clone --depth=1 "https://github.com/godotengine/godot.git"
