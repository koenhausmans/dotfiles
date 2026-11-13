# Neovim configuration

## Setup

This configuration requires Neovim **0.12+** and uses `vim.pack`, the plugin
manager built into Neovim 0.12.
Run Neovim and its external tools inside WSL.
Language servers and formatters must be on the Linux `PATH` used to start Neovim.
The leader key is `,`.

On first start, plugins are downloaded automatically. Restart Neovim once after
the initial install to apply all settings.

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

- Language support: completion, snippets, signature help, diagnostics, and formatting.
- Files and navigation: editable directory buffers, fuzzy search, and labeled jumps.
- Git: history, diffs, change markers, blame, and hunk actions.
- Appearance: statusline, TODO and reference highlights, rendered documents, indent guides, and highlighted split borders.
- Editing: four-space indentation, persistent undo, smart-case search, marker folds, and splits that open below or to the right.
- Defaults: line numbers, visible whitespace, a fixed sign column, and a cursor line in the active window.

Cursor-line highlighting and relative line numbers follow window focus. Inactive
windows keep absolute line numbers. Switching away from Neovim also disables
both features when the terminal forwards focus events.

Spelling is enabled for Markdown, Git commit messages, and todo files.

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
| Markdown | rumdl | rumdl (through LSP) | rumdl (through LSP) | `mise install`. |

Open a matching file and use `:LspInfo` to check that its server attached. `:checkhealth vim.lsp` can help diagnose problems.

Tools are installed and activated by `./install.sh`. Restart your shell and any
existing Neovim session afterwards to pick up the updated `PATH`.

rust-analyzer runs `cargo clippy` on save in Cargo projects.
If Clippy is missing, run `rustup component add clippy`.

Use `,lf` to format the buffer. Only Python formats automatically on save.
Formatting uses the language server when the external formatter is unavailable.
Bypass format-on-save once with `:noautocmd w`. Use `:ConformInfo` to inspect
formatter availability.

Linting runs automatically when opening files, saving, and leaving insert mode.
Missing tools are skipped with one warning per executable per session. Check
`:messages` for linter failures. LSP diagnostics run independently.

### Project configuration

- **C/C++:** provide `compile_commands.json` for compiler flags and include paths.
  Configure checks in `.clang-tidy` and formatting in `.clang-format`.
  clang-tidy checks can be slow on large projects.
- **Lua:** without a root `.luarc.json` or `.luarc.jsonc`, LuaLS uses LuaJIT,
  recognizes the `vim` global, and loads Neovim API types. A project LuaLS config
  takes precedence over these Neovim defaults.
- **JavaScript/TypeScript:** use `jsconfig.json` or `tsconfig.json` to define the
  project. Enable `checkJs` there if you want JavaScript type-checking. ESLint
  requires a project `eslint.config.*`; run `npm init @eslint/config@latest` in
  the project to create one and select TypeScript/React support when needed.
  Prettier uses the project's configuration, such as `.prettierrc`.
  ESLint and Prettier prefer project-local tools in `node_modules/.bin` over `PATH`.
  Neither integration downloads tools.
- **JSON/JSONC:** package manifests and JS/TS configuration files use SchemaStore
  schemas, which require network access. Other files can declare a `$schema` URL.
  For JSON with comments in a `.json` file, select `:set filetype=jsonc`.
- **Markdown:** see [rumdl configuration](../tool-configs/rumdl/README.md) for global defaults
  and project overrides.
- **Shell:** shfmt uses `.editorconfig` when present, otherwise the buffer's indentation settings.

## Keybindings

These bindings use normal mode unless marked otherwise.
fzf-lua pickers require fzf. Text searches also require ripgrep.

Press `,` to see the which-key popup with shortcuts for the current buffer and mode.
Press `g`, `gr`, `[`, or `]` to explore other groups.
Insert-mode completion and fzf picker shortcuts use their own interfaces.

Leader groups: `,g` Git, `,h` Git hunks, `,l` LSP, `,s` Search, and `,t` Toggle.
Git hunks, LSP, and Search also have visual-mode actions.

### Files, buffers, and search

| Keys | Action |
| --- | --- |
| `-` | Open the current file's parent directory in oil. |
| `,f` | Find a file. |
| `,gf` | Find a Git-tracked file. |
| `,b` | Select a buffer. |
| `,s.` | Search recently opened files. |
| `,sc` | Search command history. |
| `,ss` | Search available fzf-lua pickers. |
| `,sr` | Resume the last picker and its query. |
| `,st` / `,sT` | Search TODO comments / tags. |
| `,c` | Delete the buffer without closing its window (mini.bufremove). |
| `,z` | Switch to the alternate buffer. |
| `,q` / `,w` | Quit the current window / write the current buffer. |
| `,/` | Live grep with ripgrep. |
| `,sb` / `,so` | Search lines in the current buffer / all open buffers. |
| `,sd` | Search workspace diagnostics. |
| `,sw` (normal / visual) | Search the word under the cursor / selected text. |
| `Ctrl-t` / `Ctrl-s` / `Ctrl-v` (fzf picker) | Open the result in a tab / split / vertical split. |
| `F1` / `F4` (fzf picker) | Show shortcut help / toggle the preview. |
| `Alt-h` / `Alt-i` (file picker) | Toggle hidden / ignored files. |

`,f`, `,b`, and `,sT` open fzf-lua pickers with previews.
File pickers include hidden files except `.git`.
Use `,ss` or `:FzfLua` to list built-in pickers, such as LSP symbols, diagnostics, and keymaps.
Opening another picker can replace the resume target for `,sr`.
TODO quickfix and location-list commands are unavailable.

#### Directory buffers (oil.nvim)

| Keys | Action |
| --- | --- |
| `Enter` | Open the file or directory under the cursor. |
| `Ctrl-x` / `Ctrl-s` / `Ctrl-t` | Open in a horizontal split / vertical split / tab. |
| `Ctrl-p` | Preview the selected file. |
| `-` | Go up to the parent directory. |
| `_` | Open the current working directory. |
| `g.` | Toggle hidden files. |
| `gR` | Refresh the directory. |
| `g?` | Show the full list of oil keybindings. |

Edit filenames directly in the buffer and save with `:w` to rename or move files.
Delete a line to delete the file. Open oil with `:e .`.
`Ctrl-h/j/k/l` still navigate splits and tmux panes in directory buffers.

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
`[c` / `]c` navigate comments. To execute native diff
navigation without mappings, use `:normal! [c` or `:normal! ]c` in a diff window.

#### History and diffs (Diffview)

Use `:DiffviewOpen` for repository changes, `:DiffviewFileHistory` for history, and `:DiffviewClose` to close the view.
These shortcuts apply inside Diffview. Press `g?` for the full list in the current panel.

| Keys | Action |
| --- | --- |
| `,gb` / `,e` | Toggle / focus the file panel. |
| `Tab` / `Shift-Tab` | Open the next / previous file's diff. |
| `,gco` / `,gct` / `,gcb` / `,gca` | Choose ours / theirs / base / all for the current conflict in a diff buffer. |
| `,gcO` / `,gcT` / `,gcB` / `,gcA` | Apply that choice to every conflict in the file. Available in diff buffers and the file panel. |
| `dx` / `dX` | Delete the current conflict region / all conflict regions in the file. |

`,b` still opens the buffer picker. `,c` still closes the buffer without closing its window.

### Editing

| Keys | Action |
| --- | --- |
| `<` / `>` / `=` (visual) | Change indentation or reindent, then keep the selection. |
| `,tw` / `,ts` | Toggle wrapping / spell checking in the current window. |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments. |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding characters or tags (nvim-surround). |
| `ys{motion}{char}` / `yss{char}` | Add surrounding characters or tags around a motion / the current line. |
| `S` (visual) | Add surrounding characters or tags around the selection. |
| `yS{motion}{char}` / `ySS{char}` / `cS{old}{new}` | Add / change surrounding characters or tags on separate lines. |
| `Ctrl-g s` / `Ctrl-g S` (insert) | Add surrounding characters at the cursor / on separate lines. |
| `gS` (normal / visual) | Toggle bracketed arguments between single-line and multiline layouts (mini.splitjoin). |
| `a{object}` / `i{object}` (visual / operator-pending) | Select around / inside a text object, such as `va)` or `ci'` (mini.ai). |
| `aa{object}` / `ii{object}` (visual / operator-pending) | Select around / inside the next text object. |
| `al{object}` / `il{object}` (visual / operator-pending) | Select around / inside the previous text object. |
| `g[{object}` / `g]{object}` (normal / visual / operator-pending) | Move to the left / right edge of a text object. |
| `Alt-i` (visual / operator-pending) | Select a reference to the symbol under the cursor. |
| `.` | Repeat the last change, including surround and split/join operations. |
| `Backspace` / `Enter` (insert) | Delete an empty pair / add an indented line inside one (mini.pairs). |

Yanks, deletes, and puts use the system clipboard when a clipboard provider is available.
Matching brackets and quotes appear automatically. Type a closing character to skip an existing one.

`gS` supports dot-repeat but can misidentify arguments. In visual mode, select the
surrounding brackets too (for example, `va)` then `gS`). Format-on-save may reformat the result.

### Navigation

| Keys | Action |
| --- | --- |
| `s` | Flash jump: type a search string, then the label shown. Works in normal, visual, and operator-pending mode. |
| `S` | Flash Treesitter selection in normal and operator-pending modes. For visual `S`, see Editing. |
| `f` / `F` / `t` / `T` (normal / visual / operator-pending) | Flash single-character motions without jump labels. |
| `;` (normal / visual / operator-pending) | Repeat the last character motion forward. |
| `,,` | Repeat the last character motion backward. Comma alone is the leader. |
| `Alt-p` / `Alt-n` | Go to the previous / next reference to the symbol under the cursor (Illuminate defaults). |
| `Ctrl-h/j/k/l` | Move between splits and tmux panes with smart-splits. |

#### Bracket navigation

Use `[` / `]` plus a lowercase suffix for the previous / next item.
Use an uppercase suffix for the first / last item, such as `[B` / `]B` for buffers.
All suffixes below work in normal mode. The last column lists additional modes.

| Suffix | Target | Additional modes |
| --- | --- | --- |
| `b` | Listed buffers | |
| `c` | Comments | Visual, operator-pending |
| `d` | Diagnostics | Visual, operator-pending |
| `f` | Files in the current file's directory | |
| `i` | Indentation changes | Visual, operator-pending |
| `j` | Jumps within the current buffer | Operator-pending |
| `l` | Location-list items | |
| `o` | Recently visited files | |
| `q` | Quickfix items | |
| `t` | Treesitter nodes | Visual, operator-pending |
| `u` | Undo states | |
| `w` | Windows | |
| `x` | Git conflict markers | Visual, operator-pending |
| `y` | Yank history, replacing the latest pasted region | |

See `:help MiniBracketed` for details. Treesitter navigation requires a parser.
On Neovim 0.13+, suffix `m` also navigates multicursor positions in normal mode.

### LSP and completion

LSP navigation and action bindings require an attached server. Formatting with `,lf` does not.

| Keys | Action |
| --- | --- |
| `grd` | Go to the definition. |
| `gri` / `grr` | Find implementations / references with fzf-lua. |
| `grt` | Go to the type definition. |
| `gO` | Search symbols in the current document. |
| `gW` | Search workspace symbols with live server queries. |
| `K` | Show hover information. |
| `grn` | Rename a symbol. |
| `gra` (normal / visual) | Select a code action with fzf-lua. |
| `Ctrl-w d` | Show diagnostics at the cursor (built-in). |
| `,td` | Toggle inline diagnostic text in the current buffer (LSP and linters). Defaults off for Markdown, on for other filetypes. Signs, underlines, navigation, and diagnostic floats remain available. |
| `,lf` (normal / visual) | Format the buffer / selection. See [Language servers and formatters](#language-servers-and-formatters) for installation and format-on-save behavior. |
| `Ctrl-p` / `Ctrl-n` or `Up` / `Down` (insert) | Select the previous / next completion item. |
| `Ctrl-y` (insert) | Select and accept a completion item. |
| `Tab` / `Shift-Tab` (insert) | Jump forward / backward through snippet placeholders. |
| `Ctrl-e` (insert) | Cancel completion. |
| `Ctrl-Space` (insert) | Open completion, then show / hide its documentation. |
| `Ctrl-b` / `Ctrl-f` (insert) | Scroll completion documentation up / down. |
| `Ctrl-k` (insert) | Show / hide signature help. |

Definitions, implementations, and type definitions jump directly when the server
returns one result; multiple results open an fzf-lua picker. References and symbol
searches always open a picker when results exist. Visual code actions use the
selected range. `gW` results depend on the server's workspace-symbol support.
Use `Ctrl-t` to return after a navigation jump.

Selection menus that use `vim.ui.select`, including code actions, use fzf-lua
and require fzf. Input prompts, such as symbol renaming, are unchanged.

In command-line mode, `Tab` opens completion or selects the next item. `Shift-Tab` selects the previous item.
`Ctrl-n` / `Ctrl-p` and `Right` / `Left` also select items.
`Ctrl-y` accepts, `Ctrl-e` cancels, and `End` hides the menu. `Ctrl-Space` also opens the menu.

## Commands

| Command | Action |
| --- | --- |
| `:Indent {n}` | Set only the current buffer's indentation to a positive integer number of spaces, e.g. `:Indent 2`. |
| `:SudoWrite` / `:w!!` | Save the whole file with root permissions. Needs a named file buffer, marks it saved only after a successful write, and overwrites directly without a backup or atomic replacement. |
| `:Markview` / `:Markview enable` / `:Markview disable` | Toggle or set inline rendering of headings, tables, code blocks, and checkboxes. Raw syntax returns when the cursor enters an element. On by default for Markdown and Typst. |

In command-line mode, `%%` inserts the current file's directory.

## Themes and appearance

Use `:colorscheme` to change themes.
Available themes: `kanagawa-wave`, `gruvbox-material`, `tokyonight-night`, and `sonokai` (shusia variant).
`:FzfLua colorschemes` opens a theme picker. Each session starts
with Kanagawa Wave; theme changes are not saved.

Split borders use heavy lines, with highlights around the active split and no animation.

## Plugin updates and rollback

The local `nvim-pack-lock.json` in the config directory pins plugin revisions.
It stays outside this repository.

Run `:lua vim.pack.update()` to update all plugins. A confirmation buffer shows
the changes; write it to confirm or quit to discard, then restart Neovim. Back up
the local `nvim-pack-lock.json` before updating if you want a rollback point.

To roll back, restore that local backup and restart Neovim, then run:

```vim
:lua vim.pack.update(nil, { offline = true, target = 'lockfile' })
```

Review and confirm the changes, then restart again.
The lockfile does not cover Treesitter parsers, language servers, or formatter binaries.
