#!/usr/bin/env bash

ZSH_PLUGIN_FOLDER="$HOME/.local/share/zsh-plugins/"

[[ ! -d "$ZSH_PLUGIN_FOLDER" ]] && mkdir -p "$ZSH_PLUGIN_FOLDER"

git_clone_or_pull () {
    repo_path="$1"
    repo_url="$2"
    if [[ -d "$repo_path" ]] ; then
        git -C "$repo_path" pull --quiet
    else
        git clone --quiet "$repo_url" "$repo_path"
    fi
}

git_clone_or_pull "$ZSH_PLUGIN_FOLDER/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
git_clone_or_pull "$ZSH_PLUGIN_FOLDER/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
git_clone_or_pull "$ZSH_PLUGIN_FOLDER/agnoster-zsh-theme" "https://github.com/agnoster/agnoster-zsh-theme"

Z_HOME="$HOME/.local/share/z/"
git_clone_or_pull "$Z_HOME" "https://github.com/rupa/z"

