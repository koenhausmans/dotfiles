#!/usr/bin/env bash
# Based on: https://github.com/holman/dotfiles/blob/master/script/install

# Enable unofficial bash strict mode
set -euo pipefail
IFS=$'\n\t'

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/lib/helpers.sh"

if (( $# > 0 )); then
    fail 'Usage: ./install.sh'
fi

# Check for root permissions
if [ "$(whoami)" == "root" ] ; then
    fail "Please execute without root permissions!"
fi

DOTFILES_SYNCED_REPOS_FILE=$(mktemp)
trap 'rm -f -- "$DOTFILES_SYNCED_REPOS_FILE"' EXIT
export DOTFILES_SYNCED_REPOS_FILE

info 'Running installer scripts'

install_all=false
# Only these top-level components are allowed to supply install scripts.
for component in bash zsh fish git tmux screen vim nvim fzf themes; do
    installer="$BASEDIR/$component/install.sh"
    [[ -f $installer ]] || continue

    if [[ $install_all != true ]]; then
        if ! ( : </dev/tty ) 2>/dev/null; then
            fail "Cannot choose installers without a terminal"
        fi
        while :; do
            user "Do you want to install \e[1;36m$component/install.sh\e[0m?\n        \e[0;32m[y]\e[0mes, \e[1;32m[Y]\e[0mes to all, \e[0;34m[n]\e[0mo?"
            if ! IFS= read -r -n 1 action < /dev/tty; then
                fail "No choice received for $component/install.sh"
            fi
            printf '\n'
            case $action in
                y|Y|n) break ;;
                *) user 'Enter y, Y, or n.' ;;
            esac
        done
        [[ $action == Y ]] && install_all=true
        [[ $action == n ]] && continue
    fi

    info "Installing \e[1m$component/install.sh\e[0m"
    if "$installer"; then
        success "Finished installing \e[1m$component/install.sh\e[0m"
    else
        fail "Error while executing \e[1m$component/install.sh\e[0m"
    fi
done
