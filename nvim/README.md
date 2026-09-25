# Neovim on WSL

Run Neovim and its external tools inside WSL, even when the terminal is Windows Terminal. Keep language servers on the Linux `PATH` used to start `nvim`, rather than installing their Windows versions.

## Neovim

Use Neovim 0.11 or newer for the planned built-in LSP configuration. Check the version with `nvim --version`. See the [official installation instructions](https://neovim.io/doc/install/) if an Ubuntu package is too old. This machine currently uses a 0.12 development build; the instructions below do not change it.

## Language servers

These are prerequisites for the Python, Rust, C, and C++ configuration planned in later steps. Installing them alone does **not** enable language support in the current `init.vim`. Use a WSL shell to run the commands below.

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

`nvm` selects a Node.js version per shell. Ensure the version containing `basedpyright-langserver` is active when you launch Neovim.

### Rust: rust-analyzer

With [rustup](https://rustup.rs/) installed inside WSL, add the language server and formatter for your active toolchain:

```sh
rustup component add rust-analyzer rustfmt
rustup component list --installed
rust-analyzer --version
```

Having a `rust-analyzer` launcher on `PATH` is not enough: `rustup component list --installed` must include `rust-analyzer` for the selected toolchain. If a project pins a toolchain in `rust-toolchain.toml`, install the component for that toolchain as well.

### C and C++: clangd

```sh
sudo apt update
sudo apt install clangd
clangd --version
```

Both C and C++ use `clangd`. For project-specific include paths and compiler flags, provide a `compile_commands.json` compilation database. With CMake, generate one with:

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Check that `build/compile_commands.json` exists. For other build systems, follow their compilation-database instructions.

## Verify in Neovim (after LSP configuration is added)

Open a `.py`, `.rs`, `.c`, or `.cpp` file inside a project. Run `:checkhealth vim.lsp` and `:LspInfo` to check server attachment, then try `gd` for definition and `K` for hover. If no server starts, check its executable in the same WSL shell that launches Neovim and inspect `:messages`. These checks become applicable when the corresponding configuration steps are complete.

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
