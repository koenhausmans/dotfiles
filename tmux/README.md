# tmux configuration

The prefix is `Ctrl-a`, not `Ctrl-b`. This reference covers custom behavior only.
Machine-specific overrides go in `~/.tmux.conf.local`.

## Status and colors

The bottom-left status shows the short hostname followed by the session name,
with a Powerline separator and no dot between them. The active Kanagawa theme
uses a lighter gray background for the session block.

Uncomment exactly one theme block in `tmux.conf` to select a theme. Each block
defines `@accent-local` (blue, aqua, or cyan) and `@accent-remote` (purple).
When `SSH_CONNECTION` is set, tmux selects the remote accent for active windows,
active-pane borders, messages, the prefix indicator, and the clock. Warning,
error, and neutral colors stay unchanged. This detects tmux running on the
server after SSH, not SSH running inside a local tmux pane.

Set `@accent` in `~/.tmux.conf.local` to override the selected accent. If you also
use clock mode, set `clock-mode-colour` there to the same color. Reload with
`tmux source-file ~/.tmux.conf`; local overrides are applied last.

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
| `Ctrl-a =` | Evenly size the current pane and adjacent panes without rearranging splits. |
| `Ctrl-h/j/k/l` (no prefix) | Navigate left / down / up / right between panes or Vim/Neovim splits. |
| `Ctrl-a Ctrl-h/j/k/l` | Forward navigation left / down / up / right to nested tmux. |
| `Alt-h/j/k/l` (no prefix) | Resize the pane by 3 cells, or pass through to Neovim splits. |
| `Alt-Shift-h/j/k/l` (no prefix) | Resize the pane by 6 cells, or pass through to Neovim splits. |
| `Ctrl-\` (no prefix) | Return to the previous pane or Vim/Neovim split. |

New splits start in the current pane's directory. Resize bindings repeat while
the repeat timer is active, without pressing the prefix again. Navigation keys
are passed through to Vim, Neovim, and fzf; the supplied editor configurations
integrate split and tmux navigation.

For inner-pane navigation, use `Ctrl-a Ctrl-h/j/k/l` instead of sending
`Ctrl-a Ctrl-a` first. The inner tmux must have the unprefixed navigation bindings.
Use [suspend mode](#suspend) to pass keys through for repeated inner navigation.

In nested layouts, `Ctrl-a =` balances adjacent panes, not every split in the window.

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
