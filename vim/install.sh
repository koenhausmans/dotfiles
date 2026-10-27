#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/helpers.sh"
source "$BASEDIR/../lib/links.sh"

if [[ ${DOTFILES_PROFILE-full} == server ]]; then
    link_files "$BASEDIR/vimrc.minimal" "$HOME/.vimrc"

    colors_dir="$HOME/.vim/colors"
    colorscheme="$colors_dir/apprentice.vim"
    echo "Installing apprentice colorscheme for vim..."
    mkdir -p -- "$colors_dir" || fail "Could not create $colors_dir"
    temporary=$(mktemp "$colors_dir/.apprentice.XXXXXXXX") || fail "Could not prepare colorscheme download"
    trap 'rm -f -- "$temporary"' EXIT
    wget --quiet -O "$temporary" https://raw.githubusercontent.com/romainl/Apprentice/master/colors/apprentice.vim \
        || fail "Could not download apprentice colorscheme"
    if [[ -e $colorscheme ]]; then
        chmod --reference="$colorscheme" "$temporary" || fail "Could not preserve colorscheme permissions"
    else
        chmod 644 -- "$temporary" || fail "Could not set colorscheme permissions"
    fi
    mv -- "$temporary" "$colorscheme" || fail "Could not install apprentice colorscheme"
else
    link_files "$BASEDIR/vimrc" "$HOME/.vimrc"
fi
