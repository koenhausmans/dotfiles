function __dotfiles_prompt_ascii --description 'Use a plain prompt without special glyphs'
    if contains -- "$TERM" linux dumb
        return 0
    end
    if set -q fish_prompt_ascii; and test "$fish_prompt_ascii" = 1
        return 0
    end
    return 1
end
