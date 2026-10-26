#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/links.sh"

# Ubuntu installs these tools under other names to avoid package conflicts
link_tool() {
    local name=$1 ubuntu_name=$2 target
    if [[ -L $HOME/.local/bin/$name ]] || ! command -v "$name" > /dev/null; then
        if target=$(command -v "$ubuntu_name"); then
            mkdir -p "$HOME/.local/bin"
            link_files "$target" "$HOME/.local/bin/$name"
        else
            info 'Skipping %s: neither %s nor %s is installed' "$name" "$name" "$ubuntu_name"
        fi
    else
        success 'Already available: %s' "$name"
    fi
}

link_tool fd fdfind
link_tool bat batcat
