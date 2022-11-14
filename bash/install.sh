#!/usr/bin/env bash

git_clone_or_pull () {
    repo_path="$1"
    repo_url="$2"
    if [[ -d "$repo_path" ]] ; then
        git -C "$repo_path" pull --quiet
    else
        git clone --quiet "$repo_url" "$repo_path"
    fi
}

Z_HOME="$HOME/.local/share/z/"
git_clone_or_pull "$Z_HOME" "https://github.com/rupa/z"

