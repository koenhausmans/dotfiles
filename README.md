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

Minimal installation:
---------------------

Add the `minimal` argument to both the `bootstrap` as `install` script, to install minimal versions of the dotfiles.

Making local customizations:
----------------------------

Making (machine) local customizations for some of the tools can be done by editing these files:

 * `bash` : `~/.bashrc.local`
 * `git` : `~/.gitconfig.local`
 * `screen` : `~/.screenrc.local`
 * `tmux` : `~/.tmux.conf.local`
 * `vim` : `~/.vimrc.local`
 * `zsh` : `~/.zshrc.local`

Required packages (Ubuntu):
---------------------------
 * curl
 * git
 * bash
 * python python-pip python-setuptools
 * vim
 * zsh
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

