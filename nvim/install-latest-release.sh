#!/usr/bin/env bash
set -euo pipefail

NVIM_REPO="https://github.com/neovim/neovim"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASEDIR/../lib/helpers.sh"

for command in curl tar uname mktemp sudo; do
    command -v "$command" > /dev/null || fail "Cannot install Neovim: $command is not available"
done

[[ $(uname -s) == Linux ]] || fail "This installer supports Linux only"
machine=$(uname -m)
case $machine in
    x86_64) asset=nvim-linux-x86_64 ;;
    aarch64|arm64) asset=nvim-linux-arm64 ;;
    *) fail "Cannot install Neovim: no archive for architecture $machine" ;;
esac

destination="/opt/$asset"
link=/usr/local/bin/nvim
if [[ -e $link || -L $link ]]; then
    [[ -L $link && $(readlink -- "$link") == "$destination/bin/nvim" ]] \
        || fail "Refusing to replace $link: it is not a link managed by this installer"
fi

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
archive="$tmp/$asset.tar.gz"

info "Downloading the latest stable Neovim release..."
curl -fsSL --retry 3 -o "$archive" "$NVIM_REPO/releases/latest/download/$asset.tar.gz" \
    || fail "Could not download $asset.tar.gz"

# Check extraction and binary compatibility before removing the old installation.
tar --no-same-owner -xzf "$archive" -C "$tmp" || fail "Could not unpack $asset.tar.gz"
[[ -x $tmp/$asset/bin/nvim && -d $tmp/$asset/share/nvim/runtime ]] \
    || fail "The archive does not contain the expected Neovim installation"
"$tmp/$asset/bin/nvim" --version || fail "The downloaded Neovim cannot run on this system"

info "Installing Neovim to $destination (requires sudo)..."
sudo install -d /opt /usr/local/bin
sudo rm -rf -- "$destination"
sudo tar --no-same-owner -C /opt -xzf "$archive"
sudo ln -sfnT -- "$destination/bin/nvim" "$link"

success "Installed Neovim; run $link --version to verify"
