""" PLUGIN MANAGER (VIM-PLUG) {{{

let mapleader = ' '
" The fzf binary also works when Neovim is started without an interactive shell.
let s:has_fzf = executable('fzf') || executable(expand('~/.fzf/bin/fzf'))

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()

" Colorschemes: Additional colorschemes that can be used
Plug 'morhetz/gruvbox'
Plug 'romainl/apprentice'
Plug 'joshdick/onedark.vim'
Plug 'tanvirtin/monokai.nvim'
" Plug 'itchyny/lightline.vim'
" Plug 'shinchu/lightline-gruvbox.vim'

" Syntax: Additional syntaxes that can be used
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
" Plug 'nvim-lua/plenary.nvim'
" Plug 'akinsho/flutter-tools.nvim'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'

Plug 'romainl/vim-cool'

Plug 'tpope/vim-fugitive'
Plug 'sindrets/diffview.nvim'
Plug 'airblade/vim-gitgutter'

Plug 'jiangmiao/auto-pairs'

if s:has_fzf
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'frozen': 1}
    Plug 'junegunn/fzf.vim'
endif

Plug 'moll/vim-bbye', {'on': 'Bdelete'}

Plug 'christoomey/vim-tmux-navigator'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Extensions to built-in LSP, for example, providing type inlay hints
"Plug 'nvim-lua/lsp_extensions.nvim'

" Autocompletion framework
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}

" LSP completion
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}

" Path completion
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}

" Function signature as you type
Plug 'ray-x/lsp_signature.nvim'

" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'

call plug#end()

""" END PLUGIN MANAGER }}}
""" PLUGIN INTEGRATION {{{

let g:gitgutter_map_keys = 0

" Keep Diffview usable without a Nerd Font or an icon plugin.
lua require('diffview').setup({ use_icons = false })

let g:tmux_navigator_disable_when_zoomed = 1

let g:AutoPairsMultilineClose = 0

cabbrev bd Bdelete

""" END PLUGIN INTEGRATION }}}
""" MISC EDITOR BEHAVIOR {{{

set encoding=utf-8
set hidden
" Recognize numbered lists
set formatoptions+=n
" Delete comment character when joining lines
set formatoptions+=j

" Update the path to provide search in subfolders
set path+=**
set path+=/usr/include

" Update the ctags path
set tags=./.tags;,tags

function! StripTrailingWhitespaces()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

command! StripTrailingWhitespaces call StripTrailingWhitespaces()

""" END MISC EDITOR BEHAVIOR }}}
""" TEMP FILES BEHAVIOR {{{

if has("persistent_undo")
    set undofile
    set undodir=$HOME/.config/nvim/undodir
endif

""" END TEMP FILES BEHAVIOR }}}
""" STATUSLINE BEHAVIOR {{{

function! ActiveStatusline()
    " Based on: https://gist.github.com/ericbn/f2956cd9ec7d6bff8940c2087247b132
    let statusline="%1*"
    let statusline.="%(%{&filetype!='help'?'\ \ '.bufnr('%'):''}\ │%)"
    let statusline.="\ %<"
    let statusline.="%f\ "
    let statusline.="%*"
    let statusline.="\ %{&modified?'[+]':''}"
    let statusline.="%{&readonly?'[ro]':''}"
    let statusline.="\ %="
    let statusline.="\ %{&filetype!=#''?&filetype:'none'}"
    let statusline.="\ │\ Ln:\ %3l,\ "
    let statusline.="Col:\ %-2v"
    let statusline.="\ │\ %2p%%\ "
    " let statusline.="%1*%{fugitive#head()!=''?' '.fugitive#head().'\ ':''}"
    return statusline
endfunction

set statusline=%!ActiveStatusline()

""" END STATUSLINE BEHAVIOR }}}
""" COLORSCHEME SETTINGS {{{

function! CustomStatuslineColors() abort
    " Gruvbox statusline colors
    if g:colors_name == 'gruvbox'
        highlight StatusLine   cterm=reverse ctermfg=239 ctermbg=223 gui=reverse guifg=#504945 guibg=#ebdbb2
        highlight StatusLineNC cterm=reverse ctermfg=237 ctermbg=246 gui=reverse guifg=#3c3836 guibg=#a89984
        highlight User1        cterm=NONE    ctermfg=235 ctermbg=223 gui=NONE    guifg=#504945 guibg=#ebdbb2
    " Blue statusline colors based on apprentice colors
    elseif g:colors_name == 'apprentice'
        highlight StatusLine   cterm=NONE         ctermfg=252 ctermbg=67  gui=NONE         guifg=#d0d0d0 guibg=#5f87af
        highlight StatusLineNC cterm=NONE         ctermfg=243 ctermbg=237 gui=NONE         guifg=#949494 guibg=#3a3a3a
        highlight User1        cterm=bold,reverse ctermfg=252 ctermbg=67  gui=NONE,reverse guifg=#d0d0d0 guibg=#5f87af
    elseif g:colors_name == 'apprentice'
        highlight StatusLine   cterm=NONE         ctermfg=252 ctermbg=67  gui=NONE         guifg=#d0d0d0 guibg=#5f87af
        highlight StatusLineNC cterm=NONE         ctermfg=243 ctermbg=237 gui=NONE         guifg=#949494 guibg=#3a3a3a
        highlight User1        cterm=bold,reverse ctermfg=252 ctermbg=67  gui=NONE,reverse guifg=#d0d0d0 guibg=#5f87af
    elseif stridx(g:colors_name, 'monokai') >= 0
        highlight StatusLine   cterm=NONE         ctermfg=252 ctermbg=67  gui=NONE         guifg=#d0d0d0 guibg=#5f87af
        highlight StatusLineNC cterm=NONE         ctermfg=243 ctermbg=237 gui=NONE         guifg=#949494 guibg=#3a3a3a
        highlight User1        cterm=bold,reverse ctermfg=252 ctermbg=67  gui=NONE,reverse guifg=#d0d0d0 guibg=#5f87af
    " Visual Studio Code inspired statusline colors
    else
        highlight StatusLine   cterm=NONE         ctermfg=253 ctermbg=54  gui=NONE         guifg=#dadada guibg=#5f0087
        highlight StatusLineNC cterm=NONE         ctermfg=243 ctermbg=237 gui=NONE         guifg=#949494 guibg=#3a3a3a
        highlight User1        cterm=bold,reverse ctermfg=253 ctermbg=54  gui=bold,reverse guifg=#dadada guibg=#5f0087
        highlight Visual cterm=NONE ctermbg=white ctermfg=darkblue
    endif
    highlight ModeMsg cterm=NONE ctermbg=green ctermfg=black
endfunction

augroup CustomStatusline
    autocmd!
    autocmd ColorScheme * call CustomStatuslineColors()
augroup END

set background=dark
set cursorline

silent! colorscheme elflord
silent! colorscheme apprentice
silent! colorscheme gruvbox

function! SaveColorscheme() abort
    let l:vimhome_plugin_folder = $HOME . "/.config/nvim/plugin"
    let l:last_used_file = l:vimhome_plugin_folder . "/last-used-colorscheme.vim"
    let l:contents = [ 'silent! colorscheme ' . g:colors_name ]
    if !isdirectory(l:vimhome_plugin_folder)
        call mkdir(l:vimhome_plugin_folder, 'p')
    endif
    call writefile(l:contents, l:last_used_file)
endfunction

augroup SaveColorscheme
    autocmd!
    autocmd ColorScheme * call SaveColorscheme()
augroup END

""" END COLORSCHEME SETTINGS }}}
""" INDENT BEHAVIOR {{{

set expandtab
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4

""" END INDENT BEHAVIOR }}}
""" SEARCH BEHAVIOR {{{

set hlsearch
set ignorecase
set smartcase

""" END SEARCH BEHAVIOR }}}
""" NORMAL MODE BEHAVIOR {{{

nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> $ g$
nnoremap <silent> 0 g^
nnoremap ' `

if empty(glob("~/.vim/plugged/vim-tmux-navigator/"))
    nnoremap <c-j> <c-w>j
    nnoremap <c-k> <c-w>k
    nnoremap <c-h> <c-w>h
    nnoremap <c-l> <c-w>l
endif

""" END NORMAL MODE BEHAVIOR }}}
""" VISUAL MODE BEHAVIOR {{{

vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

augroup HighlightFollowsFocus
    autocmd!
    autocmd WinEnter,FocusGained * set cursorline
    autocmd WinLeave,FocusLost * set nocursorline
augroup END

set number
if exists("&relativenumber")
    set relativenumber
endif

augroup SmartNumbers
    autocmd!
    if exists("&relativenumber")
        autocmd WinEnter,FocusGained * if &number | setlocal relativenumber | endif
        autocmd WinLeave,FocusLost * if &number | setlocal norelativenumber | endif
    endif
augroup END

set showbreak=↪\
set list
set listchars=tab:»\ ,trail:•,nbsp:␣,precedes:⟨,extends:⟩

""" END VISUAL BEHAVIOR }}}
""" FOLD BEHAVIOR {{{

set foldmethod=marker
set foldopen+=jump

""" END FOLD BEHAVIOR }}}
""" WINDOW BEHAVIOR {{{

set splitbelow
set splitright

""" END WINDOW BEHAVIOR }}}
""" COMMAND LINE BEHAVIOR {{{

set wildmode=longest:list,full
if exists("&wildignorecase")
    set wildignorecase
endif

cmap w!! w !sudo tee > /dev/null %
cabbr <expr> %% expand('%:p:h')

""" END COMMAND LINE BEHAVIOR }}}
""" LEADER KEY BEHAVIOR {{{

if s:has_fzf
    nnoremap <silent> ,b :Buffers<cr>
    nnoremap <silent> ,f :Files<cr>
    nnoremap <silent> ,t :Tags<cr>
    nnoremap <silent> <leader>fb :Buffers<cr>
    nnoremap <silent> <leader>ff :Files<cr>
    nnoremap <silent> <leader>fg :GFiles<cr>
else
    nnoremap          ,b :b <C-d>
    nnoremap          ,f :find *
    nnoremap          ,t :tjump /
endif

nmap     <silent> ,c       :bd<cr>
nnoremap          ,e       :e **/*
nnoremap <silent> ,m       :make<cr>
nnoremap <silent> ,q       :quit<cr>
nnoremap <silent> ,z       :b#<cr>

nnoremap <silent> <leader>gs :Git<cr>
nnoremap <silent> <leader>gd :DiffviewOpen<cr>
nnoremap <silent> <leader>gh :DiffviewFileHistory %<cr>

if s:has_fzf && executable('ag')
    nnoremap ,/ :Ag<space>
    nnoremap <leader>sg :Ag<space>
    nnoremap <silent> <leader>sw :call fzf#vim#ag(expand('<cword>'), '--literal --word-regexp', fzf#vim#with_preview())<cr>
else
    nnoremap ,/ :grep<space>
endif

""" END LEADER KEY BEHAVIOR }}}
""" GREP AND VIMGREP BEHAVIOR {{{

if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
endif

""" END GREP AND VIMGREP BEHAVIOR }}}
""" BUFFER SPECIFIC BEHAVIOR {{{

augroup FileTypeSpell
    autocmd!
    if has("spell")
        autocmd Filetype markdown,gitcommit,todo setlocal spell
    endif
augroup END

augroup AdditionalFileTypesCommands
    autocmd!
    autocmd BufWrite *.py :call StripTrailingWhitespaces()
    autocmd BufWrite *.coffee :call StripTrailingWhitespaces()
    autocmd Filetype c,cpp,cs,java  setlocal commentstring=//\ %s
augroup END

augroup LastBufferPosition
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

augroup AutomaticQuickFix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost    l* lwindow
augroup END

""" END BUFFER SPECIFIC BEHAVIOR }}}
""" CODE COMPLETION BEHAVIOR {{{


"set omnifunc=syntaxcomplete#Complete

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Better display for messages
" set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" Avoid showing extra messages when using completion
set shortmess+=c

""" END CODE COMPLETION BEHAVIOR }}}
""" C++ SPECIFIC BEHAVIOR {{{

set cindent
set cinoptions+=g0 " Place C++ scope declarations (public/private/protected) on the same indentation as the parent
set cinoptions+=N-s " Do not indent after namespace definitions
set cinoptions+=:0 " Do not indent switch cases compared to the switch()-statement

""" END C++ SPECIFIC BEHAVIOR }}}
""" LSP configuration {{{

lua << END

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true })
--  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--  ['<C-f>'] = cmp.mapping.scroll_docs(4),
--  ['<C-Space>'] = cmp.mapping.complete(),
--  ['<C-e>'] = cmp.mapping.close(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'path' },
  }),
  experimental = {
    ghost_text = true,
  },
})

-- Enable completing paths in :
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

-- nvim-lspconfig supplies the server defaults; Neovim enables them.
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspMappings', { clear = true }),
  callback = function(event)
    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, opts)

    require('lsp_signature').on_attach({
      doc_lines = 0,
      handler_opts = { border = 'none' },
    }, event.buf)
  end,
})

vim.lsp.enable('basedpyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
END

"require("flutter-tools").setup{}


"lua << END
"
"END

""" }}}
