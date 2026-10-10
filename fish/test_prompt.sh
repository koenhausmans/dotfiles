#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/fish-prompt.XXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

export HOME="$sandbox/home" XDG_CONFIG_HOME="$sandbox/xdg" TERM=xterm-256color
"$BASEDIR/install.sh" >"$sandbox/install-output"
git init -q -b main "$sandbox/repo"
printf 'tracked\n' > "$sandbox/repo/tracked"
git -C "$sandbox/repo" add tracked
git -C "$sandbox/repo" -c user.name=Test -c user.email=test@example.invalid commit -qm initial
cd "$sandbox/repo"

# Match the RGB backgrounds from the four zsh palettes.
background_escape() {
    local hex=$1
    printf '\033[48;2;%d;%d;%dm' \
        "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"
}

foreground_escape() {
    local hex=$1
    printf '\033[38;2;%d;%d;%dm' \
        "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"
}

for theme in \
    'kanagawa 1f1f28 7e9cd8 76946a c0a36e c34043' \
    'sonokai 2c2e34 76cce0 9ed072 e7c664 f85e84' \
    'gruvbox-material 1d2021 83a598 b8bb26 fabd2f fb4934' \
    'tokyo-night 1a1b26 7aa2f7 9ece6a e0af68 f7768e'; do
    read -r name base path clean dirty red <<< "$theme"
    printf 'set -g fish_prompt_theme %s\n' "$name" > "$XDG_CONFIG_HOME/fish/config.local.fish"

    fish -i -c 'fish_prompt; fish_right_prompt' > "$sandbox/output"
    grep -F -- "$(background_escape "$path")" "$sandbox/output" > /dev/null
    grep -F -- "$(background_escape "$clean")" "$sandbox/output" > /dev/null
    grep -F ' main' "$sandbox/output" > /dev/null

    fish -i -c 'false; fish_prompt' > "$sandbox/output"
    grep -F -- "$(background_escape "$base")" "$sandbox/output" > /dev/null
    grep -F -- "$(foreground_escape "$red")" "$sandbox/output" > /dev/null
    grep -F '✘' "$sandbox/output" > /dev/null

    printf 'untracked\n' > untracked
    fish -i -c 'fish_right_prompt' > "$sandbox/output"
    grep -F -- "$(background_escape "$dirty")" "$sandbox/output" > /dev/null
    grep -F '±' "$sandbox/output" > /dev/null
    rm untracked

done

# A tracked upstream makes a local commit appear ahead of it.
git branch base main
git branch --set-upstream-to=base main > /dev/null
printf 'updated\n' >> tracked
git add tracked
git -c user.name=Test -c user.email=test@example.invalid commit -qm ahead
for theme in \
    'kanagawa 957fb8' \
    'sonokai b39df3' \
    'gruvbox-material d3869b' \
    'tokyo-night bb9af7'; do
    read -r name diverged <<< "$theme"
    printf 'set -g fish_prompt_theme %s\n' "$name" > "$XDG_CONFIG_HOME/fish/config.local.fish"
    fish -i -c 'fish_right_prompt' > "$sandbox/output"
    grep -F -- "$(background_escape "$diverged")" "$sandbox/output" > /dev/null
    grep -F '↑1' "$sandbox/output" > /dev/null
done

# Both ahead and behind use the divergence background.
git switch -q -c behind base
git branch --set-upstream-to=main behind > /dev/null
fish -i -c 'fish_right_prompt' > "$sandbox/output"
grep -F '↓1' "$sandbox/output" > /dev/null
grep -F -- "$(background_escape bb9af7)" "$sandbox/output" > /dev/null
git switch -q main

printf 'dirty\n' > untracked
fish -i -c 'fish_right_prompt' > "$sandbox/output"
grep -F -- "$(background_escape e0af68)" "$sandbox/output" > /dev/null
rm untracked

printf 'stashed\n' >> tracked
git -c user.name=Test -c user.email=test@example.invalid stash push -qm test
fish -i -c 'fish_right_prompt' > "$sandbox/output"
grep -F ' S ' "$sandbox/output" > /dev/null

git switch -q -c 'percent%branch'
fish -i -c 'fish_right_prompt' > "$sandbox/output"
grep -F 'percent%branch' "$sandbox/output" > /dev/null

git switch -q --detach HEAD
fish -i -c 'fish_right_prompt' > "$sandbox/output"
grep -F '➦' "$sandbox/output" > /dev/null

printf 'set -g fish_prompt_ascii 1\n' >> "$XDG_CONFIG_HOME/fish/config.local.fish"
fish -i -c 'false; fish_prompt; printf "\n"; fish_right_prompt' > "$sandbox/output"
grep -F '[exit:1]' "$sandbox/output" > /dev/null
grep -F '[git:detached ' "$sandbox/output" > /dev/null
if grep -F '' "$sandbox/output" > /dev/null; then
    echo 'ASCII mode printed a Powerline separator' >&2
    exit 1
fi

printf 'set -g fish_prompt_ascii 0\n' >> "$XDG_CONFIG_HOME/fish/config.local.fish"
TERM=linux fish -i -c 'fish_prompt; fish_right_prompt' > "$sandbox/output"
grep -F '[git:detached ' "$sandbox/output" > /dev/null
if grep -F '' "$sandbox/output" > /dev/null; then
    echo 'Linux console mode printed a Powerline separator' >&2
    exit 1
fi

cd "$sandbox"
fish -i -c 'fish_right_prompt' > "$sandbox/output"
test ! -s "$sandbox/output"

echo 'Fish prompt checks passed'
