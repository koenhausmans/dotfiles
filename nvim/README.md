# Neovim configuration

## Setup

This configuration requires Neovim 0.11.3 or newer and vim-plug for plugins.
Run Neovim and its external tools inside WSL.
Language servers and formatters must be on the Linux `PATH` used to start Neovim.
The leader key is `,`.

On first start, the configuration attempts to download vim-plug. If the
download succeeds, run `:PlugInstall`, wait for it to finish, and restart
Neovim. If vim-plug or plugins are missing, Neovim reports the path or plugin
names and keeps its built-in settings and mappings available. Retry the
displayed recovery steps, then restart.

### Install a newer Neovim

See the [official installation guide](https://neovim.io/doc/install/) for stable
downloads and system-wide installation. On Ubuntu/Ubuntu-based WSL, the
[Neovim unstable PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)
offers newer daily builds through apt (third-party, not stable releases).
On Debian, check [packages for your release](https://packages.debian.org/search?keywords=neovim);
do not use Ubuntu PPAs. Verify `nvim --version` is at least 0.11.3 after installation.

## Overview

- Language support: built-in LSP, blink.cmp completion, snippets, signature help, and automatic formatting.
- Files and navigation: oil.nvim, fzf, ripgrep, Flash jumps, and Unicode search.
- Git: status, history, blame, diffs, and change markers through Fugitive, Diffview, and Gitsigns.
- Appearance: Lualine statusline, TODO highlights, reference highlights, indent guides, and a sticky Treesitter scope header.
- Editing: four-space indentation, persistent undo, smart-case search, marker folds, and splits that open below or to the right.
- Defaults: line numbers, visible whitespace, a fixed sign column, and a cursor line in the active window.

Spelling is enabled for Markdown, Git commit messages, and todo files.
Python and CoffeeScript files lose trailing whitespace on write.

## Language servers and formatters

| Language | Server | Formatter | Installation |
| --- | --- | --- | --- |
| Python | basedpyright | ruff | `npm install -g basedpyright` or `uv tool install basedpyright` (executable: `basedpyright-langserver`). [uv/install.sh](../uv/install.sh) installs ruff, or use `uv tool install ruff`. Ruff handles formatting and import sorting. |
| Rust | rust-analyzer | rustfmt | `rustup component add rust-analyzer rustfmt rust-src` for the active toolchain. |
| C/C++ | clangd | clang-format | `sudo apt install clangd clang-format`. Provide `compile_commands.json` for compiler flags and include paths. A `.clang-format` file in the project root sets the style. |
| Typst | Tinymist | typstyle | `cargo install --locked tinymist typstyle`, or install release binaries. Formatting falls back to Tinymist's formatter without typstyle. |
| Lua | | stylua | Install a binary from the [StyLua releases](https://github.com/JohnnyMorganz/StyLua/releases). |

Open a matching file and use `:LspInfo` to check that its server attached. `:checkhealth vim.lsp` can help diagnose problems.

conform.nvim selects the configured formatter for both `,lf` and
format-on-save. It uses LSP formatting only when no configured formatter is
available, so `,lf` also works without an attached LSP.
Format-on-save can be bypassed with `:noautocmd w`.

## Keybindings

These bindings use normal mode unless marked otherwise. Plugin bindings require the corresponding plugin.

Press `,` and pause to see the which-key popup with labeled completions for all leader bindings.

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
| `[b` / `]b` | Go to the previous / next buffer (vim-unimpaired). |
| `[f` / `]f` | Open the previous / next file in the current file's directory (vim-unimpaired). |
| `,m` | Run `:make`. |
| `,q` | Close the window. |
| `,/` | Start an `:Rg` search, or `:grep` when fzf or ripgrep is unavailable. |
| `,sw` | Search for the word under the cursor with ripgrep (requires fzf and ripgrep). |
| `Ctrl-t` / `Ctrl-x` / `Ctrl-v` (fzf picker) | Open the result in a tab / split / vertical split. |

With fzf, `,f`, `,b`, and `,t` open pickers. Without fzf, they use Neovim's file, buffer, and tag commands.
On Ubuntu, install `fd-find` to provide `fdfind`. File pickers prefer `fd`, then `fdfind`, then `rg --files`, then fzf's default file search.

#### Directory buffers (oil.nvim)

| Keys | Action |
| --- | --- |
| `Enter` | Open the file or directory under the cursor. |
| `-` | Go up to the parent directory. |
| `_` | Open the current working directory. |
| `g.` | Toggle hidden files. |
| `g?` | Show the full list of oil keybindings. |

Edit filenames directly in the buffer and save with `:w` to rename or move files.
Delete a line to delete the file. Open oil with `:e .` or press `-` from any buffer.

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

### Editing

| Keys | Action |
| --- | --- |
| `<` / `>` / `=` (visual) | Change indentation or reindent, then keep the selection. |
| `,y{motion}` / `,y` (visual) | Copy text to the system clipboard. `,yy` copies a line. |
| `,p` | Paste from the system clipboard. |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments with Comment.nvim. |
| `gbc` / `gb{motion}` | Toggle block comments with Comment.nvim. |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding characters or tags (nvim-surround). |
| `ys{motion}{char}` / `yss{char}` / `S` (visual) | Add surrounding characters or tags (nvim-surround). The cursor stays in place after the operation. |
| `[e` / `]e` | Move the current line up / down (vim-unimpaired). |
| `[Space` / `]Space` | Add a blank line above / below (vim-unimpaired). |
| `yoh` / `yol` / `yos` | Toggle search highlighting / visible whitespace / spelling (vim-unimpaired). |
| `.` | Repeat the last surround or comment operation (vim-repeat). |
| `Backspace` / `Enter` (insert) | Delete an empty pair / add an indented line inside one (auto-pairs). |
| `Alt-e` / `Alt-n` / `Alt-p` (insert) | Wrap the next expression / skip a closing character / toggle auto-pairs. |
| `ga` | Show the Unicode codepoint, name, and digraph for the character under the cursor (unicode.vim). |
| `Ctrl-x Ctrl-g` (insert) | Complete a digraph from the characters already typed (unicode.vim). |

The clipboard bindings use the `+` register. They do not change Neovim's default clipboard setting.
Auto-pairs inserts matching brackets and quotes automatically. Terminal support for Alt keys can vary.

### Navigation

| Keys | Action |
| --- | --- |
| `s` | Flash jump: type a search string, then the label shown. Works in normal, visual, and operator-pending mode. |
| `S` | Flash Treesitter selection in normal and operator-pending modes. For visual `S`, see Editing. |
| `f` / `F` / `t` / `T` | Flash single-character motions. The default configuration does not add jump labels to these motions. |
| `;` / `,` | Repeat the last Flash motion forward / backward. |
| `[m` / `]m` | Go to the previous / next Treesitter function start. |
| `[M` / `]M` | Go to the previous / next Treesitter function end. |
| `j` / `k` | Move by display line without a count, or by file line with a count. |
| `0` / `$` | Move to the first nonblank / last character of the display line. |
| `'` | Jump to an exact mark position. |
| `[r` / `]r` | Go to the previous / next reference to the symbol under the cursor (illuminate). |
| `[q` / `]q` | Go to the previous / next quickfix item (vim-unimpaired). |
| `[l` / `]l` | Go to the previous / next location-list item (vim-unimpaired). |
| `[n` / `]n` | Go to the previous / next conflict marker or diff hunk (vim-unimpaired). |
| `Ctrl-h/j/k/l` | Move between splits, or between tmux panes with vim-tmux-navigator. |
| `Ctrl-\` | Return to the previous split or tmux pane (vim-tmux-navigator). |

Without vim-tmux-navigator, `Ctrl-h/j/k/l` still moves between splits.
In an embedded fzf picker, those keys go to fzf instead of switching panes.

### LSP and completion

LSP navigation and action bindings require an attached server. The formatting binding `,lf` uses conform.nvim independently.

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
| `,lf` | Format the buffer. See [Language servers and formatters](#language-servers-and-formatters) for installation and format-on-save behavior. |
| `Ctrl-p` / `Ctrl-n` (insert) | Select the previous / next completion item. |
| `Enter` / `Tab` (insert) | Confirm a completion item. |
| `Ctrl-e` (insert) | Dismiss the completion menu. |

## Commands

| Command | Action |
| --- | --- |
| `:UnicodeSearch` | Open an fzf picker over the Unicode table and insert a character. |
| `:Digraphs` | Search all Vim digraphs with fzf. |
| `:StripTrailingWhitespaces` | Remove trailing whitespace. |
| `:SudoWrite` / `:w!!` | Save the whole file with root permissions. Needs a named file buffer, marks it saved only after a successful write, and overwrites directly without a backup or atomic replacement. |
| `:Markview` / `:Markview enable` / `:Markview disable` | Toggle or set inline rendering of headings, tables, code blocks, and checkboxes. Raw syntax returns when the cursor enters an element. On by default for Markdown and Typst. |
| `:TSContextToggle` | Show or hide the Treesitter scope header with the enclosing function or block. |

In command-line mode, `:bd` expands to `:Bdelete` and `%%` inserts the current file's directory.

## Themes and appearance

Use `:colorscheme` to change themes.
Available themes: `kanagawa-wave`, `gruvbox-material`, `tokyonight-night`, and `sonokai` (shusia variant).
`:Colors` opens a picker when fzf is available. Neovim saves and restores theme changes across sessions.

Split borders use heavy lines. Borders beside the active split use the theme's
warm gold/yellow accent, distinct from [tmux](../tmux/tmux.conf)'s blue/aqua
active borders. Other borders keep the matching theme's muted inactive color.
Colors update on theme and focus changes.
Neovim colors separators through the window on their left or above, so a shared
edge in a nested layout can also receive the active color. Other colorschemes
keep their own separator colors.

## Plugin updates and rollback

Before updating, save the installed plugin revisions with
`:PlugSnapshot ~/.config/nvim/plugins-before.vim`. Run `:PlugUpdate`, review
the changes with `:PlugDiff`, and restart Neovim after the update completes.
To restore the saved revisions, run
`:source ~/.config/nvim/plugins-before.vim`, wait for vim-plug to finish, then
restart. Use the actual config directory if `XDG_CONFIG_HOME` is set. A
snapshot pins plugin Git revisions; it does not include Treesitter parsers,
language servers, or formatter binaries.
