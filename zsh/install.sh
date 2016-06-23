#!/bin/bash
######################################################
######################################################
#
# Zsh Install Script
#
# by Koen Hausmans (KH) (koen@hausmans.nl)
#
######################################################
######################################################

source scripts/print.sh

if ! `hash zsh 2>/dev/null` ; then
    info "Installing zsh binary"
    sudo apt-get -y install zsh 2>/dev/null

    if ! `hash zsh 2>/dev/null` ; then
        fail "Cannot find zsh binary"
    fi
fi


# Install oh my zsh
if [ ! -d $HOME/.oh-my-zsh ]
then
    info "Installing oh-my-zsh"    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    #curl -L http://install.ohmyz.sh | sh
    rm ~/.zshrc
fi

# Change the shell
#sudo -u koen chsh --shell /bin/zsh
