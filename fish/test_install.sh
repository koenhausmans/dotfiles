#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/fish-install.XXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

export HOME="$sandbox/home" XDG_CONFIG_HOME="$sandbox/xdg"
mkdir -p "$HOME" "$XDG_CONFIG_HOME/fish/conf.d" "$XDG_CONFIG_HOME/fish/functions"
printf 'set -gx ORIGINAL_CONFIG_LOADED yes\n' > "$XDG_CONFIG_HOME/fish/config.fish"

# An older install has the config and prompt links, but not the new helpers.
ln -s "$BASEDIR/config.fish" "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish"
ln -s "$BASEDIR/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
ln -s "$BASEDIR/functions/fish_right_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_right_prompt.fish"
"$BASEDIR/install.sh"
test "$(cat "$XDG_CONFIG_HOME/fish/config.fish")" = 'set -gx ORIGINAL_CONFIG_LOADED yes'
test "$(readlink "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish")" = "$BASEDIR/config.fish"
for file in __dotfiles_prompt_palette.fish __dotfiles_prompt_ascii.fish fish_prompt.fish fish_right_prompt.fish; do
    test "$(readlink "$XDG_CONFIG_HOME/fish/functions/$file")" = "$BASEDIR/functions/$file"
done
fish -c 'test "$ORIGINAL_CONFIG_LOADED" = yes; and test "$DOTFILES" = "$HOME/.dotfiles"'
fish -i -c 'fish_prompt; fish_right_prompt' >"$sandbox/prompt-output" 2>"$sandbox/prompt-errors"
test ! -s "$sandbox/prompt-errors"
fish -i -c 'fish_greeting; true' >"$sandbox/greeting-output"
test ! -s "$sandbox/greeting-output"

# Our own links are safe to install twice.
"$BASEDIR/install.sh"

# A different existing file requires a choice; without a terminal it stays put.
rm "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish"
printf 'user settings\n' > "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish"
if "$BASEDIR/install.sh" >"$sandbox/stdout" 2>"$sandbox/stderr"; then
    echo 'Expected installer to require a choice for an existing file' >&2
    exit 1
fi
test "$(cat "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish")" = 'user settings'
printf 'b\n' | script -q -e -c "$BASEDIR/install.sh" /dev/null >"$sandbox/terminal-output"
test "$(cat "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish.backup")" = 'user settings'
test "$(readlink "$XDG_CONFIG_HOME/fish/conf.d/dotfiles.fish")" = "$BASEDIR/config.fish"

# The default config directory works without XDG_CONFIG_HOME as well.
env -u XDG_CONFIG_HOME HOME="$sandbox/default-home" "$BASEDIR/install.sh"
test "$(readlink "$sandbox/default-home/.config/fish/conf.d/dotfiles.fish")" = "$BASEDIR/config.fish"

echo 'Fish installer checks passed'
