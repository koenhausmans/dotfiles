# Capture one porcelain-v2 status for the prompt. Keep the branch name in a
# variable: embedding it directly in PS1 would evaluate shell substitutions
# from an untrusted Git branch name when Bash renders the prompt.
_git_prompt() {
    __dotfiles_git_branch=''
    __dotfiles_git_color=''
    __dotfiles_git_flags=''

    local status line branch='' oid='' xy staged=0 unstaged=0 untracked=0 stash=0 ahead=0
    local plus minus
    status=$(command git --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null) || return 0

    while IFS= read -r line; do
        case $line in
            '# branch.head '*) branch=${line#'# branch.head '} ;;
            '# branch.oid '*) oid=${line#'# branch.oid '} ;;
            '# branch.ab '*)
                read -r plus minus <<< "${line#'# branch.ab '}"
                ahead=${plus#+}
                ;;
            '# stash '*) stash=${line#'# stash '} ;;
            '1 '*|'2 '*|'u '*)
                xy=${line:2:2}
                [[ ${xy:0:1} != . ]] && staged=1
                [[ ${xy:1:1} != . ]] && unstaged=1
                ;;
            '? '*) untracked=1 ;;
        esac
    done <<< "$status"

    [[ $branch == '(detached)' ]] && branch=${oid:0:7}
    [[ -n $branch ]] || return 0
    __dotfiles_git_branch=$branch

    __dotfiles_git_color='\[\e[32m\]'
    if (( staged )); then
        __dotfiles_git_color='\[\e[31m\]'
        __dotfiles_git_flags+='+'
    elif (( unstaged )); then
        __dotfiles_git_color='\[\e[33m\]'
    fi
    (( unstaged )) && __dotfiles_git_flags+='!'
    (( untracked )) && __dotfiles_git_flags+='?'
    (( stash > 0 )) && __dotfiles_git_flags+='S'
    (( ahead > 0 )) && __dotfiles_git_flags+='P'
    [[ -n $__dotfiles_git_flags ]] && __dotfiles_git_flags="|$__dotfiles_git_flags"
}
