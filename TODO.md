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

- [x] vim.pack.update() is both at Setup and plugin updates. Leave it at plugin updates.
- [ ] Quick searching with f<char> and then with labels to move around doesn't seem to be working anymore?
- [ ] Why dib / dab (delete inner/around bracket) not work?
- [ ] Why is my named register "a being overwritten when I delete a word? What do I do wrong?
      Somehow the content of register a = `F{<80><fd>5v/}^MD`
    - [ ] mark a and register a seem to be correct.?
- [ ] NMAC427/guess-indent.nvim : Auto-recognize indentation of file

- [ ] Propose a change for adding mini.nvim:
   - mini.bracketed instead of vim-unimpaired
   - mini.icons instead of nvim-web-devicons
     ```
     vim.keymap.set('n', '<leader>tw', function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Toggle Wrap" })
     vim.keymap.set('n', '<leader>ts', function() vim.wo.spell = not vim.wo.spell end, { desc = "Toggle Spell" })
     ```
   - mini.pairs is already used
   - Other suggestions?
   - For now keep oil.nvim instead of mini.files. I want to try this out later.
- [ ] Update which-keys with latest changes (mini.icons / mini.ai, mini.bracketed)
- `vim.keymap.set('n', '<leader>tw', function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Toggle Wrap" })`
- `vim.keymap.set('n', '<leader>ts', function() vim.wo.spell = not vim.wo.spell end, { desc = "Toggle Spell" })`
- [ ] Ripgrep does not seem to be used by fzf-lua
- [ ] Opening opencode.json now collapses everything. Why is that?
- [ ] relativenumber does not seem to be working anymore
- [ ] Add markdownlint to instructions, add jsonlint
