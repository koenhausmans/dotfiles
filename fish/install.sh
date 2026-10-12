#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
fish_dir="$config_home/fish"

source "$BASEDIR/../scripts/_links.sh"

mkdir -p "$fish_dir/conf.d" "$fish_dir/functions"
link_files \
    "$BASEDIR/config.fish" "$fish_dir/conf.d/dotfiles.fish" \
    "$BASEDIR/functions/__dotfiles_prompt_palette.fish" "$fish_dir/functions/__dotfiles_prompt_palette.fish" \
    "$BASEDIR/functions/__dotfiles_prompt_ascii.fish" "$fish_dir/functions/__dotfiles_prompt_ascii.fish" \
    "$BASEDIR/functions/fish_prompt.fish" "$fish_dir/functions/fish_prompt.fish" \
    "$BASEDIR/functions/fish_right_prompt.fish" "$fish_dir/functions/fish_right_prompt.fish"
