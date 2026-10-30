# Vim configuration

## Setup

`./install.sh` links the full `vimrc`. `./install.sh server` (or
`DOTFILES_PROFILE=server vim/install.sh`) links `vimrc.minimal` instead and
updates the apprentice colorscheme. The existing colorscheme stays active if
the download fails.

On first start, the full configuration attempts to download vim-plug. Run
`:PlugInstall`, wait for it to finish, and restart Vim. If vim-plug cannot be
downloaded or plugins are missing, Vim reports the failed path or plugin names
and keeps the minimal bindings active; retry the displayed recovery steps.

## Shared shortcuts

The leader key is `,`. These bindings work in both configurations and use normal
mode unless marked otherwise.

| Keys | Action |
| --- | --- |
| `,w` | Save the file. |
| `,q` | Close the window. |
| `,c` | Delete the buffer; full Vim with plugins preserves the window layout. |
| `,b` | Select a buffer. |
| `,f` | Find a file. |
| `,t` | Search tags. |
| `,e` | Start `:e **/*` to open a file under the current directory. |
| `,m` | Run `:make`. |
| `,z` | Switch to the alternate buffer. |
| `,/` | Start `:grep`, or `:Rg` with full Vim, fzf, and ripgrep. |
| `,,` | Repeat the last character-search motion backward. |
| `,y{motion}` / `,y` (visual) | Copy to the system clipboard; `,yy` copies a line. |
| `,p` | Paste from the system clipboard. |
| `j` / `k` | Move by display line without a count, or file line with a count. |
| `0` / `$` | Move to the first nonblank / last character of the display line. |
| `<` / `>` / `=` (visual) | Change indentation or reindent, then keep the selection. |
| `Ctrl-h/j/k/l` | Move between splits; full Vim also integrates with tmux. |
| `K` / `K` (visual) | Search the word / selection using `:grep` and open quickfix. |

Clipboard bindings are defined only when Vim has `+clipboard` support. They use
the `+` register without changing the default clipboard setting; a working
clipboard connection is still required. Movement remaps also apply in visual
and operator-pending modes.

## Full configuration

These shortcuts require the installed plugins. With fzf available, `,f`, `,b`,
and `,t` open pickers; otherwise they use Vim's file, buffer, and tag commands.
File pickers prefer `fd`, then Ubuntu's `fdfind`, then `rg --files`, then fzf's
default file search.

| Keys | Action |
| --- | --- |
| `,gf` | Find a Git-tracked file (requires fzf). |
| `,sw` | Search for the word under the cursor (requires fzf and ripgrep). |
| `Ctrl-t` / `Ctrl-x` / `Ctrl-v` (fzf picker) | Open in a tab / split / vertical split. |
| `,gs` | Open Fugitive status. |
| `,gd` | Open a diff split for the current file. |
| `,gc` | Close other diff windows in the tab and leave diff mode. |
| `,gh` | Show Git history for the current file. |
| `,gb` | Show Git blame. |
| `,gl` | Show the Git log. |
| `Ctrl-\` | Return to the previous split or tmux pane. |
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments. |
| `gcu` | Uncomment the current and adjacent commented lines. |
| `ys{motion}{char}` / `yss{char}` / `S{char}` (visual) | Add surrounding characters or tags. |
| `ds{char}` / `cs{old}{new}` | Delete / change surrounding characters or tags. |
| `Ctrl-g s` / `Ctrl-g S` (insert) | Insert surrounding characters inline / on new lines. |
| `[b` / `]b` | Previous / next buffer (vim-unimpaired). |
| `[q` / `]q`, `[l` / `]l` | Previous / next quickfix or location-list item. |
| `[e` / `]e` | Move the current line up / down. |
| `[Space` / `]Space` | Add a blank line above / below. |
| `yoh` / `yol` / `yos` | Toggle search highlighting / visible whitespace / spelling. |
| `.` | Repeat supported comment and surround operations. |

Surround keeps its default mappings, including the `ySs` alias, except insert-mode
`Ctrl-s`. The custom `*` surround adds `/* … */` comments. Auto-pairs inserts
matching brackets and quotes; insert-mode `Alt-e` / `Alt-n` / `Alt-p` wraps the next
expression / skips a closing character / toggles pairing.

## Commands

Use `:StripTrailingWhitespaces` to remove trailing whitespace without changing
indentation. Python and CoffeeScript files also lose trailing whitespace on write.
Spelling is enabled for Markdown, Git commit messages, and todo files.

Use `:SudoWrite` (or `:w!!`) to save the whole current file with root permissions.
It requires a named file buffer and marks it saved only after a successful write.
It overwrites the file directly, without a backup or atomic replacement.

In command-line mode, `%%` inserts the current file's directory. With full plugins,
`:bd` expands to `:Bdelete` to preserve the window layout.
