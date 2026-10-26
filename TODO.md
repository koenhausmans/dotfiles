Dotfiles:
=========

- [x] Map fdfind on Ubuntu to fd. Or why is this not the case on Ubuntu?
- [x] Integrate batcat with shared defaults and shell file previews.
- [x] The link_files overwrite O setting is not kept in other components. Can you fix?
- [x] Trying to install uv results in error 502:
        curl: (22) The requested URL returned error: 502
        [FAIL] Could not find the latest uv release
- [x] Is it not logical to move link_tool of bat to bat/install.sh and hence the link_tool helper to lib/helper.sh?

---

- [ ] Improve ctags / rust tags / python tags? Clangd?
- [x] Include information about the fonts to use and info on how to setup Windows Terminal configuration.
        Font face: Pragmasevka Nerd Font (Add link to the font download)
        Line height: 1,3
        Font weight: Thin
        Padding: 2
        Scrollbar visibility: Hidden
- [ ] Create a `./install.sh server` command to install only commands useful for servers. Next to that, update the README to have the option to only install tools relevant for servers. These are the onces I think that are useful:
        - bash, vim (with minimal!), screen, tmux, bin
        - For the normal installer, use the non-minimal vim by default.
- [ ] Can you clean-up the tests, I don't things testcases are really relevant for such a repository.

 
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
