Dotfiles:
=========

- [ ] Nvim installer: Give a warning when the `nvim` version is too old.
- [ ] Tmux: Shortcut <prefix>-= to work similar to vim's Ctrl+w-= (equal pane sizes)
- [ ] How about vim-repeat? How to repeat comment commands? Is it still useful with nvim? Replace by some native commands?
- [ ] Add a rust installer?
- [ ] zoxide: Is there an option to FZF into the zoxide query options?

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

### Current tasks

- [ ] NMAC427/guess-indent.nvim : Auto-recognize indentation of file
- [ ] Include a toggle for auto-formatting of other languages
    - Which languages are useful for auto formatting?
- [ ] FZF-Lua:
    - Search tags <leader>st
    - Search
- [ ] Consider:
    - `vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })`
    - `vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })`
- [ ] Investigate https://github.com/hifanx/dotfiles/blob/main/.config/nvim/init.lua
