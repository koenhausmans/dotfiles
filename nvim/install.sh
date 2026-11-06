#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

source "$BASEDIR/../lib/links.sh"

mkdir -p "$config_home/nvim"

# Remove a stale init.vim link left over from before the Lua migration.
old_link="$config_home/nvim/init.vim"
if [[ -L $old_link && $(readlink -- "$old_link") == "$BASEDIR/init.vim" ]]; then
    rm -- "$old_link"
    info 'Removed stale link: %s' "$(_link_display_path "$old_link")"
fi

link_files "$BASEDIR/init.lua" "$config_home/nvim/init.lua"
