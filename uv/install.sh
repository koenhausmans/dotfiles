#!/usr/bin/env bash
set -euo pipefail

UV_REPO="https://github.com/astral-sh/uv"
UV_BIN_DIR="$HOME/.local/bin"

## DO NOT CHANGE BELOW

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASEDIR/../lib/helpers.sh"

info "Trying to install uv"

for command in curl tar sha256sum; do
    command -v "$command" > /dev/null || fail "Cannot install uv: $command is not available"
done

machine=$(uname -m)
case $machine in
    x86_64) asset=uv-x86_64-unknown-linux-gnu ;;
    aarch64|arm64) asset=uv-aarch64-unknown-linux-gnu ;;
    *) fail "Cannot install uv: no binary for architecture $machine" ;;
esac

# The latest-release redirect avoids the GitHub API and its rate limit.
latest_url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$UV_REPO/releases/latest") \
    || fail "Could not find the latest uv release"
version=${latest_url##*/}
[[ $version =~ ^[0-9]+(\.[0-9]+)+$ ]] || fail "Could not read the uv version from $latest_url"

installed=$("$UV_BIN_DIR/uv" --version 2> /dev/null || true)
if [[ $installed == "uv $version "* ]]; then
    success "uv $version is already installed"
else
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    info "Downloading uv $version..."
    for file in "$asset.tar.gz" "$asset.tar.gz.sha256"; do
        curl -fsSL -o "$tmp/$file" "$UV_REPO/releases/download/$version/$file" \
            || fail "Could not download $file"
    done
    (cd "$tmp" && sha256sum --check --status "$asset.tar.gz.sha256") \
        || fail "Checksum mismatch for $asset.tar.gz"
    tar -xzf "$tmp/$asset.tar.gz" -C "$tmp" || fail "Could not unpack $asset.tar.gz"

    mkdir -p "$UV_BIN_DIR"
    for command in uv uvx; do
        install -m 755 "$tmp/$asset/$command" "$UV_BIN_DIR/$command" \
            || fail "Could not install $command to $UV_BIN_DIR"
    done
fi

if "$UV_BIN_DIR/uv" tool list 2> /dev/null | grep -q '^ruff '; then
    info "Upgrading ruff..."
    "$UV_BIN_DIR/uv" tool upgrade ruff || fail "Could not upgrade ruff"
else
    info "Installing ruff..."
    "$UV_BIN_DIR/uv" tool install ruff || fail "Could not install ruff"
fi

success "Finished installing uv $version"
