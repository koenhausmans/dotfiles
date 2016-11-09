"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Grep and Vimgrep configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m

    command! -nargs=+ -complete=file_in_path -bar Ag silent grep! <args>|cwindow|redraw!
elseif executable('ack')
    set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
    set grepformat=%f:%l:%c:%m

    command! -nargs=+ -complete=file_in_path -bar Ack silent grep! <args>|cwindow|redraw!
endif

nnoremap <silent> K :grep! "\b<c-r><c-w>\b"<cr>:cwindow<cr>

