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
- [ ] mini.nvim -> Module collection; mini.pairs is already used standalone. Review other
      modules only if they would replace current plugins, e.g. mini.surround
      (nvim-surround) or mini.files (oil.nvim).
   - For now keep oil.nvim instead of mini.files. I want to try thsi out later.

Kickstart.nvim migration:
-------------------------
kickstart.nvim now uses vim.pack (Neovim 0.12 built-in) instead of lazy.nvim.
Migrate in steps; keep the config working after each one.

- [x] Step 1: Require Neovim 0.12+. Drop the 0.11 treesitter branch, the
      nvim-treesitter-0.12 checkout suffix, and the separate parser directory.
- [x] Step 2: Convert init.vim to init.lua with vim.pack. Vimscript-only parts
      (SudoWrite, abbreviations) move to vim.cmd blocks. Update nvim/install.sh
      to link init.lua and remove the old init.vim link.
- [ ] Step 3: Optionally split into Lua modules under lua/ (kickstart suggests
      this at the end of its file). Do this after step 2 settles.
- [ ] Step 4: Adopt kickstart options one at a time:
      - breakindent = true  (wrapped lines stay indented)
      - inccommand = 'split'  (live preview of :s substitutions in a split)
      - confirm = true  (ask before quitting with unsaved changes)
      - timeoutlen = 300  (which-key appears faster; current is unset ~1000ms)
      - scrolloff = 10  (more context above/below cursor; current is 5)
      - mouse = 'a'  (enable mouse in all modes)
      - clipboard = 'unnamedplus'  (system clipboard by default; conflicts with
        the existing ,y/,p bindings — pick one approach before enabling)


### Current tasks

- [ ] NMAC427/guess-indent.nvim : Auto-recognize indentation of file
- [ ] Include a toggle for auto-formatting of other languages
    - Which languages are useful for auto formatting?
- [ ] How to fix FZF for files, if I search for README.md it does not autoselect the hit with exactrly this filename. Instead it shows subfolders that contain a README.md first.
- [ ] FZF-Lua:
    - Search tags <leader>st
    - Search
- [ ] Consider:
    - `vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })`
    - `vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })`
- [ ] Reconsider the current LspAttach keymaps. I would rather use the keymaps of kickstart.nvim, but they use telescope. Is there a similar thing for Fzf-Lua?
- [ ] Useful to add `require('vim._core.ui2').enable({})`?
- [ ] Investigate https://github.com/hifanx/dotfiles/blob/main/.config/nvim/init.lua
