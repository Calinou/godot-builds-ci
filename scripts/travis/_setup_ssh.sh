#!/bin/bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

# This script sets up SSH credentials for use in Travis CI

mkdir -p "$HOME/.ssh/"
openssl aes-256-cbc \
    -K $encrypted_b98964ef663e_key \
    -iv $encrypted_b98964ef663e_iv \
    -in "$TRAVIS_BUILD_DIR/resources/id_rsa_travis.enc" \
    -out "$HOME/.ssh/id_rsa" \
    -d
chmod 600 "$HOME/.ssh/id_rsa"
cp "$TRAVIS_BUILD_DIR/resources/known_hosts" "$HOME/.ssh/"
