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

if ! `hash curl 2>/dev/null` ; then
	fail "Cannot find curl binary"
fi

#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


