#!/bin/bash

source scripts/print.sh

info "Installing bash"

if ! `hash bash 2>/dev/null` ; then
    sudo apt-get -y install bash
fi

if [ -f $HOME/.bashrc ]
then
    mv $HOME/.bashrc $HOME/.bashrc.backup
fi

