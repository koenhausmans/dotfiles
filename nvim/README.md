# Neovim on WSL

Run Neovim and its external tools inside WSL, even when the terminal is Windows Terminal. Keep language servers on the Linux `PATH` used to start `nvim`, rather than installing their Windows versions.

## Neovim

Use Neovim 0.11 or newer for the planned built-in LSP configuration. Check the version with `nvim --version`. See the [official installation instructions](https://neovim.io/doc/install/) if an Ubuntu package is too old. This machine currently uses a 0.12 development build; the instructions below do not change it.

## Language servers

These are prerequisites for the Python, Rust, C, and C++ configurations in `init.vim`. Installing a server alone does **not** enable it in Neovim. Use a WSL shell to run the commands below.

### Python: basedpyright

Install a current Linux Node.js LTS release and npm first. If you use [nvm](https://github.com/nvm-sh/nvm), for example:

```sh
nvm install --lts
nvm use --lts
npm install -g basedpyright
```

Check that `node`, `npm`, and the language server resolve to WSL executables, not paths under `/mnt/c`:

```sh
command -v node npm basedpyright-langserver
basedpyright --version
```

`nvm` selects a Node.js version per shell. Ensure the version containing `basedpyright-langserver` is active when you launch Neovim. If you want new shells to use LTS by default, run `nvm alias default 'lts/*'`; projects can still choose a different version with `nvm use`.

The config enables basedpyright for Python files. Open a `.py` file in a project and run `:LspInfo` to confirm it attached. In that buffer, `gd` jumps to a definition, `K` shows hover help, `gr` finds references, `Space l r` renames, and `[d` / `]d` move between diagnostics. These mappings are local to buffers with an attached language server. Basedpyright provides diagnostics and completion, not code formatting; `Space l f` needs a formatting-capable server before it can format Python.

### Rust: rust-analyzer

With [rustup](https://rustup.rs/) installed inside WSL, add the language server and formatter for your active toolchain:

```sh
rustup component add rust-analyzer rustfmt rust-src
rustup component list --installed
rust-analyzer --version
```

Having a `rust-analyzer` launcher on `PATH` is not enough: `rustup component list --installed` must include `rust-analyzer` for the selected toolchain. `rust-src` helps rust-analyzer navigate into the standard library. If a project pins a toolchain in `rust-toolchain.toml`, run the install command from that project to add the components to its toolchain too.

The config enables rust-analyzer for Rust files. Open a `.rs` file in a Cargo project and run `:LspInfo` to confirm it attached. The shared LSP keys (`gd` for definition, `K` for hover, `Space l r` for rename, `[d` / `]d` for diagnostics) work here as in Python. `Space l f` requests formatting through rust-analyzer and rustfmt; formatting on save is not enabled.

### C and C++: clangd

```sh
sudo apt update
sudo apt install clangd
clangd --version
```

Both C and C++ use `clangd`. For project-specific include paths and compiler flags, provide a `compile_commands.json` compilation database. If your project uses CMake, install it with `sudo apt install cmake`, then generate a database with:

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json compile_commands.json
```

Run these from the project root. Check that `build/compile_commands.json` exists before creating the link; skip `ln -s` if a root-level `compile_commands.json` already exists. Keep the link relative so it continues to work if the project moves. For other build systems, follow their compilation-database instructions. Without a compilation database, clangd may use incorrect include paths or compiler flags.

The config enables clangd for both C and C++ files. Open a `.c` or `.cpp` file in a project and run `:LspInfo` to confirm it attached. The shared LSP keys (`gd`, `K`, `Space l r`, `[d` / `]d`) work here too; `Space l f` requests formatting from clangd. Use `:LspClangdSwitchSourceHeader` to switch between a source file and its header when clangd can identify the pair.

## Verify in Neovim

Open a `.py`, `.rs`, `.c`, or `.cpp` file inside a project. Run `:checkhealth vim.lsp` and `:LspInfo` to check server attachment, then try `gd` for definition and `K` for hover. If no server starts, check its executable in the same WSL shell that launches Neovim and inspect `:messages`.

## File and text search

The config uses [fzf](https://github.com/junegunn/fzf) for file selection and [Ag](https://github.com/ggreer/the_silver_searcher) for text search. Install Ag inside WSL with `sudo apt install silversearcher-ag`. The fzf binary can be on `PATH` or in `~/.fzf/bin/fzf`; keep the `fzf.vim` plugin installed with `:PlugInstall`.

| Keys | Action |
| --- | --- |
| `Space f f` (or `,f`) | Fuzzy-find files in the current working directory. |
| `Space f g` | Fuzzy-find Git-tracked files (`:GFiles`). |
| `Space f b` (or `,b`) | Pick an open buffer. |
| `Space s g` (or `,/`) | Enter an Ag text search, then press Enter. |
| `Space s w` | Ag search for the literal whole word under the cursor. |
| `,t` | Search tags. |

`Space` is the leader key. If fzf is unavailable, `,f`, `,b`, and `,t` use the existing Vim fallbacks. If fzf or Ag is unavailable, `,/` starts `:grep` instead. `:Files` uses fzf's file walker (which skips `.git` and `node_modules` by default); `:GFiles` uses Git's tracked-file list. An existing shell-level `FZF_DEFAULT_COMMAND` still takes precedence over fzf's walker.

## Git views

Run `:PlugInstall` after updating the config to install Diffview and gitsigns. Fugitive provides the status view; Diffview provides changes and history panes without an icon plugin. Gitsigns marks changed lines in the sign column. Open a file in a Git repository before using current-file history.

| Keys | Action |
| --- | --- |
| `Space g s` | Open Fugitive status (`:Git`). |
| `Space g d` | Open the Diffview changes pane (`:DiffviewOpen`). |
| `Space g h` | Show the current file's history (`:DiffviewFileHistory %`). |
| `[h` / `]h` | Jump to the previous / next changed hunk in a tracked file. |

Plain `gd` remains LSP go-to-definition. Use `:DiffviewClose` to leave a diff view; `:DiffviewFileHistory` without `%` shows repository history. These shortcuts only open views, but Diffview has its own actions for staging and restoring changes: consult `:help diffview` before using them.

The existing statusline shows the branch and nonzero `+added ~changed -removed` counts for the current file. It shows no Git section outside a repository and runs no `git status` command on redraw. `:PlugClean` can remove the old gitgutter plugin after you have reviewed the replacement; it is not needed to activate gitsigns.

## Editing keys and defaults

| Keys | Action |
| --- | --- |
| `Space w` | Save the current file (`:write`). |
| `Space b d` | Close the current buffer while keeping its window (`:Bdelete`). |
| `Space b p` | Switch to the alternate buffer (`:b#`). |
| `Space l r` / `Space l a` | LSP rename / code action (only in attached buffers). |
| `Space l d` / `Space l f` | Show diagnostics / format (only in attached buffers). |

The existing comma shortcuts and `Space r`, `Space a`, and `Space e` LSP shortcuts remain available. Formatting moved from `Space f` to `Space l f`, so `Space f f`, `Space f g`, and `Space f b` do not wait to see whether you meant to format. `signcolumn=yes` keeps Git and diagnostic markers from shifting the text, `scrolloff=5` leaves context near the cursor, and `termguicolors` enables true colors in Windows Terminal. To compare the previous palette, run `:set notermguicolors`. Windows clipboard integration remains opt-in; check `:checkhealth vim.provider` before trying `"+y` or `"+p`.
