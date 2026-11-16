Dotfiles
=========

Neovim ToDo
------------

- [ ] Typst: Support for terminal output instead of HTML / PDF

### Plugins to consider

- [ ] nvim-dap -> Debugger client (breakpoints, stepping, variable inspection) through
      debug adapters such as codelldb for Rust/C and debugpy for Python. Needs nvim-dap-ui
      or nvim-dap-view for a usable UI; replaces no current plugins.
      Look at kickstart.nvim `kickstart/plugins/debug.lua`
- [ ] dropbar.nvim -> Replacement for nvim-treesitter-context
- [ ] mini.nvim considerations:
  - [ ] Consider mini.hipatterns instead of todo-comments.nvim
  - [ ] Consider mini.cursorword instead of vim-illuminate, no more shortcuts for navigating (Is `]r/[r` useful?)
  - [ ] Consider mini.indentscope plus leadmultispace instead of indent-blankline
  - [ ] Consider mini.notify for vim.notify overridng
- [ ] NMAC427/guess-indent.nvim : Auto-recognize indentation of file
  - Is there another alternative from mini.nvim?
- [ ] Research more useful leader keys to add, especially for the `<leader>l` group. Or give me a full list of default LSP actions. E.g. how to rename a keyword? How to rename a function? How to rename a variable?

