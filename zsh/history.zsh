##
## History settings
##
HISTSIZE=10000
SAVEHIST=$HISTSIZE
# HISTIGNORE="l:ls:cd:cd -:pwd:exit"
HISTFILE=~/.zsh_history

# Write to the history file immediately, not when the shell exist
setopt inc_append_history

# Save each command's beginning timestamp and the duration
setopt extended_history

# Share history between all sessions
setopt share_history

# Expire a duplicate event first when trimming history
setopt hist_expire_dups_first

# Do not record an event that was just recorded again
setopt hist_ignore_dups

# Remove command lines from the history list when the first character is a space
setopt hist_ignore_space

# Do not execute immediately upon history expansion
setopt hist_verify

# Aliases
alias history='fc -il l'

alias history-stat="fc -l 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
