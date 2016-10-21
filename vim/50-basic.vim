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

" Allow buffers to exist in the background
set hidden

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

"colorscheme molokai
"colorscheme gruvbox
"set background=dark

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

" Fix C indentation and make sure access specifiers are without indentation
set cindent
set cinoptions+=g0
set cinoptions+=N-s

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
map <silent> <leader><cr> :nohlsearch<cr>
map <silent> <leader><space> :nohlsearch<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

"""
""" Buffer shortcuts
"""
" Shortcut to list all buffers and allow quickly to select a buffer
map <leader>b :ls<cr>:b<space>

" Close the current buffer
map <leader>bd :bd<cr>

" Close all the buffers
map <leader>ba :bufdo :bd<cr>

" Move to next or previous buffer
map <leader>bp :bp<cr>
map <leader>bn :bn<cr>

"""
""" Tab shortcuts
"""
" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tl :tabn<cr>
map <leader>th :tabp<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

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
set splitbelow " Open new splits below
set splitright " Open new vertical splits to the right

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
nmap <silent> <leader>t :call StripTrailingWhitespaces()<CR>:retab<CR>

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
nmap <silent> <leader>q :quit<cr>
nmap <silent> <leader>qq :quit!<cr>

" Combined saving and quitting
nmap <silent> <leader>wq :w!<cr>:quit<cr>

" Navigate the vim splits with shortcuts
if empty(glob("~/.vim/plugged/vim-tmux-navigator/"))
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l
endif

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

