#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

source "$BASEDIR/../lib/links.sh"

mkdir -p -- "$config_dir"
link_files "$BASEDIR/AGENTS.md" "$config_dir/AGENTS.md"

# Use the existing JSON format when JSONC is absent, rather than adding a second config.
config="$config_dir/opencode.jsonc"
if [[ ! -e $config && ! -L $config ]] &&
   [[ -e $config_dir/opencode.json || -L $config_dir/opencode.json ]]; then
    config="$config_dir/opencode.json"
fi

copy_files \
    "$BASEDIR/opencode.jsonc" "$config" \
    "$BASEDIR/cli.json" "$config_dir/cli.json"
