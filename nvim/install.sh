#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

source "$BASEDIR/../scripts/_links.sh"

mkdir -p "$config_home/nvim"
link_files "$BASEDIR/init.vim" "$config_home/nvim/init.vim"
