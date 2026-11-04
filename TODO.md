Dotfiles:
=========

- [ ] Remove reference to Ctrl+Enter in Windows Terminal README, but also add in AGENTS.md to not include comments/documentation about previous implementations. Only the current implementation should be documented.
- [ ] How about the K on a current word. How to integrate this into this new workflow?
- [ ] Remove the mentioning about PlugClean in the README.md, it is not relevant as only a single neovim
 

Neovim ToDo:
============
- [ ] Typst: Support for terminal output instead of HTML / PDF
- [ ] Check vim-unimpaired, add additional useful keybindings in README or replace by other plugin?

Plugins to consider:
--------------------
- [ ] nvim-dap -> Debugger client (breakpoints, stepping, variable inspection) through
      debug adapters such as codelldb for Rust/C and debugpy for Python. Needs nvim-dap-ui
      or nvim-dap-view for a usable UI; replaces no current plugins.
- [ ] dropbar.nvim -> Replacement for nvim-treesitter-context
- [ ] mini.ai -> Adds textobjects for function calls, arguments and quotes, plus next/last
      variants such as `cin(`. Would replace none of the current plugins; it overlaps with
      the function, class and parameter objects in nvim-treesitter-textobjects.
- [ ] snacks.nvim -> All-or-nothing migration to its picker, indent, words and bufdelete
      modules. Would replace fzf-lua, indent-blankline.nvim, vim-illuminate and vim-bbye.
- [ ] mini.nvim -> Module collection; mini.pairs is already used standalone. Review other
      modules only if they would replace current plugins, e.g. mini.surround
      (nvim-surround) or mini.files (oil.nvim).
