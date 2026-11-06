-- vim: foldmethod=marker

local gh = function(x) return 'https://github.com/' .. x end

--- PLUGINS {{{

vim.pack.add({
  -- Colorschemes
  gh 'sainnhe/gruvbox-material',
  gh 'sainnhe/sonokai',
  gh 'rebelot/kanagawa.nvim',
  gh 'folke/tokyonight.nvim',

  -- Treesitter: accurate syntax highlighting and structural text objects
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  gh 'nvim-treesitter/nvim-treesitter-textobjects',
  gh 'nvim-treesitter/nvim-treesitter-context',
  gh 'lukas-reineke/indent-blankline.nvim',

  gh 'kylechui/nvim-surround',
  gh 'tpope/vim-repeat',
  gh 'tpope/vim-unimpaired',
  gh 'folke/flash.nvim',

  gh 'romainl/vim-cool',

  gh 'tpope/vim-fugitive',
  gh 'sindrets/diffview.nvim',
  gh 'lewis6991/gitsigns.nvim',

  gh 'nvim-mini/mini.pairs',

  gh 'ibhagwan/fzf-lua',

  gh 'moll/vim-bbye',

  gh 'christoomey/vim-tmux-navigator',

  gh 'neovim/nvim-lspconfig',
  { src = gh 'saghen/blink.cmp', version = vim.version.range('1.*') },
  gh 'mfussenegger/nvim-lint',
  gh 'folke/trouble.nvim',

  -- Statusline and icons
  gh 'nvim-lualine/lualine.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'folke/todo-comments.nvim',
  gh 'stevearc/oil.nvim',
  gh 'stevearc/conform.nvim',
  gh 'OXY2DEV/markview.nvim',
  gh 'RRethy/vim-illuminate',
  gh 'folke/which-key.nvim',
})

--- END PLUGINS }}}
--- PLUGIN INTEGRATION {{{

require('diffview').setup({ use_icons = true })
require('treesitter-context').setup()
require('ibl').setup()
require('nvim-surround').setup()
require('mini.pairs').setup()
require('trouble').setup()
require('flash').setup()
vim.keymap.set({'n', 'x', 'o'}, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
vim.keymap.set({'n', 'o'}, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter select' })
require('markview').setup()
require('illuminate').configure()

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

  { '<leader>u',  group = 'Toggle' },
  { '<leader>uf', desc = 'Format on save' },

  { '<leader>x',  group = 'Trouble lists' },
  { '<leader>xx', desc = 'Diagnostics' },
  { '<leader>xX', desc = 'Buffer diagnostics' },
  { '<leader>xq', desc = 'Quickfix list' },
  { '<leader>xl', desc = 'Location list' },

  { '<leader>b',  desc = 'Buffers' },
  { '<leader>f',  desc = 'Find file' },
  { '<leader>t',  desc = 'Tags' },
  { '<leader>e',  desc = 'Edit file' },
  { '<leader>m',  desc = 'Make' },
  { '<leader>q',  desc = 'Quit window' },
  { '<leader>z',  desc = 'Alternate buffer' },
  { '<leader>w',  desc = 'Write' },
  { '<leader>c',  desc = 'Close buffer' },
  { '<leader>/',  desc = 'Search (live grep/grep)' },
  { '<leader>sw', desc = 'Search word under cursor' },
  { '<leader>y',  desc = 'Yank to clipboard',  mode = { 'n', 'x' } },
  { '<leader>p',  desc = 'Paste from clipboard' },

  { 'g',   group = 'Go to / surround / comment' },
  { 'gD',  desc = 'Declaration' },
  { 'gd',  desc = 'Definition' },
  { 'gi',  desc = 'Implementation' },
  { 'gr',  desc = 'References' },
  { 'gcc', desc = 'Toggle comment (line)' },

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

do
  local treesitter = require('nvim-treesitter')
  if type(treesitter.install) ~= 'function' then
    vim.notify('[dotfiles] Run :lua vim.pack.update(), then restart Neovim.', vim.log.levels.WARN)
  else
    treesitter.install({
      'bash', 'c', 'cpp', 'lua', 'markdown', 'markdown_inline', 'python', 'rust', 'toml', 'typst', 'vim', 'vimdoc',
    })
  end
end

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('DotfilesTreesitter', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not lang or not vim.treesitter.language.add(lang) then return end

    vim.treesitter.start(args.buf, lang)
    local undo = {}
    if vim.b[args.buf].undo_ftplugin and vim.b[args.buf].undo_ftplugin ~= '' then
      undo[#undo + 1] = vim.b[args.buf].undo_ftplugin
    end
    undo[#undo + 1] = 'call v:lua.vim.treesitter.stop()'
    if vim.treesitter.query.get(lang, 'indents') then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      undo[#undo + 1] = 'setlocal indentexpr<'
    end

    if not vim.treesitter.query.get(lang, 'textobjects') then
      vim.b[args.buf].undo_ftplugin = table.concat(undo, '|')
      return
    end

    local function map(modes, key, callback, description)
      vim.keymap.set(modes, key, callback, { buffer = args.buf, desc = description })
      for _, mode in ipairs(modes) do
        undo[#undo + 1] = 'silent! ' .. mode .. 'unmap <buffer> ' .. key
      end
    end

    for key, capture in pairs({
      af = '@function.outer', ['if'] = '@function.inner',
      ac = '@class.outer', ic = '@class.inner',
      aa = '@parameter.outer', ia = '@parameter.inner',
    }) do
      map({ 'x', 'o' }, key, function()
        require('nvim-treesitter-textobjects.select').select_textobject(capture, 'textobjects')
      end, 'Select ' .. capture)
    end

    for key, method in pairs({
      [']m'] = 'goto_next_start', [']M'] = 'goto_next_end',
      ['[m'] = 'goto_previous_start', ['[M'] = 'goto_previous_end',
    }) do
      map({ 'n', 'x', 'o' }, key, function()
        require('nvim-treesitter-textobjects.move')[method]('@function.outer', 'textobjects')
      end, method:gsub('_', ' ') .. ' function')
    end
    vim.b[args.buf].undo_ftplugin = table.concat(undo, '|')
  end,
})

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set('n', ']h', function()
      if vim.wo.diff then vim.cmd.normal({ ']c', bang = true })
      else gitsigns.nav_hunk('next') end
    end, opts)
    vim.keymap.set('n', '[h', function()
      if vim.wo.diff then vim.cmd.normal({ '[c', bang = true })
      else gitsigns.nav_hunk('prev') end
    end, opts)
  end,
})

-- Separators: sainnhe's slant-right glyphs (U+E0B8/E0BE section, U+E0B9 component)
require('lualine').setup({
  options = {
    theme                = 'auto',
    section_separators   = { left = '', right = '' },
    component_separators = { left = '', right = '' },
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
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

require('todo-comments').setup({
  signs = true,
  sign_priority = 8,
  highlight = {
    before    = '',
    keyword   = 'bg',
    after     = 'fg',
    pattern   = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
  },
})

require('oil').setup({
  default_file_explorer = true,
  view_options = { show_hidden = true },
})
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer diagnostics' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix list' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location list' })

do
  local lint = require('lint')
  lint.linters_by_ft = {
    python = { 'ruff' },
    sh     = { 'shellcheck' },
    bash   = { 'shellcheck' },
  }
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('DotfilesLint', { clear = true }),
    callback = function() lint.try_lint(nil, { ignore_errors = true }) end,
  })
end

if vim.fn.executable('fzf') == 1 then
  require('fzf-lua').setup()
end

vim.cmd('cabbrev bd Bdelete')

--- END PLUGIN INTEGRATION }}}
--- MISC EDITOR BEHAVIOR {{{

vim.o.encoding  = 'utf-8'
vim.o.showmode  = false

-- Cursor shape per mode.
-- Non-blinking: steady block in normal/visual, bar in insert, underline in replace.
-- Blinking in insert mode (700 ms delay before first blink, 400 ms on, 250 ms off).
vim.o.guicursor = 'n-v-c:block,i-ci-ve:ver40-blinkwait700-blinkon400-blinkoff250,r-cr:hor20,o:hor50'
vim.o.hidden    = true
vim.o.signcolumn = 'yes'
vim.o.scrolloff = 5
vim.o.sidescrolloff = 2
vim.opt.display:append('truncate')
vim.o.termguicolors = true
-- Recognize numbered lists and delete comment char when joining lines
vim.opt.formatoptions:append('nj')

-- Search in subfolders; include system headers
vim.opt.path:append('**')
vim.opt.path:append('/usr/include')

-- ctags from git dir or project root
vim.opt.tags:prepend('./.git/tags;')
vim.opt.tags:prepend('./.tags;')

vim.api.nvim_create_user_command('StripTrailingWhitespaces', function()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns keepmarks keepjumps %s/\s\+$//ge]])
  vim.fn.winrestview(view)
end, {})

--- END MISC EDITOR BEHAVIOR }}}
--- TEMP FILES BEHAVIOR {{{

vim.o.undofile = true
vim.o.undodir  = vim.fn.stdpath('config') .. '/undodir'
vim.fn.mkdir(vim.o.undodir, 'p')

--- END TEMP FILES BEHAVIOR }}}
--- COLORSCHEME SETTINGS {{{

vim.g.gruvbox_material_background    = 'hard'
vim.g.gruvbox_material_foreground    = 'original'
vim.g.gruvbox_material_enable_bold   = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.sonokai_style          = 'shusia'
vim.g.sonokai_enable_italic  = 1

vim.o.background  = 'dark'
vim.o.cursorline  = true

do
  -- Keep tmux's muted inactive borders, but use warm active colors to distinguish Neovim.
  local split_colors = {
    ['gruvbox-material'] = { inactive = '#504945', active = '#fabd2f' },
    ['kanagawa-wave']    = { inactive = '#363646', active = '#c0a36e' },
    ['tokyonight-night'] = { inactive = '#292e42', active = '#e0af68' },
    sonokai              = { inactive = '#3b3e48', active = '#e7c664' },
  }
  local split_focused  = true
  local split_active_win
  local function split_palette()
    local theme = vim.g.colors_name
    -- Kanagawa reports "kanagawa" for all three variants.
    if theme == 'kanagawa' and package.loaded.kanagawa then
      theme = 'kanagawa-' .. (package.loaded.kanagawa._CURRENT_THEME or 'wave')
    end
    return split_colors[theme]
  end
  local function split_bounds(win)
    local pos    = vim.api.nvim_win_get_position(win)
    local height = vim.api.nvim_win_get_height(win)
    return { top = pos[1], left = pos[2], bottom = pos[1] + height,
      right = pos[2] + vim.api.nvim_win_get_width(win) }
  end
  local function update_split_highlights()
    local current = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(current).relative ~= '' then
      current = split_active_win
      if not current or not vim.api.nvim_win_is_valid(current)
        or vim.api.nvim_win_get_tabpage(current) ~= vim.api.nvim_get_current_tabpage() then
        return
      end
    else
      split_active_win = current
    end
    local colors = split_palette()
    local active = split_bounds(current)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(win).relative == '' then
        local bounds = split_bounds(win)
        -- Neovim draws a separator with the left/upper window's highlight.
        local touches_active = win == current
          or (bounds.right == active.left - 1
            and bounds.top < active.bottom and bounds.bottom > active.top)
          or (bounds.bottom == active.top - 1
            and bounds.left < active.right and bounds.right > active.left)
        local highlights = {}
        for entry in vim.wo[win].winhighlight:gmatch('[^,]+') do
          if not entry:match('^WinSeparator:DotfilesSplit') then
            table.insert(highlights, entry)
          end
        end
        if colors then
          for i = #highlights, 1, -1 do
            if highlights[i]:match('^WinSeparator:') then table.remove(highlights, i) end
          end
          table.insert(highlights, 'WinSeparator:'
            .. (split_focused and touches_active and 'DotfilesSplitActive' or 'DotfilesSplitInactive'))
        end
        local value = table.concat(highlights, ',')
        if vim.wo[win].winhighlight ~= value then
          vim.wo[win].winhighlight = value
        end
      end
    end
  end
  local split_group = vim.api.nvim_create_augroup('DotfilesSplitBorders', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = split_group,
    callback = function()
      local colors = split_palette()
      if colors then
        vim.api.nvim_set_hl(0, 'DotfilesSplitInactive', { fg = colors.inactive, bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'DotfilesSplitActive',   { fg = colors.active,   bg = 'NONE' })
      end
      update_split_highlights()
    end,
  })
  -- SafeState also catches window moves that change positions but not dimensions.
  vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'TabEnter', 'WinResized', 'SafeState' }, {
    group = split_group,
    callback = update_split_highlights,
  })
  vim.api.nvim_create_autocmd('WinClosed', {
    group = split_group,
    callback = function() vim.schedule(update_split_highlights) end,
  })
  vim.api.nvim_create_autocmd({ 'FocusGained', 'FocusLost' }, {
    group = split_group,
    callback = function(event)
      split_focused = event.event == 'FocusGained'
      update_split_highlights()
    end,
  })
end

-- The saved theme in plugin/last-used-colorscheme.vim overrides this fallback.
vim.cmd('silent! colorscheme kanagawa-wave')

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('SaveColorscheme', { clear = true }),
  callback = function()
    local plugin_dir  = vim.fn.stdpath('config') .. '/plugin'
    local last_used   = plugin_dir .. '/last-used-colorscheme.vim'
    vim.fn.mkdir(plugin_dir, 'p')
    vim.fn.writefile({ 'silent! colorscheme ' .. vim.g.colors_name }, last_used)
  end,
})

--- END COLORSCHEME SETTINGS }}}
--- INDENT BEHAVIOR {{{

vim.o.expandtab   = true
vim.o.shiftround  = true
vim.o.shiftwidth  = 4
vim.o.softtabstop = 4
vim.o.tabstop     = 4

vim.api.nvim_create_user_command('Indent', function(args)
  local n = tonumber(args.args)
  vim.o.shiftwidth  = n
  vim.o.softtabstop = n
  vim.o.tabstop     = n
end, { nargs = 1 })

--- END INDENT BEHAVIOR }}}
--- SEARCH BEHAVIOR {{{

vim.o.hlsearch   = true
vim.o.ignorecase = true
vim.o.smartcase  = true

--- END SEARCH BEHAVIOR }}}
--- NORMAL MODE BEHAVIOR {{{

vim.keymap.set('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true, silent = true })
vim.keymap.set('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true, silent = true })
vim.keymap.set('n', '$', 'g$', { silent = true })
vim.keymap.set('n', '0', 'g^', { silent = true })
vim.keymap.set('n', "'", '`')

do
  local navigator = {
    ['<C-h>'] = { 'TmuxNavigateLeft',  'h' },
    ['<C-j>'] = { 'TmuxNavigateDown',  'j' },
    ['<C-k>'] = { 'TmuxNavigateUp',    'k' },
    ['<C-l>'] = { 'TmuxNavigateRight', 'l' },
  }
  local function navigate(command, direction)
    if vim.fn.exists(':' .. command) == 2 then vim.cmd(command)
    else vim.cmd.wincmd(direction) end
  end
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('DotfilesNavigator', { clear = true }),
    callback = function()
      if vim.fn.exists(':TmuxNavigateLeft') == 2 then return end
      for key, target in pairs(navigator) do
        local command, direction = target[1], target[2]
        vim.keymap.set('n', key, function() navigate(command, direction) end, { silent = true })
      end
      for key, target in pairs(navigator) do
        local direction = target[2]
        vim.keymap.set('t', key, function()
          if vim.bo.filetype == 'fzf' then return key end
          return '<C-\\><C-n><C-w>' .. direction
        end, { expr = true, silent = true })
      end
    end,
  })
end

--- END NORMAL MODE BEHAVIOR }}}
--- VISUAL MODE BEHAVIOR {{{

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '=', '=gv')

vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
  group = vim.api.nvim_create_augroup('HighlightFollowsFocus', { clear = true }),
  callback = function() vim.o.cursorline = true end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
  group = vim.api.nvim_create_augroup('HighlightFollowsFocus', {}),
  callback = function() vim.o.cursorline = false end,
})

vim.o.number         = true
vim.o.relativenumber = true

vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
  group = vim.api.nvim_create_augroup('SmartNumbers', { clear = true }),
  callback = function()
    if vim.o.number then vim.o.relativenumber = true end
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
  group = vim.api.nvim_create_augroup('SmartNumbers', {}),
  callback = function()
    if vim.o.number then vim.o.relativenumber = false end
  end,
})

vim.o.showbreak = '↪ '
vim.o.list      = true
vim.opt.listchars = { tab = '» ', trail = '•', nbsp = '␣', precedes = '⟨', extends = '⟩' }

--- END VISUAL BEHAVIOR }}}
--- FOLD BEHAVIOR {{{

vim.o.foldmethod = 'marker'
vim.opt.foldopen:append('jump')

--- END FOLD BEHAVIOR }}}
--- WINDOW BEHAVIOR {{{

vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.fillchars:append({ vert = '┃', horiz = '━', horizup = '┻', horizdown = '┳',
  vertleft = '┫', vertright = '┣', verthoriz = '╋' })

--- END WINDOW BEHAVIOR }}}
--- COMMAND LINE BEHAVIOR {{{

vim.o.wildmode = 'longest:list,full'
vim.o.wildignorecase = true

do
  local function sudo_write()
    local name = vim.fn.bufname('%')
    if name == '' or vim.bo.buftype ~= '' then
      error('SudoWrite requires a named file buffer')
    end
    vim.cmd('write !sudo tee -- ' .. vim.fn.shellescape(vim.fn.expand('%:p'), 1) .. ' >/dev/null')
    if vim.v.shell_error ~= 0 then
      error('SudoWrite failed; buffer has not been marked saved')
    end
    vim.bo.modified = false
  end
  vim.api.nvim_create_user_command('SudoWrite', sudo_write, {})
  vim.cmd("cnoreabbrev <expr> w!! getcmdtype() ==# ':' && getcmdline() ==# 'w!!' ? 'SudoWrite' : 'w!!'")
end

vim.cmd("cabbr <expr> %% expand('%:p:h')")

--- END COMMAND LINE BEHAVIOR }}}
--- LEADER KEY BEHAVIOR {{{

vim.g.mapleader = ','
vim.keymap.set('n', '<leader>,', ',')
vim.g.tmux_navigator_disable_when_zoomed = 1

local has_fzf = vim.fn.executable('fzf') == 1

if has_fzf then
  vim.keymap.set('n', '<leader>b',  '<cmd>FzfLua buffers<cr>',   { silent = true })
  vim.keymap.set('n', '<leader>f',  '<cmd>FzfLua files<cr>',     { silent = true })
  vim.keymap.set('n', '<leader>t',  '<cmd>FzfLua tags<cr>',      { silent = true })
  vim.keymap.set('n', '<leader>gf', '<cmd>FzfLua git_files<cr>', { silent = true })
else
  vim.keymap.set('n', '<leader>b', ':b <C-d>',    {})
  vim.keymap.set('n', '<leader>f', ':find *',     {})
  vim.keymap.set('n', '<leader>t', ':tjump /',    {})
end

vim.keymap.set('n', '<leader>c', '<cmd>Bdelete<cr>', { silent = true })
vim.keymap.set('n', '<leader>e', ':e **/*',   {})
vim.keymap.set('n', '<leader>m', '<cmd>make<cr>',    { silent = true })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>',    { silent = true })
vim.keymap.set('n', '<leader>z', '<cmd>b#<cr>',      { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>',   { silent = true })
vim.keymap.set({'n', 'x'}, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')

vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>',                  { silent = true })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>',         { silent = true })
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>',        { silent = true })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { silent = true })
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>',            { silent = true })
vim.keymap.set('n', '<leader>gl', '<cmd>Git log<cr>',              { silent = true })

if has_fzf and vim.fn.executable('rg') == 1 then
  vim.keymap.set('n', '<leader>/',  '<cmd>FzfLua live_grep<cr>',   { silent = true })
  vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>',  { silent = true })
else
  vim.keymap.set('n', '<leader>/', ':grep<space>', {})
end

--- END LEADER KEY BEHAVIOR }}}
--- GREP AND VIMGREP BEHAVIOR {{{

if vim.fn.executable('rg') == 1 then
  vim.o.grepprg    = 'rg --vimgrep --smart-case $*'
  vim.o.grepformat = '%f:%l:%c:%m'
end

--- END GREP AND VIMGREP BEHAVIOR }}}
--- BUFFER SPECIFIC BEHAVIOR {{{

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('FileTypeSpell', { clear = true }),
  pattern = { 'markdown', 'gitcommit', 'todo' },
  callback = function() vim.o.spell = true end,
})

vim.api.nvim_create_autocmd('BufWrite', {
  group = vim.api.nvim_create_augroup('AdditionalFileTypeCommands', { clear = true }),
  pattern = { '*.py', '*.coffee' },
  command = 'StripTrailingWhitespaces',
})
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('AdditionalFileTypeCommands', {}),
  pattern = { 'c', 'cpp', 'cs', 'java' },
  callback = function() vim.o.commentstring = '// %s' end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('LastBufferPosition', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('AutomaticQuickFix', { clear = true }),
  pattern = '[^l]*',
  command = 'cwindow',
})
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('AutomaticQuickFix', {}),
  pattern = 'l*',
  command = 'lwindow',
})

--- END BUFFER SPECIFIC BEHAVIOR }}}
--- CODE COMPLETION BEHAVIOR {{{

vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.o.updatetime    = 300
vim.opt.shortmess:append('c')

--- END CODE COMPLETION BEHAVIOR }}}
--- FORMATTER {{{

require('conform').setup({
  formatters_by_ft = {
    c      = { 'clang_format' },
    cpp    = { 'clang_format' },
    rust   = { 'rustfmt' },
    python = { 'ruff_format', 'ruff_organize_imports' },
    lua    = { 'stylua' },
    typst  = { 'typstyle' },
  },
  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = function()
    if vim.g.disable_autoformat then return end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
})
vim.keymap.set('n', '<leader>uf', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify('Format on save ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
end, { desc = 'Format on save' })
vim.keymap.set('n', '<leader>lf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { silent = true, desc = 'Format buffer' })

--- END FORMATTER }}}
--- LSP CONFIGURATION {{{

require('blink.cmp').setup({
  keymap = {
    preset  = 'none',
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<CR>']  = { 'accept', 'fallback' },
    ['<Tab>'] = { 'accept', 'fallback' },
    ['<C-e>'] = { 'hide' },
  },
  completion = { ghost_text = { enabled = true } },
  signature  = { enabled = true },
  sources    = { default = { 'lsp', 'path', 'snippets' } },
})

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.diagnostic.config({
  virtual_text      = true,
  signs             = true,
  update_in_insert  = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspMappings', { clear = true }),
  callback = function(event)
    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,    opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,     opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover,          opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references,     opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1  }) end, opts)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename,          opts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action,     opts)
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float,   opts)
    vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist,   opts)
  end,
})

vim.lsp.enable('basedpyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('tinymist')

--- END LSP CONFIGURATION }}}
