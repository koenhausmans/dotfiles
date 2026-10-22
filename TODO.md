Neovim ToDo:
============
- [ ] Typst: Support for terminal output instead of HTML / PDF
- [ ] Check vim-unimpaired, add additional useful keybindings in README or replace by other plugin?
- [ ] Check oil.nvim
- [ ] Checkout flash.nvim
- [ ] Checkout which-labels.nvim

Plugins to consider:
--------------------
- [ ] blink.pairs -> Might replace auto-pairs
- [ ] mason.nvim -> Only for self-contained language servers
- [ ] nvim-dap for debugging
- [ ] fzf-lua -> To consider for LSP integration
- [ ] dropbar.nvim -> Replacement for nvim-treesitter-context

Collection plugins to consider:
-------------------------------
- [ ] snacks.nvim
- [ ] mini.nvim

Dotfiles:
=========
- [x] Change the bootstrap script to only use install.sh files instead. This allows more for every entry to select whether I want to install it or not. So also the symlinks should be taken care of by the install.sh script.
- [ ] Can you propose a way to get rid of the vimrc.minimal including in vimrc that uses a (somewhat) absolute path of ~/.dotfiles? I want to be able to store the dotfiles folder somewhere else or rename it to dotfiles.
- [ ] How about fzf, isn't there an upstream build that's close to 0.74.5 that can be used instead?

