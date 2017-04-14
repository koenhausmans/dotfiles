#!/usr/bin/env bash

FZF_DIR="$HOME/.fzf"

## DO NOT CHANGE BELOW

echo "Creating fzf folder..."

mkdir -p $FZF_DIR
pushd $FZF_DIR > /dev/null

echo "Checking out source..."
git clone --quiet https://github.com/junegunn/fzf .

echo "Installing fzf binary..."
./install --bin 3>&1 2>&1 > /dev/null

popd > /dev/null
