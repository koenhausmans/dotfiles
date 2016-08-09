#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd "$BASEDIR/powerline"

font_dir="$HOME/.local/share/fonts"
mkdir -p $font_dir

cp font/PowerlineSymbols.otf $font_dir
fc-cache -vf $font_dir

mkdir -p $HOME/.config/fontconfig/conf.d/
cp font/10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d/

popd

# Install the powerline fonts
$BASEDIR/fonts/install.sh

