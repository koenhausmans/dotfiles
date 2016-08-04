"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""
""" FZF Integration
"""
nnoremap <c-p> :FZF -m<cr>

fun! s:fzf_root()
    let path = finddir(".git", expand("%:p:h").";")
    return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
endfun

nnoremap <silent> <leader>ff :exe 'Files ' . <SID>fzf_root()<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>bb :Buffers<CR>
nnoremap <silent> <leader>ll :Lines<CR>
nnoremap <silent> <Leader>lb :BLines<CR>
nnoremap <silent> <leader>tt :Tags<CR>
nnoremap <silent> <leader>bt :BTags<CR>
nnoremap <silent> <leader>mm :Marks<CR>
nnoremap <silent> <leader>ch :History:<CR>

"""
""" NerdTree
"""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 35
map <leader>nn :NERDTreeToggle<cr>
"map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

" Automatically close NERDTree if it is the only window remaining
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"""
""" Airline
"""
"set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
"set rtp+=~/.dotfiles/powerline/powerline/powerline/bindings/vim/

" Fix the colorscheme as soon as the plugins have been installed by plug.vim (prevents warning at first startup)
try
    colorscheme gruvbox
    set background=dark
catch /^Vim\%((\a\+)\)\=:E185/
endtry

" Set the airline theme to zenburn
"let g:airline_theme='zenburn'
"let g:airline_theme='molokai'
let g:airline_theme='gruvbox'
"let g:airline_theme='powerlineish'
" The angle bracket defaults look fugly, don't show them
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#displayed_head_limit=15


"""
""" Goyo
"""
"let g:goyo_width = 100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
map <silent> <leader>z :Goyo<cr>

"""
""" Easytags
"""
set tags=./.tags;
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_auto_highlight = 0
set cpoptions+=d

nmap <silent> <leader>ut :UpdateTags -R ./<CR>

"""
""" Bbye: Buffer Bye for Vim configuration
"""

" Close the current buffer
map <leader>bd :Bdelete<cr>

" Close all the buffers
map <leader>ba :bufdo :Bdelete<cr>



