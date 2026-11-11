#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASEDIR/../lib/helpers.sh"

MISE_BIN="$HOME/.local/bin/mise"

data_dir=${_ZO_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zoxide}
legacy_data=${_Z_DATA:-$HOME/.z}
marker="$data_dir/.dotfiles-z-imported"
if [[ -s $legacy_data && -f $legacy_data && ! -e $marker ]]; then
    info "Importing z.sh history from $legacy_data..."
    _ZO_DATA_DIR="$data_dir" _Z_DATA="$legacy_data" "$MISE_BIN" exec -- zoxide import --merge z \
        || fail "Could not import z.sh history"
    mkdir -p "$data_dir"
    touch "$marker"
    success "Imported z.sh history (original data preserved)"
fi
