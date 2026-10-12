#!/usr/bin/env bash
set -euo pipefail

FZF_REPO="https://github.com/junegunn/fzf"

## DO NOT CHANGE BELOW

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../scripts/_helpers.sh"

info "Trying to install fzf"

for command in curl dpkg dpkg-query sha256sum sudo; do
    command -v "$command" > /dev/null || fail "Cannot install fzf: $command is not available"
done

# Upstream names some .deb files differently from Debian's architecture names.
debian_arch=$(dpkg --print-architecture)
case $debian_arch in
    amd64|arm64|loong64|riscv64|s390x) arch=$debian_arch ;;
    armhf) arch=armv7 ;;
    armel) arch=armv5 ;;
    ppc64el) arch=ppc64le ;;
    *) fail "Cannot install fzf: no .deb for architecture $debian_arch" ;;
esac

# The latest-release redirect avoids the GitHub API and its rate limit.
latest_url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$FZF_REPO/releases/latest") \
    || fail "Could not find the latest fzf release"
version=${latest_url##*/v}
[[ $version =~ ^[0-9]+(\.[0-9]+)+$ ]] || fail "Could not read the fzf version from $latest_url"

installed=$(dpkg-query -W -f='${Version}' fzf 2> /dev/null || true)
if [[ $installed == "$version" ]]; then
    success "fzf $version is already installed"
    exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

deb="fzf_${version}_${arch}.deb"
checksums="fzf_${version}_checksums.txt"
info "Downloading fzf $version..."
curl -fsSL -o "$tmp/$deb" "$FZF_REPO/releases/download/v$version/$deb" || fail "Could not download $deb"
curl -fsSL -o "$tmp/$checksums" "$FZF_REPO/releases/download/v$version/$checksums" || fail "Could not download $checksums"

checksum=$(awk -v file="$deb" '$2 == file' "$tmp/$checksums")
[[ -n $checksum ]] || fail "No checksum for $deb"
(cd "$tmp" && sha256sum --check --status <<< "$checksum") || fail "Checksum mismatch for $deb"

info "Installing fzf $version (requires sudo)..."
sudo dpkg -i "$tmp/$deb" > /dev/null || fail "Could not install $deb"

if [[ -d $HOME/.fzf ]]; then
    info "The old fzf checkout in ~/.fzf is no longer used and can be removed"
fi

success "Finished installing fzf $version"
