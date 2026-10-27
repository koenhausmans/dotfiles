# Fish configuration

The interactive prompt shows the current directory, command status, and Git
branch/state. It uses an ASCII form for `TERM=linux` or `TERM=dumb`, or when
`fish_prompt_ascii=1` is set in `~/.config/fish/config.local.fish` (or the
equivalent path under `$XDG_CONFIG_HOME`). Prompt Git reads skip optional index
locks.

Set `fish_prompt_theme` to `kanagawa`, `sonokai`, `gruvbox-material`, or
`tokyo-night` in that local file to select a palette. See
[`config.local.fish.template`](config.local.fish.template) for local settings.
