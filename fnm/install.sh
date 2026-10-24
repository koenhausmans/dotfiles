#!/usr/bin/env bash
set -euo pipefail

FNM_REPO="https://github.com/Schniz/fnm"
FNM_BIN="$HOME/.local/bin/fnm"

## DO NOT CHANGE BELOW

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/helpers.sh"

info "Trying to install fnm"

for command in curl unzip; do
    command -v "$command" > /dev/null || fail "Cannot install fnm: $command is not available"
done

machine=$(uname -m)
case $machine in
    x86_64) asset=fnm-linux ;;
    aarch64|arm64|armv8*) asset=fnm-arm64 ;;
    arm|armv7*) asset=fnm-arm32 ;;
    *) fail "Cannot install fnm: no binary for architecture $machine" ;;
esac

# The latest-release redirect avoids the GitHub API and its rate limit.
latest_url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$FNM_REPO/releases/latest") \
    || fail "Could not find the latest fnm release"
version=${latest_url##*/v}
[[ $version =~ ^[0-9]+(\.[0-9]+)+$ ]] || fail "Could not read the fnm version from $latest_url"

installed=$("$FNM_BIN" --version 2> /dev/null || true)
if [[ $installed == "fnm $version" ]]; then
    success "fnm $version is already installed"
else
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    # Upstream publishes no checksums for the release archives.
    info "Downloading fnm $version..."
    curl -fsSL -o "$tmp/$asset.zip" "$FNM_REPO/releases/download/v$version/$asset.zip" \
        || fail "Could not download $asset.zip"
    unzip -q "$tmp/$asset.zip" -d "$tmp" || fail "Could not unzip $asset.zip"

    mkdir -p "$(dirname "$FNM_BIN")"
    install -m 755 "$tmp/fnm" "$FNM_BIN" || fail "Could not install fnm to $FNM_BIN"
fi

if ! "$FNM_BIN" list | grep -q default; then
    info "Installing the latest Node.js LTS as the default version..."
    "$FNM_BIN" install --lts || fail "Could not install Node.js LTS"
    "$FNM_BIN" default lts-latest || fail "Could not set the default Node.js version"
fi

success "Finished installing fnm $version"
