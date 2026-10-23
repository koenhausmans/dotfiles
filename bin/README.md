# Tools in `bin/`

Run these scripts from the repository with `./bin/<name>`, or add this directory to your `PATH`.

## System tools

### `cpu_scaling_governer`

Shows the current CPU scaling governor and a menu of governors to select. Run `./bin/cpu_scaling_governer` in a terminal. It needs `cpufreq-info`, `cpufreq-set`, and `sudo`. Your system must support the governor you select. The script uses `sudo cpufreq-set -r -g` to apply your choice.

### `show_battery_status`

Run `./bin/show_battery_status` to show the battery state, percentage, and available time estimates. It needs `upower` and a battery that `upower` reports.

### `show_colors`

Run `./bin/show_colors` to show a table of terminal foreground and background colors. Use an ANSI-compatible terminal.

### `sorted_disk_usage`

Run `./bin/sorted_disk_usage [options] [du options or paths]` to list disk use one level below each path. The script sorts the results by size, smallest first. It uses GNU `du` and `sort`. Without a path, it uses the current directory.

| Option | Effect |
| --- | --- |
| `-s SIZE`, `--size SIZE`, `-s=SIZE`, `--size=SIZE` | Set the unit to KiB, MiB, or GiB. The default is MiB. Use `k`, `kb`, or `kib` for KiB, and equivalent `m` or `g` forms for other units. |
| `-r`, `--root` | Run `du` with `sudo`. |
| `-q`, `--quiet` | Hide error output from `du`. |
| `-h`, `--help` | Show the built-in help. |

For example, `./bin/sorted_disk_usage --size=g ~/Downloads` shows sizes in GiB. Use `--` to stop parsing the script's options and pass the remaining arguments to `du`.

## Git tools

Run these scripts inside a Git repository. The rename scripts change both local refs and refs on `origin`. Check the names and remote before you run them.

### `git-land`

Run `git land` on a feature branch to merge it into the local `main` (or `master`) branch and then delete the feature branch with `git branch -d`. The working tree must be clean. By default the merge uses `--ff-only` and fails if a fast-forward is not possible. Use `--no-ff` to create a merge commit, or `--rebase` to rebase the feature branch onto the target first and then fast-forward. If the rebase or merge fails, the script aborts it, switches back to the feature branch, and exits with an error. The script does not push.

### `git-remove-old-local-branches`

Run `./bin/git-remove-old-local-branches` to fetch with `--prune` and delete local branches whose upstream is marked `[gone]`. The script skips the current branch. Git's normal `-d` check prevents deletion of unmerged branches. Use `-f` or `--force` to delete those branches with `git branch -D` instead. The script does not delete branches on the remote.

### `git-rename-branch`

Run `./bin/git-rename-branch <old-branch> <new-branch>` to switch to a local branch, push it to `origin` under the new name, rename it locally, and delete the old name on `origin`. The old local branch must exist, and the new local branch must not exist. You need permission to push and delete branches on `origin`.

### `git-rename-tag`

Run `./bin/git-rename-tag <old-tag> <new-tag>` to create a new tag from an existing local tag, push the new tag to `origin`, and delete the old tag locally and on `origin`. The old local tag must exist, and the new local tag must not exist. The new tag is lightweight, even if the old tag was annotated. You need permission to push and delete tags on `origin`.
