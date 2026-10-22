#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_PLUGIN_FOLDER="$HOME/.local/share/zsh-plugins"

source "$BASEDIR/../lib/helpers.sh"
source "$BASEDIR/../lib/links.sh"

mkdir -p "$ZSH_PLUGIN_FOLDER"
link_files "$BASEDIR/zshrc" "$HOME/.zshrc"

git_clone_or_pull "$ZSH_PLUGIN_FOLDER/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
git_clone_or_pull "$ZSH_PLUGIN_FOLDER/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
git_clone_or_pull "$ZSH_PLUGIN_FOLDER/agnoster-zsh-theme" "https://github.com/agnoster/agnoster-zsh-theme"
git_clone_or_pull "$HOME/.local/share/z" "https://github.com/rupa/z"
