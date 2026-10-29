# Screen

`screen/install.sh` links `screenrc` as `~/.screenrc`. Install GNU Screen first.
Run `screen` to start a session, press `Ctrl-a d` to detach, and use `screen -r`
to reattach. Detaching leaves the session's programs running.

The shortcut reference is in [screenrc](screenrc). Put machine-specific
settings in `~/.screenrc.local`, which is sourced after the shared configuration.
