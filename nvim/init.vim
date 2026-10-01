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
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/sonokai'
Plug 'rebelot/kanagawa.nvim'
Plug 'folke/tokyonight.nvim'

" Treesitter: accurate syntax highlighting and structural text objects
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'master'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch': 'master'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'kylechui/nvim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'numToStr/Comment.nvim'
Plug 'folke/flash.nvim'

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
Plug 'saghen/blink.cmp', { 'tag': '*' }

" Function signature as you type
Plug 'ray-x/lsp_signature.nvim'

" Statusline and file-type icons
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/todo-comments.nvim'
Plug 'stevearc/oil.nvim'
Plug 'chrisbra/unicode.vim'
Plug 'stevearc/conform.nvim'
Plug 'OXY2DEV/markview.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'folke/which-key.nvim'

call plug#end()

""" END PLUGIN MANAGER }}}
""" PLUGIN INTEGRATION {{{

lua require('diffview').setup({ use_icons = true })
lua require('treesitter-context').setup()
lua require('ibl').setup()
lua require('nvim-surround').setup()
lua require('Comment').setup()
lua require('markview').setup()
lua require('illuminate').configure()

lua << END
require('which-key').setup()
require('which-key').add({
  { '<leader>g',  group = 'Git' },
  { '<leader>gs', desc = 'Status' },
  { '<leader>gd', desc = 'Diff open' },
  { '<leader>gc', desc = 'Diff close' },
  { '<leader>gh', desc = 'File history' },
  { '<leader>gb', desc = 'Blame' },
  { '<leader>gl', desc = 'Log' },
  { '<leader>gf', desc = 'Find git file' },

  { '<leader>l',  group = 'LSP' },
  { '<leader>lt', desc = 'Type definition' },
  { '<leader>lr', desc = 'Rename symbol' },
  { '<leader>la', desc = 'Code actions' },
  { '<leader>ld', desc = 'Diagnostics float' },
  { '<leader>lq', desc = 'Diagnostics loclist' },
  { '<leader>lf', desc = 'Format buffer' },

  { '<leader>b',  desc = 'Buffers' },
  { '<leader>f',  desc = 'Find file' },
  { '<leader>t',  desc = 'Tags' },
  { '<leader>e',  desc = 'Edit file' },
  { '<leader>m',  desc = 'Make' },
  { '<leader>q',  desc = 'Quit window' },
  { '<leader>z',  desc = 'Alternate buffer' },
  { '<leader>w',  desc = 'Write' },
  { '<leader>c',  desc = 'Close buffer' },
  { '<leader>/',  desc = 'Search (Ag/grep)' },
  { '<leader>sw', desc = 'Search word under cursor' },
  { '<leader>y',  desc = 'Yank to clipboard',  mode = { 'n', 'x' } },
  { '<leader>p',  desc = 'Paste from clipboard' },

  { 'g',   group = 'Go to / surround / comment' },
  { 'gD',  desc = 'Declaration' },
  { 'gd',  desc = 'Definition' },
  { 'gi',  desc = 'Implementation' },
  { 'gr',  desc = 'References' },
  { 'gcc', desc = 'Toggle comment (line)' },
  { 'gbc', desc = 'Toggle comment (block)' },

  { ']',   group = 'Next' },
  { ']d',  desc = 'Diagnostic' },
  { ']h',  desc = 'Hunk' },
  { ']r',  desc = 'Reference (illuminate)' },
  { ']b',  desc = 'Buffer' },
  { ']q',  desc = 'Quickfix' },
  { ']l',  desc = 'Loclist' },
  { ']f',  desc = 'File in dir' },
  { ']e',  desc = 'Move line down' },

  { '[',   group = 'Prev' },
  { '[d',  desc = 'Diagnostic' },
  { '[h',  desc = 'Hunk' },
  { '[r',  desc = 'Reference (illuminate)' },
  { '[b',  desc = 'Buffer' },
  { '[q',  desc = 'Quickfix' },
  { '[l',  desc = 'Loclist' },
  { '[f',  desc = 'File in dir' },
  { '[e',  desc = 'Move line up' },
})
END

lua << END
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash', 'c', 'cpp', 'lua', 'python', 'rust', 'toml', 'typst', 'vim', 'vimdoc',
  },
  highlight = { enable = true },
  indent    = { enable = true },
  textobjects = {
    select = {
      enable    = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
      },
    },
    move = {
      enable              = true,
      set_jumps           = true,
      goto_next_start     = { [']f'] = '@function.outer' },
      goto_next_end       = { [']F'] = '@function.outer' },
      goto_previous_start = { ['[f'] = '@function.outer' },
      goto_previous_end   = { ['[F'] = '@function.outer' },
    },
  },
})
END

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

lua << END
-- Separators: sainnhe's slant-right glyphs (U+E0B8/E0BE section, U+E0B9 component)
require('lualine').setup({
  options = {
    theme                = 'auto',
    section_separators   = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    globalstatus         = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      { 'diff', symbols = { added = ' +', modified = ' ~', removed = ' -' } },
    },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {
      { 'diagnostics', sources = { 'nvim_lsp' } },
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
END

lua << END
require("todo-comments").setup({
  signs = true,
  sign_priority = 8,
  highlight = {
    before    = "",
    keyword   = "bg",
    after     = "fg",
    pattern   = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
  },
})
END

lua << END
require("oil").setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
})
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
END

let g:tmux_navigator_disable_when_zoomed = 1

let g:AutoPairsMultilineClose = 0

cabbrev bd Bdelete

""" END PLUGIN INTEGRATION }}}
""" MISC EDITOR BEHAVIOR {{{

set encoding=utf-8
set noshowmode

" Cursor shape per mode.
" Non-blinking: steady block in normal/visual, bar in insert, underline in replace.
"set guicursor=n-v-c:block,i-ci-ve:ver40,r-cr:hor20,o:hor50
" Blinking in insert mode (700 ms delay before first blink, 400 ms on, 250 ms off).
set guicursor=n-v-c:block,i-ci-ve:ver40-blinkwait700-blinkon400-blinkoff250,r-cr:hor20,o:hor50
set hidden
set signcolumn=yes
set scrolloff=5
set sidescrolloff=2
set display+=truncate
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
""" COLORSCHEME SETTINGS {{{

let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_foreground = 'original'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:sonokai_style = 'shusia'
let g:sonokai_enable_italic = 1

set background=dark
set cursorline

" The saved theme in plugin/last-used-colorscheme.vim overrides this fallback.
" TODO: Test
" silent! colorscheme kanagawa-wave
" silent! colorscheme tokyonight-moon
" silent! colorscheme gruvbox-material
silent! colorscheme sonokai

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
nnoremap          <leader>y "+y
xnoremap          <leader>y "+y
nnoremap          <leader>p "+p

nnoremap <silent> <leader>gs :Git<cr>
nnoremap <silent> <leader>gd :DiffviewOpen<cr>
nnoremap <silent> <leader>gc :DiffviewClose<cr>
nnoremap <silent> <leader>gh :DiffviewFileHistory %<cr>
nnoremap <silent> <leader>gb :Git blame<cr>
nnoremap <silent> <leader>gl :Git log<cr>

if s:has_fzf && executable('ag')
    nnoremap          <leader>/ :Ag<space>
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
""" FORMATTER {{{

lua << END
require("conform").setup({
  formatters_by_ft = {
    c          = { "clang_format" },
    cpp        = { "clang_format" },
    rust       = { "rustfmt" },
    python     = { "ruff_format", "ruff_organize_imports" },
    lua        = { "stylua" },
    typst      = { "typstyle" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
END

""" END FORMATTER }}}
""" LSP configuration {{{

lua << END

require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<C-p>']  = { 'select_prev', 'fallback' },
    ['<C-n>']  = { 'select_next', 'fallback' },
    ['<CR>']   = { 'accept', 'fallback' },
    ['<Tab>']  = { 'accept', 'fallback' },
    ['<C-e>']  = { 'hide' },
  },
  completion = {
    ghost_text = { enabled = true },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
})

-- nvim-lspconfig supplies the server defaults; Neovim enables them.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
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
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)
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
