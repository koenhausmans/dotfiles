#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$BASEDIR")"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-links.XXXXXX")"
trap 'rm -rf "$sandbox"' EXIT

export LINK_HELPER="$BASEDIR/_links.sh" SOURCE="$sandbox/source file" DEST="$sandbox/target file"
printf 'source\n' > "$SOURCE"

cat > "$sandbox/link-driver.sh" <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
source "$LINK_HELPER"
if [[ -n ${SECOND_DEST:-} ]]; then
    link_files "$SOURCE" "$DEST" "$SECOND_SOURCE" "$SECOND_DEST"
else
    link_files "$SOURCE" "$DEST"
fi
BASH
chmod +x "$sandbox/link-driver.sh"

"$sandbox/link-driver.sh" >"$sandbox/output"
test "$(readlink "$DEST")" = "$SOURCE"
"$sandbox/link-driver.sh" >"$sandbox/output"

rm "$DEST"
printf 'keep this\n' > "$DEST"
if "$sandbox/link-driver.sh" >"$sandbox/output" 2>"$sandbox/error"; then
    echo 'Expected a conflict without a terminal' >&2
    exit 1
fi
test "$(cat "$DEST")" = 'keep this'

printf 's\n' | script -q -e -c "$sandbox/link-driver.sh" /dev/null >"$sandbox/terminal-output"
test "$(cat "$DEST")" = 'keep this'

printf 'b\n' | script -q -e -c "$sandbox/link-driver.sh" /dev/null >"$sandbox/terminal-output"
test "$(cat "$DEST.backup")" = 'keep this'
test "$(readlink "$DEST")" = "$SOURCE"

# Never overwrite an existing backup.
rm "$DEST"
printf 'new settings\n' > "$DEST"
if printf 'b\n' | script -q -e -c "$sandbox/link-driver.sh" /dev/null >"$sandbox/terminal-output"; then
    echo 'Expected an existing backup to block installation' >&2
    exit 1
fi
test "$(cat "$DEST")" = 'new settings'
test "$(cat "$DEST.backup")" = 'keep this'

printf 'o\n' | script -q -e -c "$sandbox/link-driver.sh" /dev/null >"$sandbox/terminal-output"
test "$(readlink "$DEST")" = "$SOURCE"

# An apply-to-all choice handles multiple conflicting destinations.
rm "$DEST"
printf 'first\n' > "$DEST"
export SECOND_SOURCE="$sandbox/second source" SECOND_DEST="$sandbox/second target"
printf 'second source\n' > "$SECOND_SOURCE"
printf 'second\n' > "$SECOND_DEST"
printf 'S\n' | script -q -e -c "$sandbox/link-driver.sh" /dev/null >"$sandbox/terminal-output"
test "$(cat "$DEST")" = 'first'
test "$(cat "$SECOND_DEST")" = 'second'
unset SECOND_SOURCE SECOND_DEST

# A directory is not recursively deleted by the overwrite choice.
rm "$DEST"
mkdir "$DEST"
printf 'nested\n' > "$DEST/keep"
if printf 'o\n' | script -q -e -c "$sandbox/link-driver.sh" /dev/null >"$sandbox/terminal-output"; then
    echo 'Expected directory overwrite to be rejected' >&2
    exit 1
fi
test "$(cat "$DEST/keep")" = 'nested'

# Both installers use the same helper and can be rerun safely.
export HOME="$sandbox/home" XDG_CONFIG_HOME="$sandbox/xdg"
"$BASEDIR/../nvim/install.sh" >"$sandbox/output"
test "$(readlink "$XDG_CONFIG_HOME/nvim/init.vim")" = "$DOTFILES_ROOT/nvim/init.vim"
"$BASEDIR/../nvim/install.sh" >"$sandbox/output"
rm "$XDG_CONFIG_HOME/nvim/init.vim"
printf 'user init\n' > "$XDG_CONFIG_HOME/nvim/init.vim"
if "$BASEDIR/../nvim/install.sh" >"$sandbox/output" 2>"$sandbox/error"; then
    echo 'Expected the Neovim installer to require a choice' >&2
    exit 1
fi
printf 'b\n' | script -q -e -c "$BASEDIR/../nvim/install.sh" /dev/null >"$sandbox/terminal-output"
test "$(cat "$XDG_CONFIG_HOME/nvim/init.vim.backup")" = 'user init'
test "$(readlink "$XDG_CONFIG_HOME/nvim/init.vim")" = "$DOTFILES_ROOT/nvim/init.vim"

mkdir -p "$HOME"
"$BASEDIR/bootstrap" >"$sandbox/output"
test "$(readlink "$HOME/.zshrc")" = "$DOTFILES_ROOT/zsh/zshrc.symlink"
"$BASEDIR/bootstrap" >"$sandbox/output"
rm "$HOME/.zshrc"
printf 'user zsh config\n' > "$HOME/.zshrc"
printf 'b\n' | script -q -e -c "$BASEDIR/bootstrap" /dev/null >"$sandbox/terminal-output"
test "$(cat "$HOME/.zshrc.backup")" = 'user zsh config'
test "$(readlink "$HOME/.zshrc")" = "$DOTFILES_ROOT/zsh/zshrc.symlink"

echo 'Shared symlink checks passed'
