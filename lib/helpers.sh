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

# Clone a repository, or fast-forward a clean checkout with the expected
# origin. install.sh records synced paths so shared dependencies update once
# per run.
git_clone_or_pull () {
    if (( $# != 2 )); then
        printf 'git_clone_or_pull requires a path and repository URL\n' >&2
        return 2
    fi

    local repo_path=${1%/} repo_url=$2 synced_file=${DOTFILES_SYNCED_REPOS_FILE:-}
    local repo_root physical_path origin changes upstream upstream_branch repo_parent

    if [[ -n $synced_file && -e $synced_file ]]; then
        if grep -qxF -- "$repo_path" "$synced_file"; then
            return 0
        else
            local grep_status=$?
            if (( grep_status != 1 )); then
                printf 'Cannot read synced dependency list: %s\n' "$synced_file" >&2
                return 1
            fi
        fi
    fi

    if [[ -e $repo_path || -L $repo_path ]]; then
        if [[ ! -d $repo_path ]]; then
            printf 'Dependency path is not a directory: %s\n' "$repo_path" >&2
            return 1
        fi

        physical_path=$(cd -- "$repo_path" && pwd -P) || {
            printf 'Cannot access dependency path: %s\n' "$repo_path" >&2
            return 1
        }
        repo_root=$(git -C "$repo_path" rev-parse --show-toplevel 2>/dev/null) || {
            printf 'Dependency is not a Git checkout: %s\n' "$repo_path" >&2
            return 1
        }
        if [[ $repo_root != "$physical_path" ]]; then
            printf 'Dependency path is not the Git checkout root: %s\n' "$repo_path" >&2
            return 1
        fi

        origin=$(git -C "$repo_path" remote get-url origin 2>/dev/null) || {
            printf 'Dependency has no usable origin: %s\n' "$repo_path" >&2
            return 1
        }
        if [[ $origin != "$repo_url" ]]; then
            printf 'Dependency origin does not match %s: %s\n' "$repo_url" "$repo_path" >&2
            return 1
        fi

        changes=$(git -C "$repo_path" status --porcelain --untracked-files=all) || {
            printf 'Cannot inspect dependency working tree: %s\n' "$repo_path" >&2
            return 1
        }
        if [[ -n $changes ]]; then
            printf 'Dependency has local changes; refusing to update: %s\n' "$repo_path" >&2
            return 1
        fi

        upstream=$(git -C "$repo_path" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || {
            printf 'Dependency branch has no upstream: %s\n' "$repo_path" >&2
            return 1
        }
        case $upstream in
            origin/*) upstream_branch=${upstream#origin/} ;;
            *)
                printf 'Dependency branch does not track origin: %s\n' "$repo_path" >&2
                return 1
                ;;
        esac
        git -C "$repo_path" pull --ff-only --quiet origin "$upstream_branch" || {
            printf 'Could not fast-forward dependency: %s\n' "$repo_path" >&2
            return 1
        }
    else
        repo_parent=$(dirname -- "$repo_path") || {
            printf 'Cannot determine dependency parent directory: %s\n' "$repo_path" >&2
            return 1
        }
        mkdir -p -- "$repo_parent" || {
            printf 'Cannot create dependency parent directory: %s\n' "$repo_parent" >&2
            return 1
        }
        git clone --quiet "$repo_url" "$repo_path" || {
            printf 'Could not clone dependency from %s\n' "$repo_url" >&2
            return 1
        }
    fi

    if [[ -n $synced_file ]]; then
        printf '%s\n' "$repo_path" >> "$synced_file" || {
            printf 'Cannot record synced dependency: %s\n' "$synced_file" >&2
            return 1
        }
    fi
}
