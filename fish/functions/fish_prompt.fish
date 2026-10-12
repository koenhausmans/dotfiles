function fish_prompt --description 'Themed path and previous command status'
    set -l exit_code $status
    if __dotfiles_prompt_ascii
        if set -q SSH_CONNECTION
            printf '%s@%s ' "$USER" (prompt_hostname)
        end
        printf '%s' (prompt_pwd)
        if test $exit_code -ne 0
            printf ' [exit:%s]' $exit_code
        end
        if fish_is_root_user
            printf ' # '
        else
            printf ' > '
        end
        return
    end

    __dotfiles_prompt_palette
    if test $exit_code -ne 0; or fish_is_root_user
        set_color --background=$__dotfiles_prompt_base
        printf ' '
        if test $exit_code -ne 0
            set_color --background=$__dotfiles_prompt_base $__dotfiles_prompt_red
            printf '✘'
        end
        if fish_is_root_user
            set_color --background=$__dotfiles_prompt_base $__dotfiles_prompt_yellow
            printf '⚡'
        end
        printf ' '
        set_color --background=$__dotfiles_prompt_path $__dotfiles_prompt_base
        printf ''
    end

    set_color --bold --background=$__dotfiles_prompt_path $__dotfiles_prompt_base
    if set -q SSH_CONNECTION
        printf ' %s@%s' "$USER" (prompt_hostname)
    end
    printf ' %s ' (prompt_pwd)

    set_color normal
    set_color $__dotfiles_prompt_path
    printf ' '
    set_color normal
end
