# tmux configuration

The prefix is `Ctrl-a`, not `Ctrl-b`. This reference covers custom behavior only.
Machine-specific overrides go in `~/.tmux.conf.local`.

## Windows and panes

| Keys | Action |
| --- | --- |
| `Ctrl-a c` | Create a window in the current pane's directory. |
| `Ctrl-a Ctrl-n` / `Ctrl-a Ctrl-p` | Next / previous window. |
| `Ctrl-a a` | Switch to the last window. |
| `Ctrl-a Ctrl-a` | Send `Ctrl-a` to the current pane. |
| `Ctrl-a A` | Select the next pane. |
| `Ctrl-a v` / `Ctrl-a Ctrl-v` / `Ctrl-a \|` | Split into side-by-side panes. |
| `Ctrl-a s` / `Ctrl-a Ctrl-s` / `Ctrl-a -` / `Ctrl-a _` | Split into stacked panes. |
| `Ctrl-a h/j/k/l` | Resize left / down / up / right by 1 cell. |
| `Ctrl-a H/J/K/L` | Resize left / down / up / right by 5 cells. |
| `Ctrl-h/j/k/l` (no prefix) | Navigate left / down / up / right between panes or Vim/Neovim splits. |
| `Ctrl-\` (no prefix) | Return to the previous pane or Vim/Neovim split. |

New splits start in the current pane's directory. Resize bindings repeat while
the repeat timer is active, without pressing the prefix again. Navigation keys
are passed through to Vim, Neovim, and fzf; the supplied editor configurations
integrate split and tmux navigation.

Pane borders use double lines (`║`, `═`) to distinguish them from Neovim's heavy lines.

## Vi-style copy mode

Copy and choice modes use vi keys. In copy mode:

| Keys | Action |
| --- | --- |
| `v` | Begin a selection. |
| `Ctrl-v` | Toggle rectangular selection. |
| `y` | Copy the selection and leave copy mode. |

Mouse support is enabled. Releasing a mouse-drag selection copies it without
clearing the selection or leaving copy mode.

## Clipboard

Copies use OSC 52 to reach the system clipboard when the outer terminal supports it.
The configured `set-clipboard on` also lets applications inside tmux create tmux
paste buffers and request clipboard changes. Use this only with applications you trust.
To allow tmux's own copies but block application clipboard requests, put
`set -s set-clipboard external` in `~/.tmux.conf.local`, then reload.
The outer terminal's clipboard permissions still apply.

## Suspend

`F12` suspends tmux key bindings so keys reach the inner application, such as a
nested or remote tmux. The mode indicator shows ` ---- `. Suspending leaves copy
mode and turns off pane synchronization. Press `F12` again to resume bindings.
