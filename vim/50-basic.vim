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

" Map the semicolon to a colon, s.t. shift is not required
noremap ; :

" Allow buffers to exist in the background
set hidden

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
set t_Co=256

" Fix the colorscheme as soon as the plugins have been installed by plug.vim (prevents warning at first startup)
try
    colorscheme gruvbox
    set background=dark
catch /^Vim\%((\a\+)\)\=:E185/
endtry

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

" Automatically indent when opening a new line, smartindent might indent
" one extra level dependent on syntax
set autoindent
set smartindent

" Linebreak on 500 characters
set linebreak
set tw=500

" Wrap lines
set wrap

" Change the timeout timings when matching to mappings / keys
set timeoutlen=400
set ttimeoutlen=10

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and matching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show search results as we type
set incsearch

" Highlight search results
set hlsearch

" For regular expressions turn magic on
set magic

" Ignore case when searching
set ignorecase

" Don't ignore case if we have a capital letter
set smartcase

" Show matching brackets
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Disable highlight when <leader><cr> or <leader><space> is pressed
nnoremap <silent> <leader><cr> :nohlsearch<cr>
nnoremap <silent> <leader><space> :nohlsearch<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
noremap <silent> j gj
noremap <silent> k gk
noremap <silent> $ g$
" Remap VIM 0 to first non-blank character
noremap <silent> 0 g^

"""
""" Buffer shortcuts
"""
" Shortcut to list all buffers and allow quickly to select a buffer
nnoremap <leader>b :ls<cr>:b<space>

" Close the current buffer
nnoremap <leader>c :bd<cr>

" Close all the buffers
" map <leader>ba :bufdo :bd<cr>

"""
""" Tab shortcuts
"""
" Useful mappings for managing tabs
" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tl :tabn<cr>
" map <leader>th :tabp<cr>
" map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
" map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Automatically open cwindow or lwindow on :grep / :make / :lvimgrep / etc.
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l*    lwindow


" Remember info about open buffers on close
set viminfo^=%

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual settings / VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=3

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
" Open new splits below
set splitbelow
" Open new vertical splits to the right
set splitright

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Escape from Insert/Visual mode by using jk key combination
inoremap jk <esc>
inoremap kj <esc>

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

" Trim trailing white space
nmap <silent> <leader>T :call StripTrailingWhitespaces()<CR>:retab<CR>

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
" => Custom mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast saving
nnoremap <silent> <leader>w :w!<cr>

" Fast saving the file with sudo rights
nnoremap <silent> <leader>W :w !sudo tee % > /dev/null<cr>

" Quit vim
nnoremap <silent> <leader>q :quit<cr>
nnoremap <silent> <leader>Q :quit!<cr>

" Combined saving and quitting
nnoremap <silent> <leader>wq :w!<cr>:quit<cr>
nnoremap <silent> <leader>Wq :w !sudo tee % > /dev/null<cr>:quit<cr>

" " Faster Quickfix mappings
" nmap <silent> <leader>n :cnext<cr>
" nmap <silent> <leader>p :cprevious<cr>

" Navigate the vim splits with shortcuts
if empty(glob("~/.vim/plugged/vim-tmux-navigator/"))
    nnoremap <c-j> <c-w>j
    nnoremap <c-k> <c-w>k
    nnoremap <c-h> <c-w>h
    nnoremap <c-l> <c-w>l
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Machine local vim file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(glob("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
endif

