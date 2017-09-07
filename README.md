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
 * vim vim-nox
 * zsh
 * tmux
 * exuberant-ctags
 * g++
 * build-essential
 * silversearcher-ag-el

Required packages(Arch Linux):
------------------------------
 * base-devel
 * bash bash-completion
 * ctags
 * zsh
 * vim
 * tmux
 * the_silver_searcher
 * python python-setuptools python-pip
 * mlocate
 * curl
 * git
 * bash-git-prompt
 * wget

