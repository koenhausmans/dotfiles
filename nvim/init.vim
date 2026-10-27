""" PLUGIN MANAGER (VIM-PLUG) {{{

let mapleader = ','
nnoremap <leader>, ,
let s:has_fzf = executable('fzf')
let g:tmux_navigator_disable_when_zoomed = 1
let s:plugins_ready = 0
let s:missing_plugins = []

if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd --type f'
elseif executable('fdfind')
    let $FZF_DEFAULT_COMMAND = 'fdfind --type f'
elseif executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files'
endif

let s:nvim_config_dir = stdpath('config')
let s:plug_path = s:nvim_config_dir . '/autoload/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if !filereadable(s:plug_path)
    let s:plug_dir = fnamemodify(s:plug_path, ':h')
    let s:plug_tmp = s:plug_path . '.tmp-' . getpid()
    if executable('curl') && (isdirectory(s:plug_dir) || mkdir(s:plug_dir, 'p'))
        call delete(s:plug_tmp)
        call system('curl -fL --silent --show-error -o ' . shellescape(s:plug_tmp) . ' ' . shellescape(s:plug_url))
        if v:shell_error == 0 && filereadable(s:plug_tmp) && getfsize(s:plug_tmp) > 0 && rename(s:plug_tmp, s:plug_path) == 0
            echom '[dotfiles] vim-plug installed. Run :PlugInstall, wait for it to finish, then restart Neovim.'
        else
            call delete(s:plug_tmp)
            echom '[dotfiles] Could not install vim-plug at ' . s:plug_path . '. Retry when online, or run: curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs ' . s:plug_url . ' ; then restart Neovim.'
        endif
    else
        echom '[dotfiles] vim-plug is missing and curl or its destination is unavailable. Install it at ' . s:plug_path . ' and restart Neovim.'
    endif
endif

if filereadable(s:plug_path) && executable('git')
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
    Plug 'junegunn/fzf'
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

for [s:plugin_name, s:plugin] in items(g:plugs)
    if !isdirectory(s:plugin.dir)
        call add(s:missing_plugins, s:plugin_name)
    endif
endfor

let s:plugins_ready = empty(s:missing_plugins)
if !s:plugins_ready
    echom '[dotfiles] Missing Neovim plugins: ' . join(s:missing_plugins, ', ') . '. Run :PlugInstall, wait for completion, then restart Neovim.'
endif
elseif filereadable(s:plug_path)
    echom '[dotfiles] Git is required by vim-plug. Install Git, then restart Neovim.'
endif

""" END PLUGIN MANAGER }}}
""" PLUGIN INTEGRATION {{{
if s:plugins_ready

lua require('diffview').setup({ use_icons = true })
lua require('treesitter-context').setup()
lua require('ibl').setup()
lua require('nvim-surround').setup()
lua require('Comment').setup()
lua require('flash').setup()
lua vim.keymap.set({'n', 'x', 'o'}, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
lua vim.keymap.set({'n', 'o'}, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter select' })
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
  { '<leader>/',  desc = 'Search (Rg/grep)' },
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
  { ']m',  desc = 'Next function start' },
  { ']M',  desc = 'Next function end' },
  { ']e',  desc = 'Move line down' },

  { '[',   group = 'Prev' },
  { '[d',  desc = 'Diagnostic' },
  { '[h',  desc = 'Hunk' },
  { '[r',  desc = 'Reference (illuminate)' },
  { '[b',  desc = 'Buffer' },
  { '[q',  desc = 'Quickfix' },
  { '[l',  desc = 'Loclist' },
  { '[f',  desc = 'File in dir' },
  { '[m',  desc = 'Previous function start' },
  { '[M',  desc = 'Previous function end' },
  { '[e',  desc = 'Move line up' },
})
END

lua << END
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash', 'c', 'cpp', 'lua', 'markdown', 'markdown_inline', 'python', 'rust', 'toml', 'typst', 'vim', 'vimdoc',
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
      goto_next_start     = { [']m'] = '@function.outer' },
      goto_next_end       = { [']M'] = '@function.outer' },
      goto_previous_start = { ['[m'] = '@function.outer' },
      goto_previous_end   = { ['[M'] = '@function.outer' },
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

let g:AutoPairsMultilineClose = 0

cabbrev bd Bdelete

endif

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
set tags^=./.git/tags;,./.tags;

function! StripTrailingWhitespaces() abort
    let l:view = winsaveview()
    try
        keeppatterns keepmarks keepjumps %s/\s\+$//ge
    finally
        call winrestview(l:view)
    endtry
endfunction

command! StripTrailingWhitespaces call StripTrailingWhitespaces()

""" END MISC EDITOR BEHAVIOR }}}
""" TEMP FILES BEHAVIOR {{{

if has("persistent_undo")
    set undofile
    let &undodir = s:nvim_config_dir . '/undodir'
    call mkdir(&undodir, 'p')
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
silent! colorscheme kanagawa-wave
" silent! colorscheme tokyonight-moon
" silent! colorscheme gruvbox-material
" silent! colorscheme sonokai

function! SaveColorscheme() abort
    let l:vimhome_plugin_folder = s:nvim_config_dir . '/plugin'
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

lua << END
local navigator = {
  ['<C-h>'] = { 'TmuxNavigateLeft', 'h' },
  ['<C-j>'] = { 'TmuxNavigateDown', 'j' },
  ['<C-k>'] = { 'TmuxNavigateUp', 'k' },
  ['<C-l>'] = { 'TmuxNavigateRight', 'l' },
}
local function navigate(command, direction)
  if vim.fn.exists(':' .. command) == 2 then
    vim.cmd(command)
  else
    vim.cmd.wincmd(direction)
  end
end
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('DotfilesNavigator', { clear = true }),
  callback = function()
    if vim.fn.exists(':TmuxNavigateLeft') == 2 then
      return
    end
    for key, target in pairs(navigator) do
      local command, direction = target[1], target[2]
      vim.keymap.set('n', key, function() navigate(command, direction) end, { silent = true })
    end
    for key, target in pairs(navigator) do
      local direction = target[2]
      vim.keymap.set('t', key, function()
        if vim.bo.filetype == 'fzf' then
          return key
        end
        return '<C-\\><C-n><C-w>' .. direction
      end, { expr = true, silent = true })
    end
  end,
})
END

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

function! s:SudoWrite() abort
    if empty(bufname('%')) || &buftype !=# ''
        throw 'SudoWrite requires a named file buffer'
    endif

    execute 'write !sudo tee -- ' . shellescape(expand('%:p'), 1) . ' >/dev/null'
    if v:shell_error != 0
        throw 'SudoWrite failed; buffer has not been marked saved'
    endif

    setlocal nomodified
endfunction

command! SudoWrite call <SID>SudoWrite()
cnoreabbrev <expr> w!! getcmdtype() ==# ':' && getcmdline() ==# 'w!!' ? 'SudoWrite' : 'w!!'

cabbr <expr> %% expand('%:p:h')

""" END COMMAND LINE BEHAVIOR }}}
""" LEADER KEY BEHAVIOR {{{

if s:plugins_ready && s:has_fzf
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

if s:plugins_ready
    nnoremap <silent> <leader>gs :Git<cr>
    nnoremap <silent> <leader>gd :DiffviewOpen<cr>
    nnoremap <silent> <leader>gc :DiffviewClose<cr>
    nnoremap <silent> <leader>gh :DiffviewFileHistory %<cr>
    nnoremap <silent> <leader>gb :Git blame<cr>
    nnoremap <silent> <leader>gl :Git log<cr>
endif

if s:plugins_ready && s:has_fzf && executable('rg')
    nnoremap          <leader>/ :Rg<space>
    nnoremap <silent> <leader>sw :call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case --word-regexp -- ' . fzf#shellescape(expand('<cword>')), fzf#vim#with_preview(), 0)<cr>
else
    nnoremap          <leader>/ :grep<space>
endif

""" END LEADER KEY BEHAVIOR }}}
""" GREP AND VIMGREP BEHAVIOR {{{

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ $*
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

if s:plugins_ready
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
  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
})
vim.keymap.set('n', '<leader>lf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { silent = true, desc = 'Format buffer' })
END

""" END FORMATTER }}}
""" LSP configuration {{{

lua << END

require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<C-p>']  = { 'select_prev', 'fallback' },
    ['<C-n>']  = { 'select_next', 'fallback' },
    -- Blink's fallback cannot replay auto-pairs' script-local <CR> mapping.
      ['<CR>']   = { 'accept', function()
        if vim.fn.exists('*AutoPairsReturn') == 1 then
          return vim.keycode('<CR><C-R>=AutoPairsReturn()<CR>')
        end
        return vim.keycode('<CR>')
      end },
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
endif

""" }}}
