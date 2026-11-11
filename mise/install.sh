#!/usr/bin/env bash
set -euo pipefail

MISE_REPO="https://github.com/jdx/mise"
MISE_BIN="$HOME/.local/bin/mise"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASEDIR/../lib/links.sh"

for command in curl tar sha256sum; do
    command -v "$command" > /dev/null || fail "Cannot install mise: $command is not available"
done

machine=$(uname -m)
case $machine in
    x86_64) arch=x64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) fail "Cannot install mise: no binary for architecture $machine" ;;
esac

latest_url=$(curl -fsSI --retry 3 -o /dev/null -w '%{redirect_url}' "$MISE_REPO/releases/latest") \
    || fail "Could not find the latest mise release"
version=${latest_url##*/}
[[ $version =~ ^v[0-9]+(\.[0-9]+)+$ ]] || fail "Could not read the mise version from $latest_url"
version_num=${version#v}

installed=$("$MISE_BIN" --version 2> /dev/null || true)
if [[ $installed == "$version_num "* ]]; then
    success "mise $version_num is already installed"
else
    asset="mise-$version-linux-$arch.tar.gz"

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    info "Downloading mise $version_num..."
    for file in "$asset" SHASUMS256.txt; do
        curl -fsSL --retry 3 -o "$tmp/$file" "$MISE_REPO/releases/download/$version/$file" \
            || fail "Could not download $file"
    done
    (cd "$tmp" && grep "\\./$asset" SHASUMS256.txt | sha256sum --check --status) \
        || fail "Checksum mismatch for $asset"
    tar -xzf "$tmp/$asset" -C "$tmp" --strip-components=2 mise/bin/mise \
        || fail "Could not unpack $asset"

    mkdir -p "$(dirname "$MISE_BIN")"
    install -m 755 "$tmp/mise" "$MISE_BIN" || fail "Could not install mise to $MISE_BIN"
    success "Installed mise $version_num"
fi

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
mkdir -p -- "$config_dir"
link_files "$BASEDIR/config.toml" "$config_dir/config.toml"

info "Installing tools with mise..."
"$MISE_BIN" install node || fail "Could not install node"
"$MISE_BIN" install || fail "Could not install mise tools"
success "Finished installing mise tools"
