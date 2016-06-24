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

source scripts/print.sh

if ! `hash vim 2>/dev/null` ; then
    info "Installing vim"
    sudo apt-get -y install vim
fi

if ! `hash curl 2>/dev/null` ; then
    info "Installing curl"
    sudo apt-get -y install curl

    if ! `hash curl 2>/dev/null` ; then
        fail "Cannot find curl binary"
    fi
fi


