#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
themes_dir="$config_home/opencode/themes"

source "$BASEDIR/../../lib/links.sh"

if ! command -v opencode > /dev/null; then
    info 'OpenCode is not installed, skipping its themes'
    exit 0
fi

links=()
for theme in "$BASEDIR"/*.json; do
    links+=("$theme" "$themes_dir/${theme##*/}")
done

mkdir -p "$themes_dir"
link_files "${links[@]}"
