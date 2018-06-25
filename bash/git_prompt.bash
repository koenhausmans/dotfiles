# Slightly based on: https://github.com/jcgoble3/gitstuff/blob/master/gitprompt.sh

function _git_prompt() {
    local _rst="\[\e[0m\]"
    local _green="\[\e[32m\]"

    # -- Finds and outputs the current branch name by parsing the list of
    #    all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and
    #    no output is produced
    local branch="$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"

    if [[ "$branch" != "" ]] ; then
        # Outputs a series of indicators based on the status of the
        # working directory:
        # + changes are staged and ready to commit
        # ! unstaged changes are present
        # ? untracked files are present
        # S changes have been stashed
        # P local commits need to be pushed to the remote
        # local status="$(git status --porcelain 2>/dev/null)"
        local status_output=''

        local status="$(git status --porcelain 2>/dev/null)"
        [[ -n $(egrep '^[MADRC]' <<<"$status") ]] && status_output="$status_output+"
        [[ -n $(egrep '^.[MD]' <<<"$status") ]] && status_output="$status_output!"
        [[ -n $(egrep '^\?\?' <<<"$status") ]] && status_output="$status_output?"
        [[ -n $(git stash list) ]] && status_output="${status_output}S"
        [[ -n $(git log --branches --not --remotes) ]] && status_output="${status_output}P"
        [[ -n $status_output ]] && status_output="|$status_output"  # separate from branch name

        echo "$_rst($_green$branch$_rst$status_output) "
    fi
}

