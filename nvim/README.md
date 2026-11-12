# Neovim configuration

## Setup

This configuration requires Neovim **0.12+** and uses `vim.pack`, the plugin
manager built into Neovim 0.12.
Run Neovim and its external tools inside WSL.
Language servers and formatters must be on the Linux `PATH` used to start Neovim.
The leader key is `,`.

On first start, plugins are downloaded automatically. Restart Neovim once after
the initial install to pick up all settings. The lockfile `nvim-pack-lock.json`
in the config directory pins revisions and stays local, outside this repository.

On non-Windows systems with `make` and a C compiler, LuaSnip's optional `jsregexp`
module is built after LuaSnip installation or updates. It supports regex
transformations in snippets; ordinary snippets work without it.

### Install a newer Neovim

Neovim is managed by [mise](../mise/README.md). Run `mise install` to install
or upgrade to the latest stable release. Restart your shell if it still selects
an old binary; check with `command -v nvim` and `nvim --version`.

See the [official installation guide](https://neovim.io/doc/install/) for other
platforms and installation methods.

### Treesitter setup and upgrades

Parser installation needs a C compiler, curl, and **tree-sitter CLI 0.26.1+**;
Ubuntu 26.04's apt package is too old. With Rust/Cargo installed:

```sh
cargo install --locked tree-sitter-cli
tree-sitter --version
```

Ensure `~/.cargo/bin` is on Neovim's Linux `PATH`. Alternatively, use a binary
from the [tree-sitter releases](https://github.com/tree-sitter/tree-sitter/releases),
not the npm package. The CLI is not installed by the dotfiles installer.

Parsers are installed automatically on first start. After plugin updates, run
`:TSUpdate` and restart. Use `:checkhealth nvim-treesitter` to diagnose failures.
Buffers without parsers keep their normal syntax and indentation.

## Overview

- Language support: built-in LSP, blink.cmp completion, snippets, signature help, nvim-lint linting, and automatic formatting.
- Files and navigation: oil.nvim, fzf-lua, ripgrep, and Flash jumps.
- Git: history and diff views through Diffview; change markers, blame, and hunk actions through Gitsigns.
- Appearance: Lualine statusline, TODO highlights, reference highlights, rendered documents, indent guides, and highlighted split borders.
- Editing: four-space indentation, persistent undo, smart-case search, marker folds, and splits that open below or to the right.
- Defaults: line numbers, visible whitespace, a fixed sign column, and a cursor line in the active window.

Cursor-line highlighting and relative line numbers follow window focus. Inactive
windows keep absolute line numbers. Switching away from Neovim also disables
both features when the terminal forwards focus events.

Spelling is enabled for Markdown, Git commit messages, and todo files.

Enabled mini.nvim modules: pairs (automatic brackets and quotes), icons (with
web-devicons compatibility), ai (extended text objects), bracketed (navigation),
bufremove (layout-preserving buffer deletion), and splitjoin (argument layouts).

## Language servers and formatters

| Language | Server | Formatter | Linter | Installation |
| --- | --- | --- | --- | --- |
| Python | basedpyright | ruff | ruff | `mise install`. Ruff handles formatting, import sorting, and linting. |
| Rust | rust-analyzer | rustfmt | Clippy (through rust-analyzer) | `mise install` installs rustup. Add components: `rustup component add rust-analyzer rust-src`. |
| C/C++ | clangd | clang-format | clang-tidy | `sudo apt install clangd clang-format clang-tidy`. |
| Typst | Tinymist | typstyle | Tinymist compiler diagnostics | `cargo install --locked tinymist typstyle`, or install release binaries. Formatting falls back to Tinymist's formatter without typstyle. |
| Lua | Lua Language Server | StyLua | LuaLS diagnostics | `mise install`. |
| Shell (sh/bash) | | shfmt | ShellCheck | `mise install`. |
| JavaScript / JSX / TypeScript / TSX | typescript-language-server | Prettier | ESLint | `mise install`. Install project tools with `npm install --save-dev eslint prettier`. |
| JSON / JSONC | JSON Language Server | Prettier | Server syntax/schema diagnostics | `mise install`. |
| Markdown | | | Markdownlint | `mise install`. |

Open a matching file and use `:LspInfo` to check that its server attached. `:checkhealth vim.lsp` can help diagnose problems.

Tools are installed and activated by `./install.sh`. Restart your shell and any
existing Neovim session afterwards to pick up the updated `PATH`.

rust-analyzer runs `cargo clippy` on save in Cargo projects and publishes its
diagnostics through LSP. No separate nvim-lint integration is needed. To add
Clippy to an existing Rust installation, run `rustup component add clippy`.
Restart Neovim after changing the configuration. Run `cargo clippy` from the
project directory to check the tool independently.

conform.nvim selects the configured formatter for `,lf`, independently of LSP.
Only Python formats automatically on save; Lua and other languages use `,lf`.
LSP formatting is the fallback when the external formatter is unavailable.
Bypass format-on-save once with `:noautocmd w`. Use `:ConformInfo` to inspect
formatter availability.

nvim-lint runs Ruff, ShellCheck, clang-tidy, Markdownlint, and ESLint for their
configured filetypes when buffers are opened, saved, or after leaving insert
mode. Missing executables are skipped with one warning per executable per session.
Availability is rechecked on each lint attempt; installed tools are picked up if
their directory is already on Neovim's `PATH`. Failures from available tools remain
visible in `:messages`.
LSP diagnostics run independently; Rust, Typst, Lua, and JSON need no separate
nvim-lint integration.

### Project configuration

- **C/C++:** provide `compile_commands.json` for compiler flags and include paths.
  Configure checks in `.clang-tidy` and formatting in `.clang-format`. clang-tidy
  runs through nvim-lint; clangd starts with `--clang-tidy=false` to avoid
  duplicate checks. Checks on large projects can be costly.
- **Lua:** without a root `.luarc.json` or `.luarc.jsonc`, LuaLS uses LuaJIT,
  recognizes the `vim` global, and loads Neovim API types. A project LuaLS config
  takes precedence over these Neovim defaults.
- **JavaScript/TypeScript:** use `jsconfig.json` or `tsconfig.json` to define the
  project. Enable `checkJs` there if you want JavaScript type-checking. ESLint
  requires a project `eslint.config.*`; run `npm init @eslint/config@latest` in
  the project to create one and select TypeScript/React support when needed.
  Prettier uses the project's configuration, such as `.prettierrc`.
  ESLint and Prettier search the buffer's ancestors for `node_modules/.bin`
  executables before falling back to `PATH`. Neither integration downloads tools.
  ESLint runs only through nvim-lint, not an additional ESLint LSP client.
- **JSON/JSONC:** jsonls supplies completion, syntax checks, and schema validation.
  Package manifests and JS/TS configuration files use SchemaStore schemas, which
  require network access. Other files can declare a `$schema` URL. Prettier
  formats both filetypes; jsonls supplies fallback formatting. For JSON with
  comments in a `.json` file, select `:set filetype=jsonc`.
  Strict JSON validation with jsonlint is optional: install with
  `npm install -g jsonlint` and run `jsonlint file.json` manually. It is not run
  automatically and does not support JSONC.
- **Markdown:** configure rules in `.markdownlint.json` or `.markdownlint.yaml`.
  The editor uses the `markdownlint` executable from `markdownlint-cli`.
- **Shell:** ShellCheck reports shell-script issues. shfmt uses `.editorconfig`
  when present, otherwise the buffer's indentation settings.

## Keybindings

These bindings use normal mode unless marked otherwise. Plugin bindings require the corresponding plugin.

Press `,` and pause to see the which-key popup with labeled completions for all leader bindings.

Action labels come from each mapping's `desc`; which-key registers only groups.
Custom mappings use bracketed mnemonics where natural. mini.ai, mini.bracketed,
and mini.splitjoin retain their own labels. mini.icons supplies which-key icons;
a Nerd Font is required. Set `icons.mappings = false` in which-key setup to hide them.
Leader groups: `,g` Git, `,h` Git hunks, `,l` LSP, `,s` Search, and `,t` Toggle.
Press `gr` and pause to see the LSP Actions group.

### Files, buffers, and search

| Keys | Action |
| --- | --- |
| `-` | Open the current file's parent directory in oil. |
| `,f` | Find a file. |
| `,gf` | Find a Git-tracked file (fzf only). |
| `,b` | Select a buffer. |
| `,st` | Search tags. |
| `,c` | Delete the buffer without closing its window (mini.bufremove). |
| `,z` | Switch to the alternate buffer. |
| `[b` / `]b` | Go to the previous / next buffer (mini.bracketed). |
| `[f` / `]f` | Open the previous / next file in the current file's directory (mini.bracketed). |
| `,q` / `,w` | Quit the current window / write the current buffer. |
| `,/` | Live grep with ripgrep. |
| `,sb` / `,so` | Search lines in the current buffer / all open buffers. |
| `,sd` | Search workspace diagnostics. |
| `,sw` (normal / visual) | Search the word under the cursor / selected text with ripgrep (requires fzf and ripgrep). |
| `Ctrl-t` / `Ctrl-s` / `Ctrl-v` (fzf picker) | Open the result in a tab / split / vertical split. |

`,f`, `,b`, and `,st` open fzf-lua pickers with previews; fzf is required.
File pickers prefer `fd`, then `fdfind`, then `rg --files`, then `find`, and include hidden files except `.git`.
Run `:FzfLua` to list all pickers, such as LSP symbols, diagnostics, and keymaps.
`:TodoFzfLua` searches project TODO comments. TODO quickfix/location-list commands
need plenary.nvim, which this configuration does not install.

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
| `[g` / `]g` | Go to the previous / next Git hunk, including in diff windows. |
| `,hs` / `,hr` (normal / visual) | Stage / reset the current hunk or selected lines. |
| `,hS` / `,hR` | Stage / reset all changes in the current buffer. |
| `,hp` / `,hi` | Preview a hunk in a popup / inline. |
| `,hb` | Show blame for the current line. |
| `,tb` | Toggle current-line Git blame. |
| `,ti` | Toggle Git intra-line diff highlighting. |
| `,hd` / `,hD` | Diff against the index / parent commit. |
| `,hq` / `,hQ` | Put changed hunks from the current file / repository into quickfix. |
| `ih` (visual / operator-pending) | Select a Git hunk. |

Gitsigns adds these bindings only to attached buffers. Its blame and intra-line
diff toggles change settings for the whole session, not only the current buffer.
mini.bracketed uses `[c` / `]c` for comment navigation. To execute native diff
navigation without mappings, use `:normal! [c` or `:normal! ]c` in a diff window.

### Editing

| Keys | Action |
| --- | --- |
| `<` / `>` / `=` (visual) | Change indentation or reindent, then keep the selection. |
| `,tw` / `,ts` | Toggle wrapping / spell checking in the current window. |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments (built-in, uses `commentstring`). |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding characters or tags (nvim-surround). |
| `ys{motion}{char}` / `yss{char}` / `S` (visual) | Add surrounding characters or tags (nvim-surround). |
| `gS` (normal / visual) | Toggle bracketed arguments between single-line and multiline layouts (mini.splitjoin). |
| `a{object}` / `i{object}` (visual / operator-pending) | Select around / inside a text object, such as `va)` or `ci'` (mini.ai). |
| `.` | Repeat the last surround operation (nvim-surround). |
| `Backspace` / `Enter` (insert) | Delete an empty pair / add an indented line inside one (mini.pairs). |

The `unnamedplus` clipboard setting makes ordinary yanks, deletes, and puts use
the system clipboard when a clipboard provider is available. There are no
custom clipboard leader bindings.
mini.pairs inserts matching brackets and quotes automatically; typing a closing character skips over an existing one.

mini.splitjoin supports dot-repeat and needs no Treesitter parser. Detection uses
Lua patterns and can misidentify arguments. In visual mode, select the surrounding
brackets too (for example, `va)` then `gS`). Format-on-save may reformat the result.

### Navigation

| Keys | Action |
| --- | --- |
| `s` | Flash jump: type a search string, then the label shown. Works in normal, visual, and operator-pending mode. |
| `S` | Flash Treesitter selection in normal and operator-pending modes. For visual `S`, see Editing. |
| `f` / `F` / `t` / `T` | Flash single-character motions. The default configuration does not add jump labels to these motions. |
| `;` / `,,` | Repeat the last character motion forward / backward; comma alone is the leader. |
| `Alt-p` / `Alt-n` | Go to the previous / next reference to the symbol under the cursor (Illuminate defaults). |
| `[q` / `]q` | Go to the previous / next quickfix item (mini.bracketed). |
| `[l` / `]l` | Go to the previous / next location-list item (mini.bracketed). |
| `[x` / `]x` | Go to the previous / next Git conflict marker (mini.bracketed). |
| `Ctrl-h/j/k/l` | Move between splits and tmux panes with smart-splits. |

Outside tmux, `Ctrl-h/j/k/l` moves between Neovim splits.

### LSP and completion

LSP navigation and action bindings require an attached server. The formatting binding `,lf` uses conform.nvim independently.

| Keys | Action |
| --- | --- |
| `grd` | Go to the definition. |
| `gri` / `grr` | Find implementations / references with fzf-lua. |
| `grt` | Go to the type definition. |
| `gO` | Search symbols in the current document. |
| `gW` | Search workspace symbols with live server queries. |
| `K` | Show hover information. |
| `grn` | Rename a symbol. |
| `gra` (normal / visual) | Select a code action with Neovim's native interface. |
| `Ctrl-w d` | Show diagnostics at the cursor (built-in). |
| `,td` | Toggle inline diagnostic text in the current buffer (LSP and linters). Defaults off for Markdown, on for other filetypes. Signs, underlines, navigation, and diagnostic floats remain available. |
| `[d` / `]d` | Go to the previous / next diagnostic. |
| `,lf` | Format the buffer. See [Language servers and formatters](#language-servers-and-formatters) for installation and format-on-save behavior. |
| `Ctrl-p` / `Ctrl-n` (insert) | Select the previous / next completion item. |
| `Ctrl-y` (insert) | Select and accept a completion item. |
| `Tab` / `Shift-Tab` (insert) | Jump forward / backward through snippet placeholders. |
| `Ctrl-e` (insert) | Dismiss the completion menu. |

Definitions, implementations, and type definitions jump directly when the server
returns one result; multiple results open an fzf-lua picker. References and symbol
searches always open a picker when results exist. Visual code actions use the
selected range. `gW` queries the language
server as you type, so results depend on the server's workspace-symbol support.
Use `Ctrl-t` to return after a navigation jump. Rename, code actions, and hover use
Neovim's native LSP interface. The search pickers require fzf. No custom declaration,
diagnostic location-list, or inlay-hint toggle shortcut is configured.

## Commands

| Command | Action |
| --- | --- |
| `:Indent {n}` | Set only the current buffer's indentation to a positive integer number of spaces, e.g. `:Indent 2`. |
| `:SudoWrite` / `:w!!` | Save the whole file with root permissions. Needs a named file buffer, marks it saved only after a successful write, and overwrites directly without a backup or atomic replacement. |
| `:Markview` / `:Markview enable` / `:Markview disable` | Toggle or set inline rendering of headings, tables, code blocks, and checkboxes. Raw syntax returns when the cursor enters an element. On by default for Markdown and Typst. |

In command-line mode, `%%` inserts the current file's directory. `:bd` keeps its
native behavior; use `,c` for layout-preserving buffer deletion.

## Themes and appearance

Use `:colorscheme` to change themes.
Available themes: `kanagawa-wave`, `gruvbox-material`, `tokyonight-night`, and `sonokai` (shusia variant).
`:FzfLua colorschemes` opens a picker when fzf is available. Each session starts
with Kanagawa Wave; theme changes are not saved.

Split borders use heavy lines. colorful-winsep highlights borders around the
active split without animation, using its default highlight settings.

## Plugin updates and rollback

Run `:lua vim.pack.update()` to update all plugins. A confirmation buffer shows
the changes; write it to confirm or quit to discard, then restart Neovim. Back up
the local `nvim-pack-lock.json` before updating if you want a rollback point.

To roll back, restore that local backup and restart Neovim, then run:

```vim
:lua vim.pack.update(nil, { offline = true, target = 'lockfile' })
```

Review and confirm the changes, then restart again.
The lockfile does not cover Treesitter parsers, language servers, or formatter binaries.
