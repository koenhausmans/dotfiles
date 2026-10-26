#!/usr/bin/env bash

source "$(dirname -- "${BASH_SOURCE[0]}")/helpers.sh"

_link_display_path() {
    local path=$1
    if [[ -n ${HOME:-} ]]; then
        case $path in
            "$HOME") printf '~' ; return ;;
            "$HOME"/*) printf '~%s' "${path#"$HOME"}" ; return ;;
        esac
    fi
    printf '%s' "$path"
}

# Link source/destination pairs. Uppercase choices apply to later conflicts in
# this installer process, or across components when install.sh shares a choice
# file. Matching symlinks are always left alone.
link_files() {
    if (( $# % 2 != 0 )); then
        printf 'link_files requires source/destination pairs\n' >&2
        return 2
    fi

    local src dst display_src display_dst action backup
    local all_action=${_dotfiles_link_all_action:-} choice_file=${DOTFILES_LINK_CHOICE_FILE:-}
    if [[ -n $choice_file ]]; then
        all_action=$(< "$choice_file")
        case $all_action in
            ''|s|o|b) ;;
            *) printf 'Invalid shared link choice\n' >&2; return 1 ;;
        esac
    fi
    while (( $# > 0 )); do
        src=$1
        dst=$2
        shift 2
        display_src=$(_link_display_path "$src")
        display_dst=$(_link_display_path "$dst")

        if [[ -L $dst && $(readlink -- "$dst") == "$src" ]]; then
            info 'Already linked: %s' "$display_dst"
            continue
        fi

        if [[ -e $dst || -L $dst ]]; then
            action=$all_action
            if [[ -z $action ]]; then
                if ! ( : </dev/tty ) 2>/dev/null; then
                    printf 'Cannot choose what to do with %s without a terminal\n' "$display_dst" >&2
                    return 1
                fi
                while :; do
                    user 'File already exists: \e[1;36m%s\e[0m' "$display_dst" > /dev/tty
                    printf '       Link from: %s\n' "$display_src" > /dev/tty
                    printf '       \033[0;34m[s]\033[0mkip  \033[1;34m[S]\033[0mkip all  \033[0;31m[o]\033[0mverwrite  \033[1;31m[O]\033[0mverwrite all  \033[0;32m[b]\033[0mackup  \033[1;32m[B]\033[0mackup all? ' > /dev/tty
                    if ! IFS= read -r action < /dev/tty; then
                        printf 'No choice received for %s\n' "$display_dst" >&2
                        return 1
                    fi
                    case $action in
                        [sSoObB]) break ;;
                        *) user 'Enter s, S, o, O, b, or B.' > /dev/tty ;;
                    esac
                done
                case $action in
                    [SOB])
                        all_action=${action,,}
                        _dotfiles_link_all_action=$all_action
                        if [[ -n $choice_file ]]; then
                            printf '%s\n' "$all_action" > "$choice_file" || return 1
                        fi
                        ;;
                esac
            fi

            case $action in
                [sS])
                    info 'Skipped: %s' "$display_dst"
                    continue
                    ;;
                [bB])
                    backup="$dst.backup"
                    if [[ -e $backup || -L $backup ]]; then
                        printf 'Backup already exists: %s\n' "$(_link_display_path "$backup")" >&2
                        return 1
                    fi
                    mv -- "$dst" "$backup"
                    success 'Backed up: %s' "$(_link_display_path "$backup")"
                    ;;
                [oO])
                    if [[ -d $dst && ! -L $dst ]]; then
                        printf 'Cannot overwrite directory: %s (use backup or skip)\n' "$display_dst" >&2
                        return 1
                    fi
                    rm -- "$dst"
                    ;;
            esac
        fi

        ln -s -- "$src" "$dst"
        success 'Linked: %s -> %s' "$display_dst" "$display_src"
    done
}

# Ubuntu installs some tools under other names to avoid package conflicts
link_tool() {
    local name=$1 ubuntu_name=$2 target
    if [[ -L $HOME/.local/bin/$name ]] || ! command -v "$name" > /dev/null; then
        if target=$(command -v "$ubuntu_name"); then
            mkdir -p "$HOME/.local/bin"
            link_files "$target" "$HOME/.local/bin/$name"
        else
            info 'Skipping %s: neither %s nor %s is installed' "$name" "$name" "$ubuntu_name"
        fi
    else
        success 'Already available: %s' "$name"
    fi
}
