# Enable emacs mode
# Use <C-x><C-v> to access vim mode while using emacs mode
bindkey -e

# Use <C-x><C-e> for editing command line in vim
# Also possible to use v in vi-mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd v edit-command-line

# Enable going into vi-mode using <C-[>
bindkey -M emacs '^[' vi-cmd-mode

# Enable history expansion using the <space> key
bindkey -M emacs ' ' magic-space
bindkey -M viins ' ' magic-space

# Reduce the key timeout in zsh to 100ms
export KEYTIMEOUT=1
