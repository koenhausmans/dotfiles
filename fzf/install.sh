#!/usr/bin/env bash
set -euo pipefail

FZF_DIR="$HOME/.fzf"

## DO NOT CHANGE BELOW

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../scripts/_helpers.sh"

info "Trying to install fzf"

if [[ -e $FZF_DIR ]]; then
    if [[ ! -d $FZF_DIR/.git && ! -f $FZF_DIR/.git ]]; then
        fail "Cannot update fzf: $FZF_DIR is not a Git checkout"
    fi
    origin=$(git -C "$FZF_DIR" remote get-url origin) || fail "Cannot identify fzf checkout at $FZF_DIR"
    case $origin in
        https://github.com/junegunn/fzf|https://github.com/junegunn/fzf.git|git@github.com:junegunn/fzf.git) ;;
        *) fail "Cannot update fzf: unexpected origin $origin" ;;
    esac
    info "Updating fzf..."
    git -C "$FZF_DIR" pull --ff-only --quiet || fail "Could not update fzf"
else
    info "Checking out source..."
    git clone --quiet https://github.com/junegunn/fzf "$FZF_DIR" || fail "Could not clone fzf"
fi

info "Installing fzf binary..."
"$FZF_DIR/install" --bin || fail "Could not install fzf binary"

success "Finished installing fzf"
