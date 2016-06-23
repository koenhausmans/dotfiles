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

if ! `hash python 2>/dev/null` ; then
    info "Installing python"
    sudo apt-get -y install python
fi

if ! `hash pip 2>/dev/null` ; then
    info "Installing pip"
    sudo apt-get -y install python-pip
fi

info "Installing python setuptools"
sudo apt-get -y install python-setuptools

info "Installing powerline"
sudo pip install git+git://github.com/powerline/powerline

TMP_DIR=`mktemp -d`
pushd $TMP_DIR

if [ ! -f /usr/share/fonts/PowerlineSymbols.otf ]
then
    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
fi

if [ ! -f /etc/fonts/conf.d/10-powerline-symbols.conf ]
then
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
fi

popd
rm -rf $TMP_DIR

info "Installing powerline fonts"

TMP2_DIR=`mktemp -d`
pushd $TMP2_DIR

git clone https://github.com/powerline/fonts.git .
./install.sh

popd
rm -rf $TMP2_DIR

