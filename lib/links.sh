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

# Install source/destination pairs. Uppercase choices apply to both links and
# copies in this process, or across components through the shared choice file.
link_files() {
    _install_files link "$@"
}

copy_files() {
    _install_files copy "$@"
}

_install_diff() {
    local src=$1 dst=$2 status target

    if [[ -L $dst ]]; then
        target=$(readlink -- "$dst") || return 1
        info 'Existing symlink: %s -> %s' "$(_link_display_path "$dst")" "$target"
    fi

    if [[ -f $src && -f $dst ]] || [[ -d $src && -d $dst ]]; then
        if diff -ru -- "$dst" "$src"; then
            info 'Contents are identical; the file type or link target may still differ.'
        else
            status=$?
            if (( status != 1 )); then
                return "$status"
            fi
        fi
    else
        info 'Cannot compare contents: paths are missing, have different types, or are not regular files/directories.'
        ls -ld -- "$dst" "$src" || return 1
    fi
}

_install_files() {
    local mode=$1 operation
    shift
    case $mode in
        link) operation=Link ;;
        copy) operation=Copy ;;
    esac

    if (( $# % 2 != 0 )); then
        printf '%s_files requires source/destination pairs\n' "$mode" >&2
        return 2
    fi

    local src dst display_src display_dst action backup link_target compare_status
    local all_action=${_dotfiles_link_all_action:-} choice_file=${DOTFILES_LINK_CHOICE_FILE:-}
    if [[ -n $choice_file ]]; then
        all_action=$(< "$choice_file") || {
            printf 'Cannot read shared file choice: %s\n' "$choice_file" >&2
            return 1
        }
        case $all_action in
            ''|s|o|b) ;;
            *) printf 'Invalid shared file choice\n' >&2; return 1 ;;
        esac
    fi
    while (( $# > 0 )); do
        src=$1
        dst=$2
        shift 2
        display_src=$(_link_display_path "$src")
        display_dst=$(_link_display_path "$dst")

        # Matching symlinks are left alone only when installing links.
        if [[ $mode == link && -L $dst ]]; then
            link_target=$(readlink -- "$dst") || {
                printf 'Cannot inspect existing link: %s\n' "$display_dst" >&2
                return 1
            }
            if [[ $link_target == "$src" ]]; then
                info 'Already linked: %s' "$display_dst"
                continue
            fi
        fi

        if [[ $mode == copy && -f $src && -f $dst ]]; then
            if cmp -s -- "$src" "$dst"; then
                info 'Already identical: %s' "$display_dst"
                continue
            else
                compare_status=$?
                if (( compare_status != 1 )); then
                    printf 'Cannot compare %s and %s\n' "$display_src" "$display_dst" >&2
                    return 1
                fi
            fi
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
                    printf '       %s from: %s\n' "$operation" "$display_src" > /dev/tty
                    printf '       \033[0;34m[s]\033[0mkip  \033[1;34m[S]\033[0mkip all  \033[0;31m[o]\033[0mverwrite  \033[1;31m[O]\033[0mverwrite all  \033[0;32m[b]\033[0mackup  \033[1;32m[B]\033[0mackup all  \033[1;34m[D]\033[0miff? ' > /dev/tty
                    if ! IFS= read -r action < /dev/tty; then
                        printf 'No choice received for %s\n' "$display_dst" >&2
                        return 1
                    fi
                    case $action in
                        [sSoObB]) break ;;
                        [dD])
                            if ! _install_diff "$src" "$dst" > /dev/tty 2>&1; then
                                user 'Could not display the full diff; choose skip to preserve the existing file.' > /dev/tty
                            fi
                            ;;
                        *) user 'Enter s, S, o, O, b, B, or D.' > /dev/tty ;;
                    esac
                done
                case $action in
                    [SOB])
                        all_action=${action,,}
                        _dotfiles_link_all_action=$all_action
                        if [[ -n $choice_file ]]; then
                            printf '%s\n' "$all_action" > "$choice_file" || {
                                printf 'Cannot save shared file choice: %s\n' "$choice_file" >&2
                                return 1
                            }
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
                    mv -- "$dst" "$backup" || {
                        printf 'Cannot back up %s to %s\n' "$display_dst" "$(_link_display_path "$backup")" >&2
                        return 1
                    }
                    success 'Backed up: %s' "$(_link_display_path "$backup")"
                    ;;
                [oO])
                    if [[ -d $dst && ! -L $dst ]]; then
                        printf 'Cannot overwrite directory: %s (use backup or skip)\n' "$display_dst" >&2
                        return 1
                    fi
                    rm -- "$dst" || {
                        printf 'Cannot remove %s\n' "$display_dst" >&2
                        return 1
                    }
                    ;;
            esac
        fi

        if [[ $mode == link ]]; then
            ln -s -- "$src" "$dst" || {
                printf 'Cannot link %s to %s\n' "$display_dst" "$display_src" >&2
                return 1
            }
            success 'Linked: %s -> %s' "$display_dst" "$display_src"
        else
            cp -- "$src" "$dst" || {
                printf 'Cannot copy %s to %s\n' "$display_src" "$display_dst" >&2
                return 1
            }
            success 'Copied: %s -> %s' "$display_src" "$display_dst"
        fi
    done
}

# Ubuntu installs some tools under other names to avoid package conflicts
link_tool() {
    local name=$1 ubuntu_name=$2 target
    if [[ -L $HOME/.local/bin/$name ]] || ! command -v "$name" > /dev/null; then
        if target=$(command -v "$ubuntu_name"); then
            mkdir -p "$HOME/.local/bin" || {
                printf 'Cannot create %s\n' "$(_link_display_path "$HOME/.local/bin")" >&2
                return 1
            }
            link_files "$target" "$HOME/.local/bin/$name"
        else
            info 'Skipping %s: neither %s nor %s is installed' "$name" "$name" "$ubuntu_name"
        fi
    else
        success 'Already available: %s' "$name"
    fi
}
