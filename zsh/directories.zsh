##
## Directories
##

# Automatically navigate into directory if an invalid command is given and the command is the name of a directory
setopt auto_cd

# Make cd push the old directory onto the directory stack
setopt auto_pushd

# Don't push duplicate folders onto the directory stack
setopt pushd_ignore_dups

# Exchange the meanings of + and - when used with a number to specify a directory in the stack
setopt pushdminus

# Ls colors
autoload -U colors && colors
#export LSCOLORS="Gxfxcxdxbxegedabagacad"
alias ls='ls --color=tty'

# Aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias d='dirs -v | head -10'

# List directory contents
alias lsa='ls -lah'
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lAh'

