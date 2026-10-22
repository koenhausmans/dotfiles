Dotfiles:
=========

Installation:
-------------

### Run the installers: ###

Run the installers with:
 > `./install.sh`

The script takes no arguments. It asks about each component in this order: Bash,
Zsh, Fish, Git, tmux, screen, Vim, Neovim, fzf, and themes. Choose `y` for one
component, `Y` for this and all remaining components, or `n` to skip one. Each
component's `install.sh` links its own files into your home directory or
`~/.config` and fetches anything it needs. This repository has no Git submodules.

If a different file already exists at a link path, the installer asks whether to
skip it, back it up, or overwrite it. Re-running an installer is safe. Without a
terminal, the installers leave conflicts untouched and stop. The `z` script is
cloned or updated once per run, even when both Bash and Zsh are selected.

`./fzf/install.sh` installs the `.deb` from the latest fzf release on GitHub
with `sudo dpkg -i`, after it checks the SHA-256 checksum. It needs a
Debian-based system. Run it again to upgrade; it does nothing when the latest
version is already installed. The shell configurations load fzf's key bindings
from the installed binary. Inside tmux, fzf opens in a popup. After you move
from an older version of this repository, remove the old `~/.fzf` checkout and
run `:PlugInstall` in Vim and Neovim.

### Fish: ###

Fish uses `~/.config/fish` (or `$XDG_CONFIG_HOME/fish`), not a home-directory
dotfile. `./fish/install.sh` links the fish settings into `conf.d` and
`functions`. This leaves any existing `config.fish` alone. Re-run
`./fish/install.sh` after pulling changes to link any newly added fish
functions. `./install.sh` also offers to run the fish installer. Run `fish` to
try it, or use `chsh -s "$(command -v fish)"` to make it your default shell (log
out and back in afterward).

Prompts and status bars use Powerline glyphs. Select a terminal font that
provides them; this repository does not install fonts.

### Install themes: ###

Run `./themes/install.sh` to install the Claude Code and OpenCode themes and to
set Antigravity CLI to use the terminal's colors. It runs
`themes/claude-code/install.sh`, `themes/opencode/install.sh`, and
`themes/antigravity-cli/install.sh`; each one skips its tool when the tool's
command (`claude`, `opencode`, or `agy`) is not on your `PATH`. You can also run
them separately. `./install.sh` offers the themes installer too. See the
README in each `themes/` folder for details. Windows Terminal, Alacritty, and
PuTTY themes are installed by hand.

Minimal Vim configuration:
--------------------------

The Vim installer asks whether to use the minimal configuration without plugins
(`vim/vimrc.minimal`). Answer `y` for it, or `n` for the full configuration.

Making local customizations:
----------------------------

Making (machine) local customizations for some of the tools can be done by editing these files:

 * `bash` : `~/.bashrc.local`
 * `fish` : `~/.config/fish/config.local.fish` (or `$XDG_CONFIG_HOME/fish/config.local.fish`)
 * `git` : `~/.gitconfig.local`
 * `screen` : `~/.screenrc.local`
 * `tmux` : `~/.tmux.conf.local`
 * `vim` : `~/.vimrc.local`
 * `zsh` : `~/.zshrc.local`

The fish local file is optional; `fish/config.local.fish.template` shows where
to put machine-specific settings. Set `fish_prompt_theme` there to `kanagawa`
(default), `sonokai`, `gruvbox-material`, or `tokyo-night`. Set
`fish_prompt_ascii` to `1` for a plain prompt; Linux consoles use it automatically.

Required packages (Ubuntu):
---------------------------
 * curl
 * git
 * bash
 * python3 python3-pip python3-setuptools
 * vim
 * zsh
 * fish
 * tmux
 * exuberant-ctags
 * g++
 * build-essential
 * ripgrep
 * fd-find

On Ubuntu, `fd-find` installs the file-search command as `fdfind`. The Vim and Neovim configurations accept either `fdfind` or `fd` for fzf file pickers; if neither is installed, they use `rg --files` when available.

Required packages (Nvim):
-------------------------
 * neovim
