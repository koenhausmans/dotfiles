function fish_right_prompt --description 'Themed Git branch and status'
    # One status read supplies branch, dirty state, stash, and divergence.
    set -l git_lines (command git status --porcelain=v2 --branch --show-stash 2>/dev/null)
    if test $status -ne 0
        return
    end

    set -l branch ''
    set -l oid ''
    set -l ahead 0
    set -l behind 0
    set -l stash 0
    set -l dirty 0
    for line in $git_lines
        if string match -q '# branch.head *' -- "$line"
            set branch (string replace '# branch.head ' '' -- "$line")
        else if string match -q '# branch.oid *' -- "$line"
            set oid (string replace '# branch.oid ' '' -- "$line")
        else if string match -q '# branch.ab *' -- "$line"
            set -l counts (string split ' ' -- "$line")
            set ahead (string sub -s 2 -- "$counts[3]")
            set behind (string sub -s 2 -- "$counts[4]")
        else if string match -q '# stash *' -- "$line"
            set stash (string replace '# stash ' '' -- "$line")
        else if not string match -q '# *' -- "$line"
            set dirty 1
        end
    end

    set -l detached 0
    if test "$branch" = '(detached)'
        set branch (string sub -s 1 -l 7 -- "$oid")
        set detached 1
    end

    if __dotfiles_prompt_ascii
        if test "$detached" = 1
            printf '[git:detached %s' "$branch"
        else
            printf '[git:%s' "$branch"
        end
    else
        __dotfiles_prompt_palette
        set -l git_color $__dotfiles_prompt_green
        if test $dirty -eq 1
            set git_color $__dotfiles_prompt_yellow
        else if test $ahead -gt 0; or test $behind -gt 0
            set git_color $__dotfiles_prompt_purple
        end

        set_color $git_color
        printf ''
        set_color --bold --background=$git_color $__dotfiles_prompt_base
        if test "$detached" = 1
            printf ' ➦ %s' "$branch"
        else
            printf '  %s' "$branch"
        end
    end

    if test $dirty -eq 1
        printf ' ±'
    end
    if test $ahead -gt 0
        printf ' ↑%s' $ahead
    end
    if test $behind -gt 0
        printf ' ↓%s' $behind
    end
    if test $stash -gt 0
        printf ' S'
    end

    if __dotfiles_prompt_ascii
        printf ']'
    else
        printf ' '
        set_color normal
    end
end
