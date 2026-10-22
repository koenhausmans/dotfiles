#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/helpers.sh"
source "$BASEDIR/../lib/links.sh"

if ! ( : </dev/tty ) 2>/dev/null; then
    fail "Cannot choose a Vim configuration without a terminal"
fi

while :; do
    user 'Use the minimal Vim configuration without plugins? \e[0;32m[y]\e[0mes, \e[0;34m[n]\e[0mo?'
    if ! IFS= read -r -n 1 minimal < /dev/tty; then
        fail "No choice received for the Vim configuration"
    fi
    printf '\n'
    case $minimal in
        y|n) break ;;
        *) user 'Enter y or n.' ;;
    esac
done

if [[ $minimal == y ]]; then
    link_files "$BASEDIR/vimrc.minimal" "$HOME/.vimrc"

    echo "Installing apprentice colorscheme for vim..."
    mkdir -p ~/.vim/colors/
    pushd ~/.vim/colors/ > /dev/null
    wget --quiet https://raw.githubusercontent.com/romainl/Apprentice/master/colors/apprentice.vim
    popd > /dev/null
else
    link_files "$BASEDIR/vimrc" "$HOME/.vimrc"
fi
