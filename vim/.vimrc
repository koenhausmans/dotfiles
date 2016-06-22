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

" Load the NERDTree plugin
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Load the vim-tmux-navigator plugin. It will allow keyboard shortcuts within
" vim to be used
Plug 'christoomey/vim-tmux-navigator'

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

" No welcome screen
set shortmess += I

" Disable .swp warning
set shortmess += A

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
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Ignore case when searching
set ignorecase

" Don't ignore case if we have a capital letter
set smartcase

" Show matching brackets
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Disable highlight when <leader><cr> or <leader><space> is pressed
map <silent> <leader><cr> :noh<cr>
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
set so=7

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

"set laststatus=2            " The last window will have a status line always
"set noshowmode              " Don't show the mode in the last line of the screen, vim-airline takes care of it


" Height of the command bar
"set cmdheight=2

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
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

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
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
nmap <silent> <Leader>t :call StripTrailingWhitespaces()<CR>

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
" => Custom mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast saving
nmap <leader>w :w!<cr>
noremap <Leader>W :w !sudo tee % > /dev/null

cmap w



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>ss :setlocal spell!<cr>
set spelllang=en_us

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" CTRL-P
"let g:ctrlp_working_path_mode = 0
"
"let g:ctrlp_map = '<c-f>'
"map <leader>j :CtrlP<cr>
"map <c-b> :CtrlPBuffer<cr>
"
"let g:ctrlp_max_height = 18
"
"" NERDTree
"let g:NERDTreeWinPos = "right"
"let NERDTreeShowHidden = 0
"let g:NERDTreeWinSize = 35
"map <leader>nn :NERDTreeToggle<cr>
"map <leader>nb :NERDTreeFromBookmark
"map <leader>nf :NERDTreeFind<cr>
"
"" Goyo
"" let g:goyo_width = 100
"let g:goyo_margin_top = 2
"let g:goyo_margin_bottom = 2
"map <silent> <leader>z :Goyo<cr>
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
