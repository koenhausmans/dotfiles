# Zoxide

Select the `zoxide` component in the top-level installer to run a one-time
`z.sh` history import. Bash and Zsh share the navigation database, but their
standalone installers do not cover this import. Standalone run:
`bash zoxide/install.sh` from the repository root.

The zoxide binary is managed by [mise](../mise/README.md).

## Usage

```sh
z Downloads                  # jump to the best match
zi Downloads                 # choose interactively (requires fzf)
zoxide query Downloads       # print the best path without changing directories
zoxide query --list Downloads # list matching paths
```

`z -e` and other `z.sh` flags are not retained. Use `zoxide query` for path
lookups. Matching and ranking can differ from `z.sh`.

## History and local settings

Installation imports nonempty `~/.z` history once, merging into any existing
zoxide database. The old history and `~/.local/share/z` checkout are left
untouched but are no longer loaded or updated by these dotfiles.

To import `z.sh` history manually:

```sh
zoxide import z
```

If the zoxide database already contains entries, use `zoxide import --merge z`
instead. Skip manual import if the installer already imported your history;
repeated merges add the same ranks again.

The database defaults to `${XDG_DATA_HOME:-~/.local/share}/zoxide`.
`.dotfiles-z-imported` in that directory records a successful import; reruns
do not import the same history again. Failed imports stop setup and can be retried.

For custom locations, export `_Z_DATA` (old history) or `_ZO_DATA_DIR` (new
database) before running the installer. Keep `_ZO_DATA_DIR` consistent in your
shell environment. Export zoxide settings such as `_ZO_EXCLUDE_DIRS` in
`~/.bashrc.local` or `~/.zshrc.local`; these load before zoxide initialization.
