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
Plug 'captbaritone/molokai'
Plug 'morhetz/gruvbox'

"""
""" Syntax: Additional syntaxes that can be used
"""
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

" Make tab handle all completions
"Plug 'ervandew/supertab'

" Syntastic: Code linting errors
"Plug 'scrooloose/syntastic', { 'for': ['php', 'python', 'javascript', 'css', 'cpp', 'c'] }

" Load the NERDTree plugin
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }

"""
""" Airline: Fancy statusline
"""
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"""
""" FZF Vim: Fuzzy file openener vim extension
"""
Plug 'junegunn/fzf'
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
""" Goyo: Distraction free writing
"""
Plug 'junegunn/goyo.vim'

"""
""" Commenting: Commenting plugins
"""
" Load the NERDCommenter plugin
Plug 'scrooloose/nerdcommenter'
" Make commenting easier
"Plug 'tpope/vim-commentary'

"""
""" Easytags: Automatically updates the ctags file
"""
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'

"""
""" Bbye: Buffer Bye for Vim - Allows closing buffers without screwing up the window layout
"""
Plug 'moll/vim-bbye'

"""
""" A.vim: Alternate files quickly (switch between header / source)
"""
" TODO: Determine whether this is usefull
Plug 'vim-scripts/a.vim'

"""
""" vim-multiple-cursors: Multiple selections for vim
"""
" TODO: Determine whether this is usefull
Plug 'terryma/vim-multiple-cursors'

call plug#end()

