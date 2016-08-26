Git - Usefull commands:
=======================

Local Changes:
--------------

| Command | Alternative | Description |
| --- | --- | --- |
| `git status --short --branch` | `git status -sb` | Short summary of local changes |
| `git log --stat` | | Shows file statistics with log messages |
| `git log --pretty=oneline` | | Shows the log messages in one line |
| `git log --abbrev-commit` | | Shows only a partial SHA1 hash for the commits |
| `git log --graph` | | Shows a graph of the different branches |
| `git diff` | | Shows the difference for all files |
| `git diff --cached` | | Shows all staged differences |
| `git commit -i` | | Do an interactive commit |

Branches:
---------

| Command | Description |
| --- | --- |
| `git checkout -b <local-branch> <remote>/<branch>` | Checkout `<local-branch>` that tracks upstream branch `<remote>/<branch>` |
| `git checkout --track <remote>/<branch>` | Checkout `<branch>` that tracks upstream branch `<remote>/<branch>` |
| `git checkout -t <remote>/<branch>` | Checkout `<branch>` that tracks upstream branch `<remote>/<branch>` |
| `git checkout <branch>` | Checks out `<branch>` and tracks upstream branch i.f.f. there exists a branch named `<branch>` on one remote |
| `git branch -vv` | Show all branches including the upstream branches |
| `git branch -r` | Show all remote branches |


Remote commands:
----------------

| Command | Description |
| --- | --- |
| `git pull --rebase` | Pull upstream branch and rebase to the new version |
| `git push` | Push the local changes to the upstream branch |
| `git push -u <remote> <branch>` | Push a local branch to a remote and set up tracking information |
| `git fetch` | Receive all changes from a remote location |
| `git rebase <branch>` | Rebases <branch> into the current branch |
| `git branch -dr <remote/branch>` | Deletes a branch on the remote |
| `git push <remote> --delete <branch>` | Deletes the remote branch `<remote>/<branch>` | 
