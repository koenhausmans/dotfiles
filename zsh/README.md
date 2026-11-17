# Zsh configuration

`install.sh` links the Zsh configuration and manages plugins under
`~/.local/share/zsh-plugins`. Directory navigation uses
[zoxide](../zoxide/README.md) when available; install it through the separate
`zoxide` component offered by the top-level installer. Zoxide initializes after
`compinit` and fzf for completion support.
Existing plugin checkouts are updated only when they are clean Git roots with
the expected `origin` and an `origin`-tracking branch; updates use fast-forward-only pulls.
Keep custom checkouts outside these managed paths. If validation or updating
fails, the installer leaves the checkout in place and stops.

The prompt shows the current directory, command status, and Git branch/state.
It uses an ASCII form for `TERM=dumb`, Linux virtual consoles, or when
`prompt_ascii=1` is set in `~/.zshrc.local`. Prompt Git reads skip optional
index locks.

## Prompt colors

Uncomment one `prompt_palette` in `zshrc` to select a theme. The directory segment
uses the palette's `path` color locally and its brighter `ssh_path` purple when
`SSH_CONNECTION` is set. The username and hostname appear in a separate `purple`
segment over SSH or when `USER` differs from `DEFAULT_USER`. A Powerline separator
divides this segment from the directory; the ASCII prompt uses ` | ` instead.
Git and command-status colors do not change over SSH.
Override palette entries in `~/.zshrc.local` to customize colors. Start a new Zsh
shell after changing the configuration.
