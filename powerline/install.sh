#!/bin/bash
######################################################
######################################################
#
# Powerline Install Script
#
# by Koen Hausmans (KH) (koen@hausmans.nl)
#
######################################################
######################################################


sudo pip install git+git://github.com/Lokaltog/powerline

TMP_DIR=`mktemp -d`
pushd $TMP_DIR

if [ ! -f /usr/share/fonts/PowerlineSymbols.otf ]
then
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
fi

if [ ! -f /etc/fonts/conf.d/10-powerline-symbols.conf ]
then
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
fi

popd

rm -rf $TMP_DIR

