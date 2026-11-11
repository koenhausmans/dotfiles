# Neovim configuration

## Setup

This configuration requires Neovim **0.12+** and uses `vim.pack`, the plugin
manager built into Neovim 0.12.
Run Neovim and its external tools inside WSL.
Language servers and formatters must be on the Linux `PATH` used to start Neovim.
The leader key is `,`.

On first start, plugins are downloaded automatically. Restart Neovim once after
the initial install to pick up all settings. The lockfile `nvim-pack-lock.json`
in the config directory pins revisions and should be kept under version control.

### Install a newer Neovim

On Linux (including WSL), install or update to the latest stable pre-built release:

```sh
./nvim/install-latest-release.sh
```

Run this from the dotfiles root. Requires Bash, curl, tar, and sudo; supports
x86-64 and ARM64. The script downloads and checks that the binary runs before
replacing `/opt/nvim-linux-x86_64` (or `/opt/nvim-linux-arm64`). It creates
`/usr/local/bin/nvim`, which takes precedence over `/usr/bin/nvim` on a standard
PATH, without removing the apt package. An unrelated file or symlink at
`/usr/local/bin/nvim` is not overwritten. The script does not change shell
configuration or run automatically with the dotfiles installer. Restart your
shell if it still selects the old binary; check with `command -v nvim` and
`nvim --version`.

See the [official installation guide](https://neovim.io/doc/install/) for other
platforms and installation methods. On Ubuntu/Ubuntu-based WSL, the
[Neovim unstable PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)
offers newer daily builds through apt (third-party, not stable releases).
On Debian, check [packages for your release](https://packages.debian.org/search?keywords=neovim);
do not use Ubuntu PPAs. Verify `nvim --version` is at least 0.12 after installation.

### Treesitter setup and upgrades

Parser installation needs a C compiler, curl, and **tree-sitter CLI 0.26.1+**;
Ubuntu 26.04's apt package is too old. With Rust/Cargo installed:

```sh
cargo install --locked tree-sitter-cli
tree-sitter --version
```

Ensure `~/.cargo/bin` is on Neovim's Linux `PATH`. Alternatively, use a binary
from the [tree-sitter releases](https://github.com/tree-sitter/tree-sitter/releases),
not the npm package. `install-latest-release.sh` warns if the CLI is missing or
too old but does not install it.

Parsers are installed automatically on first start. After plugin updates, run
`:TSUpdate` and restart. Use `:checkhealth nvim-treesitter` to diagnose failures.
Buffers without parsers keep their normal syntax and indentation.

## Overview

- Language support: built-in LSP, blink.cmp completion, snippets, signature help, nvim-lint linting, Trouble lists, and automatic formatting.
- Files and navigation: oil.nvim, fzf-lua, ripgrep, and Flash jumps.
- Git: status, history, blame, diffs, and change markers through Fugitive, Diffview, and Gitsigns.
- Appearance: Lualine statusline, TODO highlights, reference highlights, indent guides, and a sticky Treesitter scope header.
- Editing: four-space indentation, persistent undo, smart-case search, marker folds, and splits that open below or to the right.
- Defaults: line numbers, visible whitespace, a fixed sign column, and a cursor line in the active window.

Cursor-line highlighting and relative line numbers follow window focus. Inactive
windows keep absolute line numbers. Switching away from Neovim also disables
both features when the terminal forwards focus events.

Spelling is enabled for Markdown, Git commit messages, and todo files.
Python and CoffeeScript files lose trailing whitespace on write.

Enabled mini.nvim modules: pairs (automatic brackets and quotes), icons (with
web-devicons compatibility), ai (extended text objects), bracketed (navigation),
bufremove (layout-preserving buffer deletion), and splitjoin (argument layouts).

## Language servers and formatters

| Language | Server | Formatter | Linter | Installation |
| --- | --- | --- | --- | --- |
| Python | basedpyright | ruff | ruff | `npm install -g basedpyright` or `uv tool install basedpyright` (executable: `basedpyright-langserver`). [uv/install.sh](../uv/install.sh) installs ruff, or use `uv tool install ruff`. Ruff handles formatting, import sorting, and linting. |
| Rust | rust-analyzer | rustfmt | Clippy (through rust-analyzer) | `rustup component add rust-analyzer rustfmt rust-src clippy` for the active toolchain. |
| C/C++ | clangd | clang-format | clang-tidy | `sudo apt install clangd clang-format clang-tidy`. |
| Typst | Tinymist | typstyle | Tinymist compiler diagnostics | `cargo install --locked tinymist typstyle`, or install release binaries. Formatting falls back to Tinymist's formatter without typstyle. |
| Lua | Lua Language Server | StyLua | LuaLS diagnostics | Install `lua-language-server` from the [LuaLS releases](https://github.com/LuaLS/lua-language-server/releases) and `stylua` from the [StyLua releases](https://github.com/JohnnyMorganz/StyLua/releases); put their executables on `PATH`. |
| Shell (sh/bash) | | shfmt | ShellCheck | `sudo apt install shellcheck shfmt`. |
| JavaScript / JSX / TypeScript / TSX | typescript-language-server | Prettier | ESLint | `npm install -g typescript-language-server 'typescript@<7'`; install project tools with `npm install --save-dev eslint prettier`. |
| JSON / JSONC | JSON Language Server | Prettier | Server syntax/schema diagnostics | `npm install -g vscode-langservers-extracted`; use project-local Prettier or `npm install -g prettier` for standalone files. |
| Markdown | | | Markdownlint | `npm install -g markdownlint-cli` (not `markdownlint-cli2`). |

Open a matching file and use `:LspInfo` to check that its server attached. `:checkhealth vim.lsp` can help diagnose problems.

rust-analyzer runs `cargo clippy` on save in Cargo projects and publishes its
diagnostics through LSP. No separate nvim-lint integration is needed. To add
Clippy to an existing Rust installation, run `rustup component add clippy`.
Restart Neovim after changing the configuration. Run `cargo clippy` from the
project directory to check the tool independently.

conform.nvim selects the configured formatter for `,lf`, independently of LSP.
Only Lua and Python format automatically on save; other languages use `,lf`.
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
| `,q` | Put diagnostics in the current window's location list. |
| `,/` | Live grep with ripgrep. |
| `,sw` | Search for the word under the cursor with ripgrep (requires fzf and ripgrep). |
| `Ctrl-t` / `Ctrl-s` / `Ctrl-v` (fzf picker) | Open the result in a tab / split / vertical split. |

`,f`, `,b`, and `,st` open fzf-lua pickers with previews; fzf is required.
On Ubuntu, install `fd-find` to provide `fdfind`. File pickers prefer `fd`, then `fdfind`, then `rg --files`, then `find`, and include hidden files except `.git`.
Run `:FzfLua` to list all pickers, such as LSP symbols, diagnostics, and keymaps.

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
| `[c` / `]c` | Go to the previous / next Git change; use native diff navigation in diff mode. |
| `,hs` / `,hr` (normal / visual) | Stage / reset the current hunk or selected lines. |
| `,hS` / `,hR` | Stage / reset all changes in the current buffer. |
| `,hp` / `,hi` | Preview a hunk in a popup / inline. |
| `,hb` | Show blame for the current line. |
| `,hd` / `,hD` | Diff against the index / parent commit. |
| `,hq` / `,hQ` | Put changed hunks from the current file / repository into quickfix. |
| `ih` (visual / operator-pending) | Select a Git hunk. |

Gitsigns adds these bindings only to attached buffers.

### Editing

| Keys | Action |
| --- | --- |
| `<` / `>` / `=` (visual) | Change indentation or reindent, then keep the selection. |
| `,tw` / `,ts` | Toggle wrapping / spell checking in the current window. |
| `,y{motion}` / `,y` (visual) | Copy text to the system clipboard. `,yy` copies a line. |
| `,p` | Paste from the system clipboard. |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments (built-in, uses `commentstring`). |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding characters or tags (nvim-surround). |
| `ys{motion}{char}` / `yss{char}` / `S` (visual) | Add surrounding characters or tags (nvim-surround). The cursor stays in place after the operation. |
| `gS` (normal / visual) | Toggle bracketed arguments between single-line and multiline layouts (mini.splitjoin). |
| `a{object}` / `i{object}` (visual / operator-pending) | Select around / inside a text object, such as `va)` or `ci'` (mini.ai). |
| `.` | Repeat the last surround operation (vim-repeat). |
| `Backspace` / `Enter` (insert) | Delete an empty pair / add an indented line inside one (mini.pairs). |

The clipboard bindings use the `+` register. They do not change Neovim's default clipboard setting.
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
| `;` / `,` | Repeat the last Flash motion forward / backward. |
| `[m` / `]m` | Go to the previous / next Treesitter function start. |
| `[M` / `]M` | Go to the previous / next Treesitter function end. |
| `j` / `k` | Move by display line without a count, or by file line with a count. |
| `0` / `$` | Move to the first nonblank / last character of the display line. |
| `'` | Jump to an exact mark position. |
| `[r` / `]r` | Go to the previous / next reference to the symbol under the cursor (illuminate). |
| `[q` / `]q` | Go to the previous / next quickfix item (mini.bracketed). |
| `[l` / `]l` | Go to the previous / next location-list item (mini.bracketed). |
| `[x` / `]x` | Go to the previous / next Git conflict marker (mini.bracketed). |
| `Ctrl-h/j/k/l` | Move between splits and tmux panes with smart-splits. |

Outside tmux, `Ctrl-h/j/k/l` moves between Neovim splits.

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
| `:StripTrailingWhitespaces` | Remove trailing whitespace. |
| `:Indent {n}` | Set the current buffer's indentation to `n` spaces, e.g. `:Indent 2`. |
| `:SudoWrite` / `:w!!` | Save the whole file with root permissions. Needs a named file buffer, marks it saved only after a successful write, and overwrites directly without a backup or atomic replacement. |
| `:Markview` / `:Markview enable` / `:Markview disable` | Toggle or set inline rendering of headings, tables, code blocks, and checkboxes. Raw syntax returns when the cursor enters an element. On by default for Markdown and Typst. |
| `:TSContextToggle` | Show or hide the Treesitter scope header with the enclosing function or block. |

In command-line mode, `:bd` expands to `:Bdelete` and `%%` inserts the current file's directory.

## Themes and appearance

Use `:colorscheme` to change themes.
Available themes: `kanagawa-wave`, `gruvbox-material`, `tokyonight-night`, and `sonokai` (shusia variant).
`:FzfLua colorschemes` opens a picker when fzf is available. Neovim saves and restores theme changes across sessions.

Split borders use heavy lines. Borders beside the active split use the theme's
warm gold/yellow accent, distinct from [tmux](../tmux/tmux.conf)'s blue/aqua
active borders. Other borders keep the matching theme's muted inactive color.
Colors update on theme and focus changes.
Neovim colors separators through the window on their left or above, so a shared
edge in a nested layout can also receive the active color. Other colorschemes
keep their own separator colors.

## Plugin updates and rollback

Run `:lua vim.pack.update()` to update all plugins. A confirmation buffer shows
the changes; write it to confirm or quit to discard, then restart Neovim.

To revert after an update, restore the lockfile from version control:

```sh
git checkout HEAD -- ~/.config/nvim/nvim-pack-lock.json
```

Then restart Neovim. Neovim re-installs plugins at the pinned revisions on startup.
The lockfile does not cover Treesitter parsers, language servers, or formatter binaries.
