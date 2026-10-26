#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/links.sh"

link_tool fd fdfind
