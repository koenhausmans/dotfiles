Git - Usefull commands:
=======================

Local Changes:
--------------

| Command | Alternative | Description |
| --- | --- | --- |
| `git status --short --branch` | `git status -sb` | Short summary of local changes |
| `git log --stat` | | Shows file statistics with log messages |
| `git log --pretty=oneline` | | Shows the log messages in one line |
| `git log --abrev-commit` | | Shows only a partial SHA1 hash for the commits |
| `git log --graph` | | Shows a graph of the different branches |
| `git diff` | | Shows the difference for all files |
| `git diff --cached` | | Shows all staged differences |
| `git commit -i` | | Do an interactive commit |

Branches:
---------

| Command | Alternative | Description |
| --- | --- | --- |
| `git checkout -b test remote-name/test` | | Checkout branch "test" from "remote-name" remote branch (usefull with multiple branches |
| `git checkout --track remote-name/test` | `git checkout test` | Checks out a new branch "test" that tracks the upstream branch "remote-name". The alternative command only works when there is only one branch named "test" on any of the remotes. |
| `git branch -vv` | | Show all branches including the upstream branches |


Remote commands:
----------------

| Command | Description |
| --- | --- |
| `git pull --rebase` | Pull upstream branch and rebase to the new version |
| `git push` | Push the local changes to the upstream branch |
| `git fetch` | Receive all changes from a remote location |
