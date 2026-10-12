function __dotfiles_prompt_palette --description 'Colors for the selected dotfiles prompt theme'
    switch "$fish_prompt_theme"
        case sonokai
            set -g __dotfiles_prompt_base 2c2e34
            set -g __dotfiles_prompt_path 76cce0
            set -g __dotfiles_prompt_green 9ed072
            set -g __dotfiles_prompt_yellow e7c664
            set -g __dotfiles_prompt_red f85e84
            set -g __dotfiles_prompt_purple b39df3
        case gruvbox-material
            set -g __dotfiles_prompt_base 1d2021
            set -g __dotfiles_prompt_path 83a598
            set -g __dotfiles_prompt_green b8bb26
            set -g __dotfiles_prompt_yellow fabd2f
            set -g __dotfiles_prompt_red fb4934
            set -g __dotfiles_prompt_purple d3869b
        case tokyo-night
            set -g __dotfiles_prompt_base 1a1b26
            set -g __dotfiles_prompt_path 7aa2f7
            set -g __dotfiles_prompt_green 9ece6a
            set -g __dotfiles_prompt_yellow e0af68
            set -g __dotfiles_prompt_red f7768e
            set -g __dotfiles_prompt_purple bb9af7
        case '*' # Kanagawa (wave), also the fallback for unknown names.
            set -g __dotfiles_prompt_base 1f1f28
            set -g __dotfiles_prompt_path 7e9cd8
            set -g __dotfiles_prompt_green 76946a
            set -g __dotfiles_prompt_yellow c0a36e
            set -g __dotfiles_prompt_red c34043
            set -g __dotfiles_prompt_purple 957fb8
    end
end
