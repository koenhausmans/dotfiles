# Set the DOTFILES path
export DOTFILES="$HOME/.dotfiles"

# Path to your oh-my-zsh installation.
export ZSH=/home/koen/.oh-my-zsh

# Change the custom ZSH configuration path
ZSH_CUSTOM=$DOTFILES/zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Don't fill in autocomplete if there is ambiguity
setopt no_auto_menu # Currently clobbered by oh my zsh!

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
#plugins=(git github git-extras dircycle tmux colored-man extract web-search)

###########################################################################
#                           User Configuration                            #
###########################################################################

# Set the PATH environment variable
export PATH="~/bin:$DOTFILES/bin:$PATH"

# Save lots of history
SAVEHIST=1000

# Save it to a file
HISTFILE=~/.history

###########################################################################
#                             Load Oh-My-Zsh                              #
###########################################################################

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

###########################################################################
#                            Source other files                           #
###########################################################################

# Let other namespaces make zsh changes
#source $HOME/.dotfiles/*/.zshrc

# Customize to your needs...
if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi

