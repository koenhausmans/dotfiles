#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config/nvim/
ln -s $BASEDIR/init.vim ~/.config/nvim/init.vim

