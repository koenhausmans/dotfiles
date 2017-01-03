"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype specific commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWrite *.py :call StripTrailingWhitespaces()
autocmd BufWrite *.coffee :call StripTrailingWhitespaces()

autocmd Filetype c,cpp,cs,java  setlocal commentstring=//\ %s

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.md,*.markdown set filetype=markdown

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Code completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set omnifunc=syntaxcomplete#Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => C++ specific options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix C indentation and make sure access specifiers are without indentation
set cindent

" Do not indent C++ scope declarations (public/private/protected) within classes
set cinoptions+=g0
" Do not indent after a namespace block
set cinoptions+=N-s

