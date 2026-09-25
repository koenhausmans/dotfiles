# Neovim on WSL

Run Neovim and its external tools inside WSL, even when the terminal is Windows Terminal. Keep language servers on the Linux `PATH` used to start `nvim`, rather than installing their Windows versions.

## Neovim

Use Neovim 0.11 or newer for the built-in LSP configuration in `init.vim`. Check with `nvim --version`. See the [official installation instructions](https://neovim.io/doc/install/) if an Ubuntu package is too old.

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

The config enables basedpyright for Python files. Open a `.py` file in a project and run `:LspInfo` to confirm it attached. Basedpyright provides diagnostics and completion, not code formatting. `Space l f` needs a formatting-capable server to format Python.

### Rust: rust-analyzer

With [rustup](https://rustup.rs/) installed inside WSL, add the language server and formatter for your active toolchain:

```sh
rustup component add rust-analyzer rustfmt rust-src
rustup component list --installed
rust-analyzer --version
```

Having a `rust-analyzer` launcher on `PATH` is not enough: `rustup component list --installed` must include `rust-analyzer` for the selected toolchain. `rust-src` helps rust-analyzer navigate into the standard library. If a project pins a toolchain in `rust-toolchain.toml`, run the install command from that project to add the components to its toolchain too.

The config enables rust-analyzer for Rust files. Open a `.rs` file in a Cargo project and run `:LspInfo` to confirm it attached. `Space l f` requests formatting through rust-analyzer and rustfmt. Formatting on save is not enabled.

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

The config enables clangd for both C and C++ files. Open a `.c` or `.cpp` file in a project and run `:LspInfo` to confirm it attached. `Space l f` requests formatting from clangd. Use `:LspClangdSwitchSourceHeader` to switch between a source file and its header when clangd can identify the pair.

## Verify in Neovim

Open a `.py`, `.rs`, `.c`, or `.cpp` file inside a project. Run `:checkhealth vim.lsp` and `:LspInfo` to check server attachment, then try `gd` for definition and `K` for hover. If no server starts, check its executable in the same WSL shell that launches Neovim and inspect `:messages`.

## File and text search

The config uses [fzf](https://github.com/junegunn/fzf) for file selection and [Ag](https://github.com/ggreer/the_silver_searcher) for text search. Install Ag inside WSL with `sudo apt install silversearcher-ag`. The fzf binary can be on `PATH` or in `~/.fzf/bin/fzf`.

| Keys | Action |
| --- | --- |
| `Space f f` (or `,f`) | Fuzzy-find files in the current working directory. |
| `Space f g` | Fuzzy-find Git-tracked files (`:GFiles`). |
| `Space f b` (or `,b`) | Pick an open buffer. |
| `Space s g` (or `,/`) | Enter an Ag text search, then press Enter. |
| `Space s w` | Ag search for the literal whole word under the cursor. |
| `,t` | Search tags. |

`Space` is the leader key. The `Space f` mappings need fzf. `Space s g` and `Space s w` need both fzf and Ag. Without fzf, `,f`, `,b`, and `,t` use Vim's file, buffer, and tag commands. If fzf or Ag is unavailable, `,/` starts `:grep` instead. `:Files` uses fzf's file walker (which skips `.git` and `node_modules` by default). `:GFiles` uses Git's tracked-file list. A shell-level `FZF_DEFAULT_COMMAND` takes precedence over fzf's walker.

In most fzf pickers, `Ctrl-t` opens a result in a new tab, `Ctrl-x` opens a split, and `Ctrl-v` opens a vertical split.

## Git views

Fugitive provides the status view. Diffview provides changes and history panes. Gitsigns marks changed lines in the sign column. Open a file in a Git repository before using current-file history.

| Keys | Action |
| --- | --- |
| `Space g s` | Open Fugitive status (`:Git`). |
| `Space g d` | Open the Diffview changes pane (`:DiffviewOpen`). |
| `Space g h` | Show the current file's history (`:DiffviewFileHistory %`). |
| `[h` / `]h` | Jump to the previous / next changed hunk in a tracked file. |

Use `:DiffviewClose` to leave a diff view. `:DiffviewFileHistory` without `%` shows repository history. See `:help diffview` for actions inside a diff view.

The statusline shows the branch and nonzero `+added ~changed -removed` counts for the current file. It shows no Git section outside a repository.

## Shortcut reference

`Space` is the leader key. These shortcuts use normal mode unless a row says otherwise. Plugin shortcuts require the relevant plugin to load.

### Buffers, files, and windows

| Keys | Action |
| --- | --- |
| `Space w` | Save the current file. |
| `Space b d` / `,c` | Close the current buffer with `:Bdelete`, without closing its window. `,c` uses `:bd` as an abbreviation for `:Bdelete`. |
| `Space b p` / `,z` | Switch to the alternate buffer. |
| `,e` | Start `:e **/*` to open a file under the current directory. |
| `,m` | Run `:make`. |
| `,q` | Close the current window (`:quit`). |
| `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` | Move left / down / up / right between splits, and across tmux panes when configured. |
| `Ctrl-\` | Return to the previous split or tmux pane (vim-tmux-navigator). |
| `[b` / `]b` | Go to the previous / next buffer (vim-unimpaired). |
| `[q` / `]q` | Go to the previous / next quickfix item (vim-unimpaired). |
| `[l` / `]l` | Go to the previous / next location-list item (vim-unimpaired). |
| `[f` / `]f` | Open the previous / next file in the current file's directory (vim-unimpaired). |
| `[n` / `]n` | Jump to the previous / next conflict marker or diff hunk (vim-unimpaired). |

The window shortcuts use vim-tmux-navigator when it loads. Without it, `Ctrl-h/j/k/l` move between Neovim splits. In tmux, navigation does not leave a zoomed pane. Quickfix and location-list windows open after their respective search commands.

### Editing and navigation

| Keys | Action |
| --- | --- |
| `j` / `k` | Move by display line when no count is given. A count moves by file line. |
| `0` / `$` | Move to the first nonblank / last character of the display line. |
| `'` | Jump to an exact mark position, like Vim's backtick command. |
| `<` / `>` (visual) | Decrease / increase indent and keep the selection. |
| `=` (visual) | Reindent and keep the selection. |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments on a line, across a motion, or in the selection (vim-commentary). |
| `gcu` | Uncomment the current and adjacent commented lines (vim-commentary). |
| `ds{char}` / `cs{old}{new}` | Delete or change surrounding quotes, brackets, or tags (vim-surround). For example, `ds"` removes quotes. |
| `ys{motion}{char}` / `yss{char}` / `S` (visual) | Surround a motion, a line, or a selection. For example, `ysiw)` wraps a word in parentheses. |
| `[e` / `]e` | Move the current line up / down (vim-unimpaired). |
| `[<Space>` / `]<Space>` | Add a blank line above / below (vim-unimpaired). |
| `yoh` / `yol` / `yos` | Toggle search highlighting / visible whitespace / spelling (vim-unimpaired). |
| `.` | Repeat supported plugin edits such as surround and commentary operations (vim-repeat). |

Auto-pairs inserts matching brackets and quotes as you type. In insert mode, `Backspace` deletes an empty pair. `Enter` adds an indented line inside an empty pair. Type an opening delimiter, then press `Alt-e` to wrap the next string or bracketed expression. `Alt-n` jumps past the next closing character, and `Alt-p` toggles auto-pairs. Terminal support for Alt keys can vary.

Use `:StripTrailingWhitespaces` to remove trailing whitespace from the current file. The config also does this on write for Python and CoffeeScript files.

### LSP and completion

The LSP shortcuts below apply only in buffers with an attached language server. The config enables basedpyright, rust-analyzer, and clangd.

| Keys | Action |
| --- | --- |
| `gD` / `gd` | Jump to the declaration / definition. |
| `gi` / `gr` | Find implementations / references. |
| `K` | Show hover information. |
| `Space D` | Jump to the type definition. |
| `Space r` / `Space l r` | Rename a symbol. |
| `Space a` / `Space l a` | Show code actions. |
| `Space e` / `Space l d` | Show diagnostics at the cursor. |
| `[d` / `]d` | Jump to the previous / next diagnostic. |
| `Space q` | Put diagnostics in the location list. |
| `Space l f` | Request asynchronous formatting from the language server. |
| `Ctrl-p` / `Ctrl-n` (insert) | Select the previous / next completion item (nvim-cmp). |
| `Enter` / `Tab` (insert) | Confirm the selected completion item, or the first item if none is selected (nvim-cmp). |

Completion uses language-server results and file paths. `Ctrl-x Ctrl-o` requests LSP omni-completion in an attached buffer. Lsp_signature shows function signatures while you type arguments.

`signcolumn=yes` keeps Git and diagnostic markers from shifting the text. `scrolloff=5` leaves context near the cursor. `termguicolors` enables true colors in Windows Terminal. To compare colors without true color, run `:set notermguicolors`. Windows clipboard integration is opt-in. Check `:checkhealth vim.provider` before using `"+y` or `"+p`.

## Color schemes

Gruvbox is the default theme. Neovim saves theme changes in `~/.config/nvim/plugin/last-used-colorscheme.vim` and restores them at startup.

Try `:colorscheme tokyonight-moon` (or `tokyonight-night`, `tokyonight-storm`, or `tokyonight-day`). Other configured themes include `gruvbox`, `apprentice`, `onedark`, and `monokai`. `:Colors` opens a scheme picker when fzf is available. The statusline uses the selected theme's colors.
