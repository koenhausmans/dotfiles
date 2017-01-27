zmodload -i zsh/complist

WORDCHARS=''

# Disable start/stop characters
unsetopt flowcontrol

# The cursor stays and completion is done from both ends
setopt complete_in_word

# Use menu completion after the second consecutive request for completion
setopt auto_menu

# Move the cursor to the end of the word when a full completion is inserted
setopt always_to_end

# On an ambiguous completion, insert the first match immediately
unsetopt menu_complete

zstyle ':completion:*:*:*:*:*' menu select

# Allow for case insensitive and hyphen insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# ... unless we really want to.
zstyle '*' single-ignored show

