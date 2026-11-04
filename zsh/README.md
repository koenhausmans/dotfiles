# Zsh configuration

`install.sh` links the Zsh configuration and manages plugins under
`~/.local/share/zsh-plugins`. It also automatically installs
[zoxide](../zoxide/README.md), including a one-time import of existing `z.sh`
history. Zoxide initializes after `compinit` and fzf for completion support.
Existing plugin checkouts are updated only when they are clean Git roots with
the expected `origin` and an `origin`-tracking branch; updates use fast-forward-only pulls.
Keep custom checkouts outside these managed paths. If validation or updating
fails, the installer leaves the checkout in place and stops.

The prompt shows the current directory, command status, and Git branch/state.
It uses an ASCII form for `TERM=dumb`, Linux virtual consoles, or when
`prompt_ascii=1` is set in `~/.zshrc.local`. Prompt Git reads skip optional
index locks.
