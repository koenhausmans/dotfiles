# Zsh configuration

`install.sh` links the Zsh configuration and manages plugins under
`~/.local/share/zsh-plugins`, plus `z` at `~/.local/share/z`. Existing
checkouts are updated only when they are clean Git roots with the expected
`origin` and an `origin`-tracking branch; updates use fast-forward-only pulls.
Keep custom checkouts outside these managed paths. If validation or updating
fails, the installer leaves the checkout in place and stops.
