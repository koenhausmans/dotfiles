#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/links.sh"

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p -- "$config_home/bat" "$config_home/opencode"
link_files \
    "$BASEDIR/bat/config" "$config_home/bat/config" \
    "$BASEDIR/markdownlint/markdownlintrc" "$HOME/.markdownlintrc" \
    "$BASEDIR/opencode/AGENTS.md" "$config_home/opencode/AGENTS.md"

# Use the existing JSON format when JSONC is absent, rather than adding a second config.
config="$config_home/opencode/opencode.jsonc"
if [[ ! -e $config && ! -L $config ]] &&
    [[ -e $config_home/opencode/opencode.json || -L $config_home/opencode/opencode.json ]]; then
    config="$config_home/opencode/opencode.json"
fi

copy_files \
    "$BASEDIR/opencode/opencode.jsonc" "$config" \
    "$BASEDIR/opencode/cli.json" "$config_home/opencode/cli.json"
