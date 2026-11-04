# Bash configuration

`install.sh` links the Bash configuration and automatically installs
[zoxide](../zoxide/README.md), including a one-time import of existing `z.sh`
history. This also applies to the server profile.

The interactive prompt shows the current directory, last command status, and
Git branch/state. Its `PROMPT_COMMAND` hook is prepended while existing hooks
are preserved; the zoxide directory tracker runs after it.
