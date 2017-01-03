""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Manager (vim-plug)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""
""" Auto-install vim-plug
"""
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

"""
""" Colorschemes: Additional colorschemes that can be used
"""
Plug 'morhetz/gruvbox'

"""
""" Syntax: Additional syntaxes that can be used
"""
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

"""
""" Airline: Fancy statusline
"""
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"""
""" FZF Vim: Fuzzy file openener vim extension
"""
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'frozen': 1}
Plug 'junegunn/fzf.vim'

"""
""" Tmux: Loads the vim-tmux-navigator to allow tmux keyboard shortcuts to be used within vim
"""
Plug 'christoomey/vim-tmux-navigator'

"""
""" Git: Plugins for git usage
""'
" Fugitive: Git from within Vim
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"""
""" Bbye: Buffer Bye for Vim - Allows closing buffers without screwing up the window layout
"""
Plug 'moll/vim-bbye', {'on': 'Bdelete'}

"""
""" surround.vim: quoting/parenthesizing made simple
"""
Plug 'tpope/vim-surround'

"""
""" repeat.vim: Enable repeating supported plugin maps with "."
"""
Plug 'tpope/vim-repeat'

"""
""" unimpaired.vim: Pair mapping for vim lists
"""
Plug 'tpope/vim-unimpaired'

"==========================================
"          Programming Plugins
"==========================================

"""
""" Commenting: Commenting plugins
"""
" Make commenting easier
Plug 'tpope/vim-commentary'

"""
""" Auto Pairs: Provides automatic matching brackets / quotes
"""
Plug 'jiangmiao/auto-pairs'

"""
""" Supertab: Make tab handle all completions
"""
Plug 'ervandew/supertab'

"""
""" Syntastic: Code linting errors
"""
Plug 'scrooloose/syntastic', { 'for': ['php', 'python', 'javascript', 'css', 'cpp', 'c'] }

call plug#end()

