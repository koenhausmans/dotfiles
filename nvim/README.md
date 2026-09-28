# Neovim on WSL

Run Neovim and its external tools inside WSL, even when the terminal is Windows Terminal. Keep language servers on the Linux `PATH` used to start `nvim`, rather than installing their Windows versions.

## Neovim

Use Neovim 0.11 or newer for the built-in LSP configuration in `init.vim`. Check with `nvim --version`. See the [official installation instructions](https://neovim.io/doc/install/) if an Ubuntu package is too old.

## Language servers

These are prerequisites for the Python, Rust, C, C++, and Typst configurations in `init.vim`. Installing a server alone does **not** enable it in Neovim. Use a WSL shell to run the commands below.

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

The config enables basedpyright for Python files. Open a `.py` file in a project and run `:LspInfo` to confirm it attached. Basedpyright provides diagnostics and completion, not code formatting. `,lf` needs a formatting-capable server to format Python.

### Rust: rust-analyzer

With [rustup](https://rustup.rs/) installed inside WSL, add the language server and formatter for your active toolchain:

```sh
rustup component add rust-analyzer rustfmt rust-src
rustup component list --installed
rust-analyzer --version
```

Having a `rust-analyzer` launcher on `PATH` is not enough: `rustup component list --installed` must include `rust-analyzer` for the selected toolchain. `rust-src` helps rust-analyzer navigate into the standard library. If a project pins a toolchain in `rust-toolchain.toml`, run the install command from that project to add the components to its toolchain too.

The config enables rust-analyzer for Rust files. Open a `.rs` file in a Cargo project and run `:LspInfo` to confirm it attached. `,lf` requests formatting through rust-analyzer and rustfmt. Formatting on save is not enabled.

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

The config enables clangd for both C and C++ files. Open a `.c` or `.cpp` file in a project and run `:LspInfo` to confirm it attached. `,lf` requests formatting from clangd. Use `:LspClangdSwitchSourceHeader` to switch between a source file and its header when clangd can identify the pair.

### Typst: Tinymist

Install [Tinymist](https://github.com/Myriad-Dreamin/tinymist/releases) for Linux inside WSL and put its `tinymist` executable on `PATH`. If you have Cargo installed, you can build it from source instead:

```sh
cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist-cli
command -v tinymist
```

Open a `.typ` file and run `:LspInfo` to confirm Tinymist attached. The shared LSP shortcuts work for diagnostics, completion, and navigation; `,lf` formats through Tinymist's built-in formatter. Formatting on save is not enabled. Use `:LspTinymistExportPdf` to export the current document to PDF.

## Verify in Neovim

Open a `.py`, `.rs`, `.c`, `.cpp`, or `.typ` file. Run `:checkhealth vim.lsp` and `:LspInfo` to check server attachment, then try `gd` for definition and `K` for hover. If no server starts, check its executable in the same WSL shell that launches Neovim and inspect `:messages`.

## File and text search

The config uses [fzf](https://github.com/junegunn/fzf) for file selection and [Ag](https://github.com/ggreer/the_silver_searcher) for text search. Install Ag inside WSL with `sudo apt install silversearcher-ag`. The fzf binary can be on `PATH` or in `~/.fzf/bin/fzf`.

| Keys | Action |
| --- | --- |
| `,f` | Fuzzy-find files in the current working directory. |
| `,gf` | Fuzzy-find Git-tracked files (`:GFiles`). |
| `,b` | Pick an open buffer. |
| `,/` | Enter an Ag text search, then press Enter. |
| `,sw` | Ag search for the literal whole word under the cursor. |
| `,t` | Search tags. |

`,` is the leader key. `,f`, `,gf`, and `,b` need fzf. `,sw` needs both fzf and Ag. Without fzf, `,f`, `,b`, and `,t` use Vim's file, buffer, and tag commands. If fzf or Ag is unavailable, `,/` starts `:grep` instead. `:Files` uses fzf's file walker (which skips `.git` and `node_modules` by default). `:GFiles` uses Git's tracked-file list. A shell-level `FZF_DEFAULT_COMMAND` takes precedence over fzf's walker.

In most fzf pickers, `Ctrl-t` opens a result in a new tab, `Ctrl-x` opens a split, and `Ctrl-v` opens a vertical split.

## Git views

Fugitive provides the status view. Diffview provides changes and history panes. Gitsigns marks changed lines in the sign column. Open a file in a Git repository before using current-file history.

| Keys | Action |
| --- | --- |
| `,gs` | Open Fugitive status (`:Git`). |
| `,gd` | Open the Diffview changes pane (`:DiffviewOpen`). |
| `,gc` | Close the current Diffview pane (`:DiffviewClose`). |
| `,gh` | Show the current file's history (`:DiffviewFileHistory %`). |
| `,gb` | Show Git blame for the current file. |
| `,gl` | Show the Git log. |
| `[h` / `]h` | Jump to the previous / next changed hunk in a tracked file. |

`:DiffviewFileHistory` without `%` shows repository history. See `:help diffview` for actions inside a diff view.

The statusline shows the branch and nonzero `+added ~changed -removed` counts for the current file. It shows no Git section outside a repository.

## Shortcut reference

`,` is the leader key. These shortcuts use normal mode unless a row says otherwise. Plugin shortcuts require the relevant plugin to load.

### Buffers, files, and windows

| Keys | Action |
| --- | --- |
| `,w` | Save the current file. |
| `,c` | Close the current buffer with `:Bdelete`, without closing its window. `,c` uses `:bd` as an abbreviation for `:Bdelete`. |
| `,z` | Switch to the alternate buffer. |
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
| `,,` | Repeat the last `f`/`F`/`t`/`T` motion in the reverse direction (`,` is the leader key; `,,` restores the built-in `,` behavior). |
| `j` / `k` | Move by display line when no count is given. A count moves by file line. |
| `0` / `$` | Move to the first nonblank / last character of the display line. |
| `'` | Jump to an exact mark position, like Vim's backtick command. |
| `<` / `>` (visual) | Decrease / increase indent and keep the selection. |
| `=` (visual) | Reindent and keep the selection. |
| `,y{motion}` / `,y` (visual) | Copy a motion or selection to the system clipboard; `,yy` copies the current line. |
| `,p` | Paste from the system clipboard after the cursor. |
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

The LSP shortcuts below apply only in buffers with an attached language server. The config enables basedpyright, rust-analyzer, clangd, and Tinymist.

| Keys | Action |
| --- | --- |
| `gD` / `gd` | Jump to the declaration / definition. |
| `gi` / `gr` | Find implementations / references. |
| `K` | Show hover information. |
| `,lt` | Jump to the type definition. |
| `,lr` | Rename a symbol. |
| `,la` | Show code actions. |
| `,ld` | Show diagnostics at the cursor. |
| `[d` / `]d` | Jump to the previous / next diagnostic. |
| `,lq` | Put diagnostics in the location list. |
| `,lf` | Request asynchronous formatting from the language server. |
| `Ctrl-p` / `Ctrl-n` (insert) | Select the previous / next completion item (nvim-cmp). |
| `Enter` / `Tab` (insert) | Confirm the selected completion item, or the first item if none is selected (nvim-cmp). |

Completion uses language-server results and file paths. `Ctrl-x Ctrl-o` requests LSP omni-completion in an attached buffer. Lsp_signature shows function signatures while you type arguments.

`signcolumn=yes` keeps Git and diagnostic markers from shifting the text. `scrolloff=5` leaves context near the cursor. `termguicolors` enables true colors in Windows Terminal. To compare colors without true color, run `:set notermguicolors`. The clipboard shortcuts use the `+` register; they do not change the default clipboard setting. Windows clipboard integration is opt-in. If `,y` or `,p` fails, check `:checkhealth vim.provider`.

## Color schemes

Neovim saves theme changes in `~/.config/nvim/plugin/last-used-colorscheme.vim` and restores them at startup.

Try `:colorscheme tokyonight-moon` (or `tokyonight-night`, `tokyonight-storm`, or `tokyonight-day`). Other configured themes include `gruvbox`, `apprentice`, `onedark`, and `monokai`. `:Colors` opens a scheme picker when fzf is available. The statusline uses the selected theme's colors.
