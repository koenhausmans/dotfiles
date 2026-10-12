Dotfiles:
=========

Installation:
-------------

### Install all submodules: ###

To install the submodules, execute:
 > `./scripts/install`

### Install symlinks: ###

To install all symlinks in the home directory, execute:
 > `./scripts/bootstrap`

Fish uses `~/.config/fish` (or `$XDG_CONFIG_HOME/fish`), not a home-directory
dotfile. Run `./fish/install.sh` to link the fish settings into `conf.d` and
`functions`. This leaves any existing `config.fish` alone. Re-running the
installer is safe. If a different file exists at one of its link paths, choose
whether to skip, back it up, or overwrite it, as with `./scripts/bootstrap`
and `./nvim/install.sh`. The installers leave conflicts untouched when no
terminal is available. Re-run `./fish/install.sh` after pulling changes to
link any newly added fish functions. `./scripts/install` also offers to run the fish
installer. Run `fish` to try it, or use `chsh -s "$(command -v fish)"` to make
it your default shell (log out and back in afterward).

Minimal installation:
---------------------

Add the `minimal` argument to both the `bootstrap` as `install` script, to install minimal versions of the dotfiles.

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
 * python python-pip python-setuptools
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
