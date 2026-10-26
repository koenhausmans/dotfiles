#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/links.sh"

link_tool bat batcat

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/bat"
mkdir -p -- "$config_dir"
link_files "$BASEDIR/config" "$config_dir/config"
