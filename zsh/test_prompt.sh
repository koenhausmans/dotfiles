#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/zsh-prompt.XXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

HOME="$sandbox" ZDOTDIR="$sandbox" ZSH_CONFIG="$BASEDIR/zshrc.symlink" zsh -f -c '
    source "$ZSH_CONFIG"
    precmd
    [[ $ZLE_RPROMPT_INDENT == 0 ]] || exit 1
    [[ $RPROMPT != *" %b%k%f" ]] || exit 1
    prompt_ascii=1
    precmd
    [[ $RPROMPT == \[git:* ]] || exit 1
'

echo 'Zsh right prompt checks passed'
