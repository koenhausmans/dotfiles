#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/helpers.sh"
source "$BASEDIR/../lib/links.sh"

link_files \
    "$BASEDIR/bash_profile" "$HOME/.bash_profile" \
    "$BASEDIR/bashrc" "$HOME/.bashrc" \
    "$BASEDIR/inputrc" "$HOME/.inputrc"

git_clone_or_pull "$HOME/.local/share/z" "https://github.com/rupa/z"
