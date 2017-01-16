# Enable emacs mode
# Use <C-x><C-v> to access vim mode while using emacs mode
bindkey -e

# Use <C-x><C-e> for editing command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd v edit-command-line

bindkey -M emacs '^[' vi-cmd-mode

bindkey -M emacs ' ' magic-space
bindkey -M viins ' ' magic-space
