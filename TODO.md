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
- [ ] snacks.nvim -> All-or-nothing migration to its picker, indent, words and bufdelete
      modules. Would replace fzf-lua, indent-blankline.nvim, vim-illuminate and vim-bbye.
- [ ] Consider using mini.hipatterns instead of todo-comments.nvim

- [ ] NMAC427/guess-indent.nvim : Auto-recognize indentation of file
  - Is there another alternative from mini.nvim?
- [x] Add nvim/tmux shortcuts for Alt+h/j/k/l to resize the window. Take the idea from kickstart.nvim

- [ ] Auto resize the vim buffers on window resize.
  - Is it possible to only do this when the buffer is already auto-resized?
