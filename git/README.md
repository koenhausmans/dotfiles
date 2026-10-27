# Git configuration

`git/install.sh` installs `git/gitconfig` as `~/.gitconfig`.

## Aliases

| Alias | Command |
| --- | --- |
| `git lg` | Graph log with abbreviated commit, refs, subject, age, and author. |
| `git changes` | Short status with branch information. |
| `git ctags` | Regenerate tags using the repository's `ctags` hook. |
| `git dt` | List files changed by a commit. |
| `git pl` | Pull with rebase. |
| `git ps` | Push. |

## Defaults

- Ignores patterns from `git/gitignore_global`.
- Caches credentials for one hour.
- Uses Vimdiff for diffs and merges, with `diff3` conflict markers.
- Enables Git's command autocorrection and simple push behavior.
- Uses the repository's Git template directory to install hooks when a
  repository is initialized.

## Ctags

The template's `post-commit`, `post-merge`, `post-checkout`, and `post-rewrite`
hooks regenerate tags in the background with Universal Ctags. Tags are written
to `.git/tags`, or `.tags` in a linked worktree. Run `git ctags` to regenerate
them manually. Existing repositories need `git init` once to receive the
template hooks. Vim and Neovim search these tag files automatically.

## Local settings

`~/.gitconfig.local` is included for machine-specific settings.
