echo "10-plugins.vim"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Manager (vim-plug)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
" Make sure you use single quotes

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

" Make % match xml tags
"Plug 'edsono/vim-matchit', { 'for': ['html', 'xml'] }

" Make tab handle all completions
"Plug 'ervandew/supertab'

" Syntastic: Code linting errors
"Plug 'scrooloose/syntastic', { 'for': ['php', 'python', 'javascript', 'css', 'cpp', 'c'] }

" Load the NERDTree plugin
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }

" Change brackets and quotes
"Plug 'tpope/vim-surround'
" Make vim-surround repeatable with .
"Plug 'tpope/vim-repeat'

"""
""" Airline: Fancy statusline
"""
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"""
""" CtrlP: Fuzzy file openener
"""
"Plug 'ctrlpvim/ctrlp.vim'

"""
""" FZF Vim: Fuzzy file openener vim extension
"""
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
""" Tagbar: Shows a list of tags that are available
"""
", { 'on':  ['TagbarToggle'] }
"Plug 'majutsushi/tagbar'


" Add plugins to &runtimepath
call plug#end()
