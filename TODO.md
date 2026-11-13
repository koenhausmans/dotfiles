Dotfiles
=========

- [ ] Nvim installer: Give a warning when the `nvim` version is too old.
- [ ] Tmux: Shortcut `<prefix>-=` to work similar to vim's Ctrl+w-= (equal pane sizes)
- [ ] How about vim-repeat? How to repeat comment commands? Is it still useful with nvim? Replace by some native commands?
- [ ] Add a rust installer?
- [ ] zoxide: Is there an option to FZF into the zoxide query options?

Neovim ToDo
------------

- [ ] Typst: Support for terminal output instead of HTML / PDF
- [ ] Check vim-unimpaired, add additional useful keybindings in README or replace by other plugin?

### Plugins to consider

- [ ] nvim-dap -> Debugger client (breakpoints, stepping, variable inspection) through
      debug adapters such as codelldb for Rust/C and debugpy for Python. Needs nvim-dap-ui
      or nvim-dap-view for a usable UI; replaces no current plugins.
      Look at kickstart.nvim `kickstart/plugins/debug.lua`
- [ ] dropbar.nvim -> Replacement for nvim-treesitter-context
- [ ] mini.ai -> Adds textobjects for function calls, arguments and quotes, plus next/last
      variants such as `cin(`. Would replace none of the current plugins; it overlaps with
      the function, class and parameter objects in nvim-treesitter-textobjects.
- [ ] snacks.nvim -> All-or-nothing migration to its picker, indent, words and bufdelete
      modules. Would replace fzf-lua, indent-blankline.nvim, vim-illuminate and vim-bbye.
- [ ] Consider using mini.trailspace (Highlight and remove trailing spaces)
- [ ] Consider using mini.hipatterns instead of todo-comments.nvim
- [ ] NMAC427/guess-indent.nvim : Auto-recognize indentation of file
  - Is there another alternative from mini.nvim?

### Current tasks

- [ ] Include a toggle for auto-formatting of other languages
  - Which languages are useful for auto formatting?
- [ ] FZF-Lua:
  - Search tags `<leader>st`
  - Search
- [ ] Investigate [https://github.com/hifanx/dotfiles/blob/main/.config/nvim/init.lua]
- [ ] Add keymap for vim.diagnostic.setloclist
- [ ] Consider adding a shortcut for :TodoFzfLua `<leader>st`?
- [ ]  14 — Display additions: yours adds:
  - ↪  before wrapped continuation lines.
  - Heavy split borders.
  - Mode-specific cursor shapes, blinking in insert mode.
  - Explicit true-color support and display truncation.
- [ ] Consider making lualine simpler.
- [ ] Run a full check on all the which-key configuration and keymaps. Is everything in which-keys and nvim/README.md?
- [ ] `vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })`
- [ ] `vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })`
- [ ] Look at ``<leader>ss`` and `<leader>sr` of kickstart.nvim. This is picker related and resume picker related.
- [ ] Add `]r/[r` for illuminate navigation?
- [ ] Consider registering fzf-lua for `vim.ui.select` menus, such as LSP code actions.
- [ ] Consider `grD` for LSP go-to-declaration.
- [ ] Consider `,ld` for diagnostics at the cursor; native Ctrl-w d is available.
- [ ] Evaluate replacing vim-illuminate with Kickstart's LSP document-highlight setup; assess the loss of fallback providers and reference navigation.
- [x] Run linting when opening a buffer without requiring a save.
- [ ] Simplify `nvim/README.md`: keep setup, user-visible behavior, shortcuts, customization, and necessary caveats; remove internal wiring details and repeated information.

- [x] Use rumdl's Markdown LSP instead of nvim-lint.
