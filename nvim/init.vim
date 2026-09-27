""" PLUGIN MANAGER (VIM-PLUG) {{{

let mapleader = ','
nnoremap <leader>, ,
" The fzf binary also works when Neovim is started without an interactive shell.
let s:has_fzf = executable('fzf') || executable(expand('~/.fzf/bin/fzf'))

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()

" Colorschemes: Additional colorschemes that can be used
Plug 'ellisonleao/gruvbox.nvim'
Plug 'sainnhe/gruvbox-material'
Plug 'joshdick/onedark.vim'
Plug 'tanvirtin/monokai.nvim'
Plug 'folke/tokyonight.nvim'

" Syntax: Additional syntaxes that can be used
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'

Plug 'romainl/vim-cool'

Plug 'tpope/vim-fugitive'
Plug 'sindrets/diffview.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'jiangmiao/auto-pairs'

if s:has_fzf
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'frozen': 1}
    Plug 'junegunn/fzf.vim'
endif

Plug 'moll/vim-bbye', {'on': 'Bdelete'}

Plug 'christoomey/vim-tmux-navigator'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Autocompletion framework
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}

" LSP completion
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}

" Path completion
Plug 'hrsh7th/cmp-path', {'branch': 'main'}

" Function signature as you type
Plug 'ray-x/lsp_signature.nvim'

" Snippet expansion for nvim-cmp
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'

call plug#end()

""" END PLUGIN MANAGER }}}
""" PLUGIN INTEGRATION {{{

" Keep Diffview usable without a Nerd Font or an icon plugin.
lua require('diffview').setup({ use_icons = false })

lua << END
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, opts)
    vim.keymap.set('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, opts)
  end,
})
END

let g:tmux_navigator_disable_when_zoomed = 1

let g:AutoPairsMultilineClose = 0

cabbrev bd Bdelete

""" END PLUGIN INTEGRATION }}}
""" MISC EDITOR BEHAVIOR {{{

set encoding=utf-8
set hidden
set signcolumn=yes
set scrolloff=5
set termguicolors
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

function! GitStatusline() abort
    let l:changes = get(b:, 'gitsigns_status_dict', {})
    let l:head = get(l:changes, 'head', '')
    if empty(l:head)
        let l:head = FugitiveHead(7)
    endif
    if empty(l:head)
        return ''
    endif

    let l:summary = ' [' . substitute(l:head, '%', '%%', 'g')
    for [l:sign, l:key] in [['+', 'added'], ['~', 'changed'], ['-', 'removed']]
        let l:count = get(l:changes, l:key, 0)
        if l:count > 0
            let l:summary .= printf(' %s%d', l:sign, l:count)
        endif
    endfor
    return l:summary . ']'
endfunction

function! ActiveStatusline()
    " Based on: https://gist.github.com/ericbn/f2956cd9ec7d6bff8940c2087247b132
    let statusline="%1*"
    let statusline.="%(%{&filetype!='help'?'\ \ '.bufnr('%'):''}\ │%)"
    let statusline.="\ %<"
    let statusline.="%f\ "
    let statusline.=GitStatusline()
    let statusline.="%*"
    let statusline.="\ %{&modified?'[+]':''}"
    let statusline.="%{&readonly?'[ro]':''}"
    let statusline.="\ %="
    let statusline.="\ %{&filetype!=#''?&filetype:'none'}"
    let statusline.="\ │\ Ln:\ %3l,\ "
    let statusline.="Col:\ %-2v"
    let statusline.="\ │\ %2p%%\ "
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
    elseif g:colors_name == 'gruvbox-material'
        highlight StatusLine   cterm=reverse ctermfg=239 ctermbg=223 gui=reverse guifg=#504945 guibg=#ebdbb2
        highlight StatusLineNC cterm=reverse ctermfg=237 ctermbg=246 gui=reverse guifg=#3c3836 guibg=#a89984
        highlight User1        cterm=NONE    ctermfg=235 ctermbg=223 gui=NONE    guifg=#504945 guibg=#ebdbb2
    " Blue statusline colors based on apprentice colors
    elseif g:colors_name =~# '^tokyonight'
        " Let Tokyo Night color the statusline in both dark and light styles.
        highlight! link User1 StatusLine
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

let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_better_performance = 1

set background=dark
set cursorline

" The saved theme in plugin/last-used-colorscheme.vim overrides this fallback.
silent! colorscheme gruvbox-material

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
    nnoremap <silent> <leader>b :Buffers<cr>
    nnoremap <silent> <leader>f :Files<cr>
    nnoremap <silent> <leader>t :Tags<cr>
    nnoremap <silent> <leader>gf :GFiles<cr>
else
    nnoremap          <leader>b :b <C-d>
    nnoremap          <leader>f :find *
    nnoremap          <leader>t :tjump /
endif

nmap     <silent> <leader>c :bd<cr>
nnoremap          <leader>e :e **/*
nnoremap <silent> <leader>m :make<cr>
nnoremap <silent> <leader>q :quit<cr>
nnoremap <silent> <leader>z :b#<cr>
nnoremap <silent> <leader>w :write<cr>

nnoremap <silent> <leader>gs :Git<cr>
nnoremap <silent> <leader>gd :DiffviewOpen<cr>
nnoremap <silent> <leader>gh :DiffviewFileHistory %<cr>

if s:has_fzf && executable('ag')
    nnoremap          <leader>/ :Ag<space>
    nnoremap          <leader>sg :Ag<space>
    nnoremap <silent> <leader>sw :call fzf#vim#ag(expand('<cword>'), '--literal --word-regexp', fzf#vim#with_preview())<cr>
else
    nnoremap          <leader>/ :grep<space>
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


" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" Avoid showing extra messages when using completion
set shortmess+=c

""" END CODE COMPLETION BEHAVIOR }}}
""" C++ SPECIFIC BEHAVIOR {{{

" Scope our C/C++ indentation settings to those filetypes.
" g0 aligns access labels, N-s avoids namespace indentation, :0 aligns cases.
augroup CFamilyIndent
    autocmd!
    autocmd FileType c,cpp setlocal cindent cinoptions+=g0 cinoptions+=N-s cinoptions+=:0
augroup END

""" END C++ SPECIFIC BEHAVIOR }}}
""" LSP configuration {{{

lua << END

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- Expand LSP snippets with vim-vsnip.
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
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, opts)

    require('lsp_signature').on_attach({
      doc_lines = 0,
      handler_opts = { border = 'none' },
    }, event.buf)
  end,
})

vim.lsp.enable('basedpyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('tinymist')
END

""" }}}
