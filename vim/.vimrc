"#####################################################
"#####################################################
"
" Vimrc Configurationn
" Version: 0.1
"
" by Koen Hausmans (KH) (koen@hausmans.nl)
"
"#####################################################
"
" Changelog
" =========
" 2016-06-22 KH : Initial version
"
"#####################################################
"#####################################################

" Allow vim to break compatibility with vi
set nocompatible " This must be first, because it changes other options

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
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

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
Plug 'ctrlpvim/ctrlp.vim'

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


" Add plugins to &runtimepath
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Don't allow buffers to exist in the background
set nohidden

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
set t_Co=256
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/

"colorscheme molokai

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" Round indent to multiple of 'shiftwidth'.
set shiftround

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 500 characters
set linebreak
set tw=500

"set ai "Auto indent
"set si "Smart indent

" Wrap lines
set wrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and matching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show search results as we type
set incsearch

" Highlight search results
set hlsearch

" For regular expressions turn magic on
set magic

" Use regex for searches
"nnoremap / /\v
"vnoremap / /\v
"nnoremap ? ?\v
"vnoremap ? ?\v

" Ignore case when searching
set ignorecase

" Don't ignore case if we have a capital letter
set smartcase

" Show matching brackets
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Disable highlight when <leader><cr> or <leader><space> is pressed
map <silent> <leader><cr> :nohlsearch<cr>
map <silent> <leader><space> :nohlsearch<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual settings / VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" List all matches and complete till longest common string
set wildmode=list:longest

" My command line autocomplete is case insensitive. Keep vim consistent with
" that. It's a recent feature to vim, test to make sure it's supported first.
if exists("&wildignorecase")
    set wildignorecase
endif

"Always show current position
set ruler

" The last window will have a status line always
set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Don't show the mode in the last line of the screen, vim-airline takes care of it
"set noshowmode

" Height of the command bar
"set cmdheight=2

" Configure backspace so it acts as it should act
se backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Highlight the current line
set cursorline

" Show line numbers
set number

" Highlight tabs and trailing spaces
set listchars=tab:▸\ ,trail:•

" Make whitespace characters visible
set list

"""
""" Fold settings
"""

" show fold column, fold by markers
set foldcolumn=0            " Don't show the folding gutter/column
set foldmethod=marker       " Fold on {{{ }}}
set foldlevelstart=20       " Open 20 levels of folding when I open a file

" Open folds under the following conditions
set foldopen=block,hor,mark,percent,quickfix,search,tag,undo,jump


"""
""" Splits
"""
set splitbelow " Open new splits below
set splitright " Open new vertical splits to the right

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Escape from Insert/Visual mode by using jk key combination
map! jk <esc>

" Reselect visual block after indent/outdent: http://vimbits.com/bits/20
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Nobody ever uses "Ex" mode, and it's annoying to leave
noremap Q <nop>

"""
""" Trailing whitespace removal
"""
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
function! StripTrailingWhitespaces()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call StripTrailingWhitespaces()
autocmd BufWrite *.coffee :call StripTrailingWhitespaces()

" Trim trailing white space
nmap <silent> <leader>t :call StripTrailingWhitespaces()<CR>

"""
""" Format Options
"""
" Character meaning when present in 'formatoptions'
" ------ ---------------------------------------
" c Auto-wrap comments using textwidth, inserting the current comment leader automatically.
" q Allow formatting of comments with "gq".
" r Automatically insert the current comment leader after hitting <Enter> in Insert mode.
" t Auto-wrap text using textwidth (does not apply to comments)
" n Recognize numbered lists
" 1 Don't break line after one-letter words
" a Automatically format paragraphs
set formatoptions=cqrn1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
"set nobackup
"set nowb
"set noswapfile

" Don't leave .swp files everywhere. Put them in a central place
"set directory=$HOME/.vim/swapdir//
"set backupdir=$HOME/.vim/backupdir//
"if exists('+undodir')
"    set undodir=$HOME/.vim/undodir
"    set undofile
"endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.md,*.markdown set filetype=markdown

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast saving
nmap    <silent> <leader>w :w!<cr>
noremap <silent> <leader>W :w !sudo tee % > /dev/null<cr> " Saves the file with sudo rights

" Quit vim
nmap    <silent> <leader>q :quit<cr>

" Repurpose arrow keys to navigating windows
nnoremap <left> <C-w>h
nnoremap <right> <C-w>l
nnoremap <up> <C-w>k
nnoremap <down> <C-w>j
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Make Y consistent with D
"nnoremap Y y$


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>ss :setlocal spell!<cr>
set spelllang=en_us

" Shortcuts using <leader>
map <leader>sn ]s   " Move to the next misspelled word
map <leader>sp [s   " Move to the previous misspelled word
map <leader>sa zg   " Add word under cursor as a good word
map <leader>s? z=   " Suggest correctly spelled word


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Machine local vim file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(glob("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""
""" CtrlP
"""
let g:ctrlp_working_path_mode = 'rw'
map <leader>j :CtrlP<cr>
"let g:ctrlp_custom_ignore = {
"    \ 'dir':  '\v[\/]\.(git|hg|svn|sass-cache|pip_download_cache|wheel_cache)$',
"    \ 'file': '\v\.(png|jpg|jpeg|gif|DS_Store|pyc)$',
"    \ 'link': '',
"    \ }
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 0
" Wait to update results (This should fix the fact that backspace is so slow)
let g:ctrlp_lazy_update = 1
" Show as many results as our screen will allow
let g:ctrlp_match_window = 'max:1000'

"  let g:ctrlp_abbrev = {
"    \ 'gmode': 'i',
"    \ 'abbrevs': [
"      \ {
"        \ 'pattern': '^shj',
"        \ 'expanded': 'fanmgmt/static/js/workflow',
"        \ 'mode': 'pfrz',
"      \ },
"      \ {
"        \ 'pattern': '^shh',
"        \ 'expanded': 'fanmgmt/templates/workflow/compliance_review/jst',
"        \ 'mode': 'pfrz',
"      \ }
"      \ ]
"    \ }

"""
""" NerdTree
"""
"let g:NERDTreeWinPos = "right"
"let NERDTreeShowHidden = 0
"let g:NERDTreeWinSize = 35
"map <leader>nn :NERDTreeToggle<cr>
"map <leader>nb :NERDTreeFromBookmark
"map <leader>nf :NERDTreeFind<cr>


"""
""" Airline
"""
" Set the airline theme to zenburn
"let g:airline_theme='zenburn'
"let g:airline_theme='molokai'
let g:airline_theme='powerlineish'
" The angle bracket defaults look fugly, don't show them
"let g:airline_left_sep=' '
"let g:airline_right_sep=' '
"let g:airline_powerline_fonts=0
let g:airline_powerline_fonts=1


"""
""" Goyo
"""
"let g:goyo_width = 100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
map <silent> <leader>z :Goyo<cr>

"
"" Syntastic
""set statusline+=%#warningmsg#
""set statusline+=%{SyntasticStatuslineFlag()}
""set statusline+=%*
"
""let g:syntastic_always_populate_loc_list = 1
""let g:syntastic_auto_loc_list = 1
""let g:syntastic_check_on_open = 0
""let g:syntastic_check_on_wq = 0
"
"" Tagbar
"nmap <F8> :TagbarToggle<CR>
