#!/bin/bash

verify_tmux_version() {
    tmux_home="$DOTFILES/tmux/"
    tmux_version="$(tmux -V | cut -d ' ' -f2 | sed 's/[a\.]//g')"

    if [[ "$tmux_version" -ge 19 ]] ; then
        tmux source-file "$tmux_home/tmux_ge_19.conf"
    else
        tmux source-file "$tmux_home/tmux_lt_19.conf"
    fi

    if [[ "tmux_version" -ge 21 ]] ; then
        tmux source-file "$tmux_home/tmux_ge_21.conf"
    else
        tmux source-file "$tmux_home/tmux_lt_21.conf"
    fi
}

verify_tmux_version
