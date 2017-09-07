#!/usr/bin/env bash

FZF_DIR="$HOME/.fzf"

## DO NOT CHANGE BELOW

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../scripts/_helpers.sh"

info "Trying to install fzf"

if [ -d $FZF_DIR ]
then
    fail "Cannot install fzf as the folder ($FZF_DIR) already exists"
fi

mkdir -p $FZF_DIR
pushd $FZF_DIR > /dev/null

info "Checking out source..."
git clone --quiet https://github.com/junegunn/fzf .

info "Installing fzf binary..."
./install --bin 3>&1 2>&1 > /dev/null

success "Finished installing fzf"

popd > /dev/null
