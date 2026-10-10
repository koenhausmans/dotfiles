#!/usr/bin/env bash

# Link source/destination pairs. Uppercase choices apply to later conflicts in
# this call; matching symlinks are always left alone.
link_files() {
    if (( $# % 2 != 0 )); then
        printf 'link_files requires source/destination pairs\n' >&2
        return 2
    fi

    local src dst action all_action='' backup
    while (( $# > 0 )); do
        src=$1
        dst=$2
        shift 2

        if [[ -L $dst && $(readlink -- "$dst") == "$src" ]]; then
            printf 'Already linked: %s\n' "$dst"
            continue
        fi

        if [[ -e $dst || -L $dst ]]; then
            action=$all_action
            if [[ -z $action ]]; then
                if ! ( : </dev/tty ) 2>/dev/null; then
                    printf 'Cannot choose what to do with %s without a terminal\n' "$dst" >&2
                    return 1
                fi
                while :; do
                    printf 'File already exists: %s (%s)\n' "$dst" "$(basename -- "$src")" > /dev/tty
                    printf '[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all? ' > /dev/tty
                    if ! IFS= read -r action < /dev/tty; then
                        printf 'No choice received for %s\n' "$dst" >&2
                        return 1
                    fi
                    case $action in
                        [sSoObB]) break ;;
                        *) printf 'Enter s, S, o, O, b, or B.\n' > /dev/tty ;;
                    esac
                done
                case $action in
                    [SOB]) all_action=${action,,} ;;
                esac
            fi

            case $action in
                [sS])
                    printf 'Skipped: %s\n' "$dst"
                    continue
                    ;;
                [bB])
                    backup="$dst.backup"
                    if [[ -e $backup || -L $backup ]]; then
                        printf 'Backup already exists: %s\n' "$backup" >&2
                        return 1
                    fi
                    mv -- "$dst" "$backup"
                    printf 'Backed up: %s\n' "$backup"
                    ;;
                [oO])
                    if [[ -d $dst && ! -L $dst ]]; then
                        printf 'Cannot overwrite directory: %s (use backup or skip)\n' "$dst" >&2
                        return 1
                    fi
                    rm -- "$dst"
                    ;;
            esac
        fi

        ln -s -- "$src" "$dst"
        printf 'Linked: %s -> %s\n' "$dst" "$src"
    done
}
