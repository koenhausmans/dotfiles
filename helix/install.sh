#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config/helix/themes/
ln -s $BASEDIR/config.toml ~/.config/helix/config.toml
ln -s $BASEDIR/languages.toml ~/.config/helix/languages.toml
ln -s $BASEDIR/themes/sonokai_shusia.toml ~/.config/helix/themes/sonokai_shusia.toml
