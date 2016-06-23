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

if ! `hash zsh 2>/dev/null` ; then
    fail "Cannot find zsh binary"
fi


# Install oh my zsh
if [ ! -d $HOME/.oh-my-zsh ]
then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    #curl -L http://install.ohmyz.sh | sh
    rm ~/.zshrc
fi

# Change the shell
#sudo -u koen chsh --shell /bin/zsh
