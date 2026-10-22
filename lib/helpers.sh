#!/usr/bin/env bash

# Set up helper functions for outputting to the command line
# A single message keeps the original %b formatting; a format plus arguments
# lets callers print paths as literal %s values without interpreting escapes.
_log_message () {
    if (( $# == 1 )); then
        printf '%b' "$1"
    else
        printf "$@"
    fi
}

info () {
    printf '\r  [ \033[00;34m..\033[0m ] '
    _log_message "$@"
    printf '\n'
}

user () {
    printf '\r  [ \033[0;33m??\033[0m ] '
    _log_message "$@"
    printf '\n'
}

success () {
    printf '\r\033[2K  [ \033[00;32mOK\033[0m ] '
    _log_message "$@"
    printf '\n'
}

fail () {
    {
        printf '\r\033[2K  [\033[0;31mFAIL\033[0m] '
        _log_message "$@"
        printf '\n\n'
    } >&2
    exit 1
}

# Clone a repository, or fast-forward it when it already exists. install.sh
# records each synced path in DOTFILES_SYNCED_REPOS_FILE so a repository that
# several installers need is synced only once per run.
git_clone_or_pull () {
    local repo_path=${1%/} repo_url=$2 synced_file=${DOTFILES_SYNCED_REPOS_FILE:-}

    if [[ -n $synced_file ]] && grep -qxF -- "$repo_path" "$synced_file"; then
        return 0
    fi

    if [[ -d $repo_path ]]; then
        git -C "$repo_path" pull --ff-only --quiet
    else
        git clone --quiet "$repo_url" "$repo_path"
    fi

    if [[ -n $synced_file ]]; then
        printf '%s\n' "$repo_path" >> "$synced_file"
    fi
}
