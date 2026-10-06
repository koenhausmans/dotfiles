# Neovim configuration

This configuration uses Neovim 0.11 or newer and Vim-plug for plugins. Run Neovim and its external tools inside WSL. The leader key is `,`.

## What it configures

- Built-in LSP for Python, Rust, C/C++, and Typst, with blink.cmp completion, built-in snippets, and signature help.
- Automatic format-on-save via conform.nvim: clang-format for C/C++, rustfmt for Rust, ruff for Python, stylua for Lua, typstyle for Typst.
- Git status and history with Fugitive, Diffview, and Gitsigns. The statusline shows the branch and current file's changes.
- Lualine statusline with slant separators, showing mode, git branch, diagnostics, filetype, and cursor position.
- TODO/FIXME/NOTE keyword highlights with badge-style colouring and gutter signs via todo-comments.
- Inline Markdown and Typst rendering via markview.nvim: headings, tables, code blocks, and checkboxes render in the buffer; raw syntax is restored when the cursor enters the element.
- File browsing and management with oil.nvim: directories open as editable buffers.
- Unicode search and insertion with unicode.vim and fzf integration.
- Jump navigation with flash.nvim: label-based jumping to any visible position, with treesitter-aware node selection.
- Word highlighting with illuminate: all references to the symbol under the cursor are highlighted using LSP or treesitter.
- Scope pinning with nvim-treesitter-context: the enclosing function or block is shown as a sticky header when scrolled past.
- Indent guides via indent-blankline, with treesitter-aware scope highlighting.
- Keybinding popup via which-key: press a prefix and pause to see labelled completions.
- File selection with fzf (using `fd`, `fdfind`, or `rg --files` when available) and text search with ripgrep.
- Four-space indentation, persistent undo, smart-case search, marker folds, and splits that open below or to the right.
- Line numbers, visible whitespace, a fixed sign column, and a cursor line in the active window. Theme changes are saved and restored.
- Spelling for Markdown, Git commit messages, and todo files. Python and CoffeeScript files lose trailing whitespace on write.

## Language servers

Install these tools inside WSL. The server executable must be on the Linux `PATH` used to start Neovim.

| Language | Server | Installation note |
| --- | --- | --- |
| Python | basedpyright | Install with npm. Make sure `basedpyright-langserver` is on `PATH`. |
| Rust | rust-analyzer | Add the `rust-analyzer`, `rustfmt`, and `rust-src` components to the active rustup toolchain. |
| C/C++ | clangd | Install clangd. Provide `compile_commands.json` for project-specific compiler flags and include paths. |
| Typst | Tinymist | Install a Linux release or build it with Cargo. Make sure `tinymist` is on `PATH`. |

Open a matching file and use `:LspInfo` to check that its server attached. `:checkhealth vim.lsp` can help diagnose problems.

## Formatters

conform.nvim runs the appropriate formatter on save. Each formatter must be on the Linux `PATH`.

| Language | Formatter | Installation note |
| --- | --- | --- |
| C/C++ | clang-format | Install clangd or clang-format separately. Style is controlled by a `.clang-format` file in the project root. |
| Rust | rustfmt | Included with rustup. Add the `rustfmt` component if missing. |
| Python | ruff | Install with `pip install ruff` or your system package manager. Handles both formatting and import sorting. |
| Lua | stylua | Install a release binary from the stylua GitHub releases page. |
| Typst | typstyle | Build with `cargo install typstyle` or install a release binary. Falls back to Tinymist's built-in formatter if not found. |

Use `,lf` to trigger formatting manually. Format-on-save can be bypassed with `:noautocmd w`.

## Bindings configured in `init.vim`

These bindings use normal mode unless marked otherwise. LSP bindings work only in buffers with an attached server.

Press `,` and pause to see the which-key popup with labelled completions for all leader bindings.

### Files, buffers, and search

| Keys | Action |
| --- | --- |
| `-` | Open the current file's parent directory in oil. |
| `,f` | Find a file. |
| `,gf` | Find a Git-tracked file (fzf only). |
| `,b` | Select a buffer. |
| `,t` | Search tags. |
| `,e` | Start `:e **/*` to open a file under the current directory. |
| `,w` | Save the file. |
| `,c` | Delete the buffer without closing its window (`:Bdelete`). |
| `,z` | Switch to the alternate buffer. |
| `,m` | Run `:make`. |
| `,q` | Close the window. |
| `,/` | Start an `:Rg` search, or `:grep` when fzf or ripgrep is unavailable. |
| `,sw` | Search for the word under the cursor with ripgrep (requires fzf and ripgrep). |

With fzf, `,f`, `,b`, and `,t` open pickers. Without fzf, they use Neovim's file, buffer, and tag commands.
On Ubuntu, install `fd-find` to provide `fdfind`; on systems with `fd`, that command is used instead. If neither is available, file pickers use `rg --files` when ripgrep is installed, otherwise fzf's default file search.

### Git

| Keys | Action |
| --- | --- |
| `,gs` | Open Fugitive status. |
| `,gd` | Open the Diffview changes pane. |
| `,gc` | Close the Diffview pane. |
| `,gh` | Show history for the current file. |
| `,gb` | Show Git blame for the current file. |
| `,gl` | Show the Git log. |
| `[h` / `]h` | Go to the previous / next changed hunk in a tracked file. |

### Editing and navigation

| Keys | Action |
| --- | --- |
| `s` | Jump to any visible position: type two characters, then the label shown. |
| `S` | Treesitter-select mode: jump to a syntax node by label. |
| `j` / `k` | Move by display line without a count, or by file line with a count. |
| `0` / `$` | Move to the first nonblank / last character of the display line. |
| `'` | Jump to an exact mark position. |
| `<` / `>` / `=` (visual) | Change indentation or reindent, then keep the selection. |
| `,y{motion}` / `,y` (visual) | Copy text to the system clipboard. `,yy` copies a line. |
| `,p` | Paste from the system clipboard. |
| `Ctrl-h/j/k/l` | Move between splits, or between tmux panes with vim-tmux-navigator. |

The clipboard bindings use the `+` register. They do not change Neovim's default clipboard setting. Without vim-tmux-navigator, `Ctrl-h/j/k/l` still moves between splits.

### LSP and completion

| Keys | Action |
| --- | --- |
| `gD` / `gd` | Go to the declaration / definition. |
| `gi` / `gr` | Find implementations / references. |
| `K` | Show hover information. |
| `,lt` | Go to the type definition. |
| `,lr` | Rename a symbol. |
| `,la` | Show code actions. |
| `,ld` | Show diagnostics at the cursor. |
| `[d` / `]d` | Go to the previous / next diagnostic. |
| `,lq` | Put diagnostics in the location list. |
| `,lf` | Format the buffer manually (conform.nvim; format-on-save runs automatically). |
| `Ctrl-p` / `Ctrl-n` (insert) | Select the previous / next completion item. |
| `Enter` / `Tab` (insert) | Confirm a completion item. |
| `Ctrl-e` (insert) | Dismiss the completion menu. |

## Plugin-provided bindings

These bindings come from plugins rather than mappings in `init.vim`.

### oil.nvim

| Keys | Action |
| --- | --- |
| `<CR>` | Open the file or directory under the cursor. |
| `-` | Go up to the parent directory. |
| `_` | Open the current working directory. |
| `g.` | Toggle hidden files. |
| `g?` | Show the full list of oil keybindings. |

Edit filenames directly in the buffer and save with `:w` to rename or move files. Delete a line to delete the file. Open oil with `:e .` or press `-` from any buffer.

### flash.nvim

| Keys | Action |
| --- | --- |
| `s` | Open the jump picker: type two characters, then the label to jump. |
| `S` | Open the treesitter-select picker: jump to and select a syntax node. |
| `f` / `F` / `t` / `T` | Enhanced single-character motions with labels when multiple matches exist. |
| `;` / `,` | Repeat the last flash motion forward / backward. |

### illuminate

| Keys | Action |
| --- | --- |
| `]r` | Go to the next reference to the symbol under the cursor. |
| `[r` | Go to the previous reference to the symbol under the cursor. |

### unicode.vim

| Keys | Action |
| --- | --- |
| `ga` | Show the Unicode codepoint, name, and digraph for the character under the cursor. |
| `<C-x><C-g>` (insert) | Complete a digraph from the characters already typed. |

Use `:UnicodeSearch` to open an fzf picker over the full Unicode table and insert a character. Use `:Digraphs` to search all Vim digraphs with fzf.

### Other plugins

| Keys | Action |
| --- | --- |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments with Comment.nvim. |
| `gbc` / `gb{motion}` | Toggle block comments with Comment.nvim. |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding characters or tags (nvim-surround). |
| `ys{motion}{char}` / `yss{char}` / `S` (visual) | Add surrounding characters or tags (nvim-surround). The cursor stays in place after the operation. |
| `[b` / `]b` | Go to the previous / next buffer (vim-unimpaired). |
| `Ctrl-\` | Return to the previous split or tmux pane (vim-tmux-navigator). |
| `[q` / `]q` | Go to the previous / next quickfix item (vim-unimpaired). |
| `[l` / `]l` | Go to the previous / next location-list item (vim-unimpaired). |
| `[f` / `]f` | Open the previous / next file in the current file's directory (vim-unimpaired). |
| `[n` / `]n` | Go to the previous / next conflict marker or diff hunk (vim-unimpaired). |
| `[e` / `]e` | Move the current line up / down (vim-unimpaired). |
| `[<Space>` / `]<Space>` | Add a blank line above / below (vim-unimpaired). |
| `yoh` / `yol` / `yos` | Toggle search highlighting / visible whitespace / spelling (vim-unimpaired). |
| `.` | Repeat the last surround or comment operation (vim-repeat). |
| `Ctrl-t` / `Ctrl-x` / `Ctrl-v` (fzf picker) | Open the result in a tab / split / vertical split. |
| `Backspace` / `Enter` (insert) | Delete an empty pair / add an indented line inside one (auto-pairs). |
| `Alt-e` / `Alt-n` / `Alt-p` (insert) | Wrap the next expression / skip a closing character / toggle auto-pairs. |

Auto-pairs inserts matching brackets and quotes automatically. Terminal support for Alt keys can vary.

## Commands and themes

Use `:StripTrailingWhitespaces` to remove trailing whitespace. In command-line mode, `:bd` expands to `:Bdelete`, `%%` inserts the current file's directory, and `w!!` writes through `sudo`.

Use `:Markview` to toggle inline rendering on or off. `:Markview enable` and `:Markview disable` control it explicitly. Rendering is on by default for Markdown and Typst buffers.

Use `:TSContextToggle` to hide or show the treesitter scope header at the top of the window.

Use `:colorscheme` to change themes. Available themes: `kanagawa-wave`, `gruvbox-material`, `tokyonight-night`, and `sonokai` (shusia variant). `:Colors` opens a picker when fzf is available. Neovim saves and restores theme changes across sessions.
