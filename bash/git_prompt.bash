# Slightly based on: https://github.com/jcgoble3/gitstuff/blob/master/gitprompt.sh

function _git_prompt() {
    local _rst="\[\e[0m\]"
    local _red="\[\e[31m\]"
    local _green="\[\e[32m\]"
    local _yellow="\[\e[33m\]"

    # -- Finds and outputs the current branch name by parsing the list of
    #    all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and
    #    no output is produced
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [[ "$branch" != "" ]] ; then
        local git_status="$(git status --porcelain 2>/dev/null)"

        ##
        ## Determine the color of the git branch
        ##
        local branch_color="$_green"
        # Check for staged commits
        if [[ -n $(egrep '^[MADRC]' <<<"$git_status") ]]; then
            local branch_color="$_red"
        # Check for unstaged commits
        elif [[ -n $(egrep '^.[MD]' <<<"$git_status") ]]; then
            local branch_color="$_yellow"
        fi

        # Outputs a series of indicators based on the status of the
        # working directory:
        # + changes are staged and ready to commit
        # ! unstaged changes are present
        # ? untracked files are present
        # S changes have been stashed
        # P local commits need to be pushed to the remote
        local flags=''

        [[ -n $(egrep '^[MADRC]' <<<"$git_status") ]] && flags+="+"
        [[ -n $(egrep '^.[MD]' <<<"$git_status") ]] && flags+="!"
        [[ -n $(egrep '^\?\?' <<<"$git_status") ]] && flags+="?"
        [[ -n $(git stash list) ]] && flags+="S"
        [[ -n $(git log --branches --not --remotes) ]] && flags+="P"
        [[ -n $flags ]] && flags="|$flags"  # separate from branch name

        echo "$_rst(${branch_color}$branch$_rst$flags) "
    fi
}

