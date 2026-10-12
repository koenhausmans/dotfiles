# Keep environment setup available to non-interactive fish commands, too.
set -gx DOTFILES $HOME/.dotfiles
set -gx VISUAL vim
set -gx EDITOR $VISUAL

# --path changes this shell's PATH without persisting fish_user_paths.
fish_add_path --path $HOME/bin $DOTFILES/bin $HOME/.local/bin
fish_add_path --path --append $HOME/.fzf/bin

if status is-interactive
    set -g fish_greeting ''

    # Fish provides completion, autosuggestions, and syntax highlighting itself.
    # Abbreviations expand visibly in the command line before execution.
    if not set -q fish_prompt_theme
        set -g fish_prompt_theme kanagawa
    end

    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gc 'git commit'
    abbr -a gca 'git commit -a'
    abbr -a gcam 'git commit -a -m'
    abbr -a gcm 'git commit -m'
    abbr -a gd 'git diff'
    abbr -a gdc 'git diff --cached'
    abbr -a gdt 'git diff-tree --no-commit-id --name-only -r'
    abbr -a gl 'git log --stat'
    abbr -a glo 'git log --color=auto --date=short --pretty=format:"%C(auto,yellow)%h%C(reset) %<(100,trunc)%s %C(auto,green)%ad  %C(auto,blue)<%ae>%C(reset)"'
    abbr -a gpush 'git push'
    abbr -a gpull 'git pull --rebase'
    abbr -a gs 'git status -sb'
    abbr -a l 'ls -lh'
    abbr -a la 'ls -lAh'
    abbr -a ll 'ls -lh'
    abbr -a lsa 'ls -lah'
    abbr -a week 'date +%V'

    if type -q fzf
        set -gx FZF_TMUX 1
        # Use fzf's fish bindings when supported; older versions can skip them.
        fzf --fish 2>/dev/null | source
    end
end

# Local overrides live outside the repository and load after these settings.
set -l fish_config_dir $HOME/.config/fish
if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
    set fish_config_dir $XDG_CONFIG_HOME/fish
end
if test -f "$fish_config_dir/config.local.fish"
    source "$fish_config_dir/config.local.fish"
end
