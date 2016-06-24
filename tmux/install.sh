#!/bin/bash
######################################################
######################################################
#
# Vim Install Script   
#
# by Koen Hausmans (KH) (koen@hausmans.nl
#
######################################################
######################################################

function version_gt() {
    test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1";
}

source scripts/print.sh

info "Installing tmux"
if ! `hash tmux 2>/dev/null` ; then
    sudo apt-get -y install tmux
fi

info "Checking Tmux version number"

TMUX_VERSION=`tmux -V | cut -d' ' -f 2`
if ! version_gt "$TMUX_VERSION" "1.9" ; then
    # The #{pane_current_path} functionality is not supported in version lower than 1.9
    # See: http://stackoverflow.com/questions/25940944/ugrade-tmux-from-1-8-to-1-9-on-ubuntu-14-04 on how to update
    fail "Tmux version is lower than 1.9: Not all features supported!"
fi

