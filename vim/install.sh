#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/helpers.sh"
source "$BASEDIR/../lib/links.sh"

if [[ ${DOTFILES_PROFILE-full} == server ]]; then
    link_files "$BASEDIR/vimrc.minimal" "$HOME/.vimrc"

    echo "Installing apprentice colorscheme for vim..."
    mkdir -p ~/.vim/colors/
    pushd ~/.vim/colors/ > /dev/null
    wget --quiet https://raw.githubusercontent.com/romainl/Apprentice/master/colors/apprentice.vim
    popd > /dev/null
else
    link_files "$BASEDIR/vimrc" "$HOME/.vimrc"
fi
