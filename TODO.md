Dotfiles:
=========
 

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
