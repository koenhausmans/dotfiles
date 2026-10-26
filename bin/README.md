# Tools in `bin/`

Run these scripts from the repository with `./bin/<name>`, or add this directory to your `PATH`.

## System tools

### `fzf-file-preview`

Used by the shells' fzf Ctrl-T picker. Run `./bin/fzf-file-preview PATH` to preview
the first 300 lines with `bat` or `batcat`, or plain text when neither is present.
Directories show up to 100 lines of a listing. Special files are not read.

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

Run these scripts inside a Git repository. Scripts that work against a target branch use the first local branch of `develop`, `main` and `master`. Run `git config dotfiles.target <branch>` in a repository to choose another target. The rename scripts change both local refs and refs on `origin`. Check the names and remote before you run them.

### `git-fixup`

Run `git fixup [commit]` on a feature branch to fold the staged changes into an earlier commit on that branch. Without a commit, the script shows the branch's commits in `fzf` so you can pick one. It runs `git commit --fixup` and then `git rebase -i --autosquash --autostash` without opening an editor. Unstaged changes are kept. The commit must be on the branch and not on the target branch. If the rebase fails, the script aborts it and keeps the `fixup!` commit.

### `git-land`

Run `git land` on a feature branch to merge it into the local target branch and then delete the feature branch with `git branch -d`. The working tree must be clean. By default the merge uses `--ff-only` and fails if a fast-forward is not possible. Use `--no-ff` to create a merge commit, or `--rebase` to rebase the feature branch onto the target first and then fast-forward. If the rebase or merge fails, the script aborts it, switches back to the feature branch, and exits with an error. The script does not push.

### `git-recent`

Run `git recent [-n count]` to list local branches by last commit date, newest first, with the commit age and subject. The default count is 20. If `fzf` is installed and the output is a terminal, you pick a branch and the script switches to it.

### `git-remove-old-local-branches`

Run `./bin/git-remove-old-local-branches` to fetch with `--prune` and delete local branches whose upstream is marked `[gone]`. The script skips the current branch. Git's normal `-d` check prevents deletion of unmerged branches. Use `-f` or `--force` to delete those branches with `git branch -D` instead. The script does not delete branches on the remote.

### `git-rename-branch`

Run `./bin/git-rename-branch <old-branch> <new-branch>` to switch to a local branch, push it to `origin` under the new name, rename it locally, and delete the old name on `origin`. The old local branch must exist, and the new local branch must not exist. You need permission to push and delete branches on `origin`.

### `git-rename-tag`

Run `./bin/git-rename-tag <old-tag> <new-tag>` to create a new tag from an existing local tag, push the new tag to `origin`, and delete the old tag locally and on `origin`. The old local tag must exist, and the new local tag must not exist. The new tag is lightweight, even if the old tag was annotated. You need permission to push and delete tags on `origin`.

### `git-start`

Run `git start <branch>` to run `git-sync` and create a new branch from the local target branch. The working tree must be clean. If the sync fails, for example when you are offline, the script prints a warning and branches from the local target.

### `git-sync`

Run `git sync` to fetch `origin` and fast-forward the local target branch. On a feature branch, the script updates the target without checking it out. Use `--rebase` on a feature branch to also rebase it onto the target. The command fails if the local target has diverged from `origin`. If the rebase fails, the script aborts it.

### `git-trail`

Run `git trail` to show a one-line log with the upstream and fork point of the current branch. The first line shows the branch, its upstream, the ahead and behind counts, and the commit where the branch forked from the target. In the log, `↑` marks commits that are not pushed and `◆` marks the fork point. Each line is cut to the terminal width: long ref lists and subjects end in `…`. Without arguments on a feature branch, the log stops 3 commits below the fork point. Use `-c count` to change that number, `-b branch` to compare with another base, and `-g` to show the graph. Other arguments go to `git log`, for example `git trail -20` or `git trail --all`.

### `git-undo`

Run `git undo` to remove the last commit with `git reset --soft HEAD~1`. The changes stay staged. The script refuses merge commits and root commits. It warns if the commit is already on the upstream branch. It prints the commit hash so you can restore it.

### `git-wip` and `git-unwip`

Run `git wip` to stage all changes, including untracked files, and commit them as `WIP` without running hooks. On `develop`, `main`, `master` or the target branch the script stops unless you add `--force`. Run `git unwip` to remove that commit with a mixed reset, so the changes become unstaged again. `git unwip` only acts if the HEAD commit message is exactly `WIP`.
