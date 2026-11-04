#!/usr/bin/env bash
set -euo pipefail

ZOXIDE_REPO="https://github.com/ajeetdsouza/zoxide"
ZOXIDE_VERSION=0.10.0
ZOXIDE_BIN="$HOME/.local/bin/zoxide"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASEDIR/../lib/helpers.sh"

installed=$("$ZOXIDE_BIN" --version 2> /dev/null || true)
if [[ $installed == "zoxide $ZOXIDE_VERSION" ]]; then
    success "zoxide $ZOXIDE_VERSION is already installed"
else
    for command in curl tar sha256sum; do
        command -v "$command" > /dev/null || fail "Cannot install zoxide: $command is not available"
    done

    [[ $(uname -s) == Linux ]] || fail "Cannot install zoxide: only Linux binaries are configured"
    machine=$(uname -m)
    # Digests from the upstream release assets; update these with the version.
    case $machine in
        x86_64)
            arch=x86_64
            checksum=2d93385b99f3e82cf2701609a1bffcad863fbeb75aa3fe7eb6be4d29be68b1ae
            ;;
        aarch64|arm64)
            arch=aarch64
            checksum=f1f16c5d6298d63dee467eedea1cdcd8490e43e493bea43acd416dc9033ef641
            ;;
        *) fail "Cannot install zoxide: no binary for architecture $machine" ;;
    esac

    tmp=$(mktemp -d)
    trap 'rm -rf -- "$tmp"' EXIT
    asset="zoxide-$ZOXIDE_VERSION-$arch-unknown-linux-musl.tar.gz"
    info "Downloading zoxide $ZOXIDE_VERSION..."
    curl -fsSL --retry 3 -o "$tmp/$asset" "$ZOXIDE_REPO/releases/download/v$ZOXIDE_VERSION/$asset" \
        || fail "Could not download $asset"
    (cd "$tmp" && sha256sum --check --status <<< "$checksum  $asset") \
        || fail "Checksum mismatch for $asset"
    tar -xzf "$tmp/$asset" -C "$tmp" || fail "Could not unpack $asset"

    mkdir -p "$(dirname "$ZOXIDE_BIN")"
    install -m 755 "$tmp/zoxide" "$ZOXIDE_BIN" || fail "Could not install zoxide to $ZOXIDE_BIN"
    success "Installed zoxide $ZOXIDE_VERSION"
fi

# Import only during installation, never during shell startup. A marker avoids
# adding the same ranks again when both shell installers run or setup is rerun.
data_dir=${_ZO_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zoxide}
legacy_data=${_Z_DATA:-$HOME/.z}
marker="$data_dir/.dotfiles-z-imported"
if [[ -s $legacy_data && -f $legacy_data && ! -e $marker ]]; then
    info "Importing z.sh history from $legacy_data..."
    _ZO_DATA_DIR="$data_dir" _Z_DATA="$legacy_data" "$ZOXIDE_BIN" import --merge z \
        || fail "Could not import z.sh history"
    mkdir -p "$data_dir"
    touch "$marker"
    success "Imported z.sh history (original data preserved)"
fi
