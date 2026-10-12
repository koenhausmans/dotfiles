#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../scripts/_helpers.sh"

# Each installer checks whether its tool is installed and skips it otherwise.
for tool in claude-code opencode antigravity-cli; do
    info "Installing \e[1mthemes/$tool\e[0m"
    "$BASEDIR/$tool/install.sh" || fail "Error while installing \e[1mthemes/$tool\e[0m"
done
