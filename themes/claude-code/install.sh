#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
themes_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/themes"

source "$BASEDIR/../../scripts/_links.sh"

if ! command -v claude > /dev/null; then
    info 'Claude Code is not installed, skipping its themes'
    exit 0
fi

links=()
for theme in "$BASEDIR"/*.json; do
    links+=("$theme" "$themes_dir/${theme##*/}")
done

mkdir -p "$themes_dir"
link_files "${links[@]}"
