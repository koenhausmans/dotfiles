#!/bin/bash

## DO NOT CHANGE BELOW

# Get the current directory of this install script
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Include the helper functions
source "$BASEDIR/../scripts/_helpers.sh"

if ! hash fc-cache 2>/dev/null ; then
    fail "No font information commands found, therefore unnecessary to install additional fonts."
fi

# Define the font directory
FontDir="$HOME/.local/share/fonts"
mkdir -p $FontDir

# Define the font config directory
FontConfigDirectory="$HOME/.config/fontconfig/conf.d/"
mkdir -p $FontConfigDirectory

# Copy all local files from this repository
info "Installing fonts located in dotfiles repository..."
cp $BASEDIR/*.otf $FontDir

# Install some powerline fonts from github
FontsToInstall=("DejaVuSansMono" "DroidSansMono" "Inconsolata-g" "Inconsolata" "InconsolataDz" "RobotoMono" "SourceCodePro")
PowerlineFontsRepository="https://github.com/powerline/fonts.git"

TMPDIR=$(mktemp -d)
pushd $TMPDIR > /dev/null

info "Downloading powerline fonts from github..."
git clone --quiet $PowerlineFontsRepository .

for Font in "${FontsToInstall[@]}"
do
    info "Installing $Font..."

    find "$Font" -name "*.[o,t]tf" -type f -print0 | xargs -0 -I % cp "%" "$FontDir/"
done

popd > /dev/null
rm -rf $TMPDIR

# Install Powerline Symbols
PowerlineSymbolsConfig="https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf"
PowerlineSymbolsFont="https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf"

curl $PowerlineSymbolsConfig -o "$FontConfigDirectory/10-powerline-symbols.conf"
curl $PowerlineSymbolsFont -o "$FontConfigDirectory/PowerlineSymbols.otf"

# Update the font cache for the newly installed fonts
fc-cache -vf $FontDir
