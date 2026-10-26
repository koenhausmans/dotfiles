# Keep environment setup available to non-interactive fish commands, too.
set -gx VISUAL vim
set -gx EDITOR $VISUAL

# Find the repository through this file's symlink, so the repository can live anywhere.
set -l dotfiles (path dirname (path dirname (path resolve (status filename))))

# --path changes this shell's PATH without persisting fish_user_paths.
fish_add_path --path $HOME/bin $dotfiles/bin $HOME/.local/bin

if type -q fnm
    fnm env --use-on-cd --version-file-strategy=recursive --shell fish | source
end

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
    abbr -a gpush 'git push'
    abbr -a gpull 'git pull --rebase'
    abbr -a gs 'git status -sb'
    abbr -a l 'ls -lh'
    abbr -a la 'ls -lAh'
    abbr -a ll 'ls -lh'
    abbr -a lsa 'ls -lah'
    abbr -a week 'date +%V'

    if type -q fzf
        # fzf ignores --tmux outside tmux; its Vim plugin drops it when fzf opens in a Vim window.
        set -gx FZF_DEFAULT_OPTS "--tmux bottom,40%"
        if not set -q FZF_CTRL_T_OPTS
            if type -q bat; or type -q batcat
                set -gx FZF_CTRL_T_OPTS "--preview 'fzf-file-preview {}'"
            end
        end
        fzf --fish | source
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
