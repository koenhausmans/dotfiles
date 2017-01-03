"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""
""" FZF Integration
"""
" {{{
nnoremap <c-p> :FZF -m<cr>

function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! GitRootFiles execute 'Files' s:find_git_root()

nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>g :GitRootFiles<cr>
nnoremap <silent> <leader>G :GitFiles<cr>
nnoremap <silent> <leader>? :History<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>t :Tags<cr>
nnoremap <silent> <leader>m :Marks<cr>
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<cr>
nnoremap <silent> <leader>. :AgIn 

nnoremap <silent> K :call SearchWordWithAg()<cr>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<cr>

function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
endfunction

function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
endfunction
command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)


" }}}

"""
""" Airline
"""
" {{{

let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#displayed_head_limit=15

" }}}

"""
""" Bbye: Buffer Bye for Vim configuration
"""
" {{{

" Close the current buffer
cabbrev bd Bdelete
nnoremap <leader>c :Bdelete<cr>

" }}}

"""
""" vim-surround
"""
" {{{

" Allow the usage of * as a surround character for multiline C-style comments
let g:surround_{char2nr("*")} = "/* \r */"

" }}}

"""
""" Syntastic
"""
" {{{

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_compiler_options = ' -std=c++14'

" }}}


"""
""" Git-Gutter
"""
" {{{

let g:gitgutter_map_keys = 0

" }}}

