#!/usr/bin/env bash

# Print the integration branch: the dotfiles.target config, then develop,
# main or master, whichever exists locally first
git_target() {
    local Branch
    Branch=$(git config --get dotfiles.target || true)
    if [[ -n "$Branch" ]] && git show-ref --verify --quiet "refs/heads/$Branch"; then
        printf '%s\n' "$Branch"
        return 0
    fi
    for Branch in develop main master; do
        if git show-ref --verify --quiet "refs/heads/$Branch"; then
            printf '%s\n' "$Branch"
            return 0
        fi
    done
    printf 'No local develop, main or master branch found\n' >&2
    return 1
}
