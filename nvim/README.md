# Neovim configuration

This configuration uses Neovim 0.11 or newer and Vim-plug for plugins. Run Neovim and its external tools inside WSL. The leader key is `,`.

## What it configures

- Built-in LSP for Python, Rust, C/C++, and Typst, with nvim-cmp completion, built-in snippets, and signature help.
- Git status and history with Fugitive, Diffview, and Gitsigns. The statusline shows the branch and current file's changes.
- File selection with fzf and text search with Ag when available.
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

## Bindings configured in `init.vim`

These bindings use normal mode unless marked otherwise. LSP bindings work only in buffers with an attached server.

### Files, buffers, and search

| Keys | Action |
| --- | --- |
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
| `,/` | Start an Ag search, or `:grep` when fzf or Ag is unavailable. |
| `,sw` | Search for the word under the cursor with Ag (requires fzf and Ag). |

With fzf, `,f`, `,b`, and `,t` open pickers. Without fzf, they use Neovim's file, buffer, and tag commands.

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
| `,,` | Repeat the last `f`/`F`/`t`/`T` motion in the opposite direction. |
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
| `,lf` | Request asynchronous formatting from the server. |
| `Ctrl-p` / `Ctrl-n` (insert) | Select the previous / next completion item. |
| `Enter` / `Tab` (insert) | Confirm a completion item. |

Completion uses language-server results and file paths. Formatting depends on the attached server.

## Plugin-provided bindings

These bindings come from plugins rather than mappings in `init.vim`.

| Keys | Action |
| --- | --- |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments with vim-commentary. |
| `gcu` | Uncomment the current and adjacent commented lines (vim-commentary). |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding characters or tags (vim-surround). |
| `ys{motion}{char}` / `yss{char}` / `S` (visual) | Add surrounding characters or tags (vim-surround). |
| `[b` / `]b` | Go to the previous / next buffer (vim-unimpaired). |
| `Ctrl-\` | Return to the previous split or tmux pane (vim-tmux-navigator). |
| `[q` / `]q` | Go to the previous / next quickfix item (vim-unimpaired). |
| `[l` / `]l` | Go to the previous / next location-list item (vim-unimpaired). |
| `[f` / `]f` | Open the previous / next file in the current file's directory (vim-unimpaired). |
| `[n` / `]n` | Go to the previous / next conflict marker or diff hunk (vim-unimpaired). |
| `[e` / `]e` | Move the current line up / down (vim-unimpaired). |
| `[<Space>` / `]<Space>` | Add a blank line above / below (vim-unimpaired). |
| `yoh` / `yol` / `yos` | Toggle search highlighting / visible whitespace / spelling (vim-unimpaired). |
| `.` | Repeat supported surround and commentary edits (vim-repeat). |
| `Ctrl-t` / `Ctrl-x` / `Ctrl-v` (fzf picker) | Open the result in a tab / split / vertical split. |
| `Backspace` / `Enter` (insert) | Delete an empty pair / add an indented line inside one (auto-pairs). |
| `Alt-e` / `Alt-n` / `Alt-p` (insert) | Wrap the next expression / skip a closing character / toggle auto-pairs. |

Auto-pairs also inserts matching brackets and quotes. Terminal support for Alt keys can vary.

## Commands and themes

Use `:StripTrailingWhitespaces` to remove trailing whitespace. In command-line mode, `:bd` expands to `:Bdelete`, `%%` inserts the current file's directory, and `w!!` writes through `sudo`.

Use `:colorscheme` to change themes. Available themes include gruvbox, gruvbox-material, onedark, monokai, and Tokyo Night. `:Colors` opens a picker when fzf is available. Neovim saves and restores theme changes.
