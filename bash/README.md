# Bash configuration

`install.sh` links the Bash configuration. Directory navigation uses
[zoxide](../zoxide/README.md) when available; install it through the separate
`zoxide` component offered by the top-level installer in both profiles.

The interactive prompt shows the current directory, last command status, and
Git branch/state. Its `PROMPT_COMMAND` hook is prepended while existing hooks
are preserved; the zoxide directory tracker runs after it.
