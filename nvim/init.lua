-- vim: foldmethod=marker

--- OPTIONS {{{
do
    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    -- Set comma as the leader key
    --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
    vim.g.mapleader = ','
    vim.g.maplocalleader = ','

    -- Make line numbers default and add relative
    vim.o.number         = true
    vim.o.relativenumber = true

    -- Enable mouse mode, can be useful for resizing splits for example!
    vim.o.mouse = 'a'

    -- Don't show the mode, since it's already in the status line
    vim.o.showmode  = false

    -- Sync clipboard between OS and Neovim.
    vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

    -- Enable undo/redo changes even after closing and reopening a file
    vim.o.undofile = true

    -- Keep signcolumn on by default
    vim.o.signcolumn = 'yes'

    -- Decrease update time
    vim.o.updatetime = 300

    -- Decrease mapped sequence wait time
    vim.o.timeoutlen = 300

    -- Configure how new splits should be opened
    vim.o.splitright = true
    vim.o.splitbelow = true

    -- Sets how neovim will display certain whitespace characters in the editor.
    vim.o.list = true
    -- TODO: Change?
    -- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
    vim.opt.listchars = { tab = '» ', trail = '•', nbsp = '␣', precedes = '⟨', extends = '⟩' }

    -- Preview substitutions live, as you type!
    -- TODO: Change?
    vim.o.inccommand = 'split'

    -- Show which line your cursor is on
    vim.o.cursorline = true

    -- Minimal number of screen lines to keep above and below the cursor.
    vim.o.scrolloff = 5
    vim.o.sidescrolloff = 2

    -- If performing an operation that would fail due to unsaved changes raise a dialog asking if you wish to save the current file(s)
    vim.o.confirm = true

    -- Case-insensitive searching
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Highlight search
    vim.o.hlsearch = true

    --
    -- Indentation behavior
    --
    vim.o.expandtab = true
    vim.o.shiftround = true
    vim.o.shiftwidth = 4
    vim.o.softtabstop = 4
    vim.o.tabstop = 4

    vim.api.nvim_create_user_command('Indent', function(args)
        local n = tonumber(args.args)
        if not n or n <= 0 or n % 1 ~= 0 then
            error('Indent requires a positive integer')
        end
        vim.bo.shiftwidth = n
        vim.bo.softtabstop = n
        vim.bo.tabstop = n
    end, { nargs = 1 })

    -- Enable break indent
    vim.o.breakindent = true

    -- Enable break character display
    vim.o.showbreak = '↪ '

    -- FOLD BEHAVIOR
    vim.o.foldmethod = 'marker'
    vim.opt.foldopen:append('jump')

    --
    -- WINDOW BEHAVIOR
    --
    vim.opt.fillchars:append({ vert = '┃', horiz = '━', horizup = '┻', horizdown = '┳',
        vertleft = '┫', vertright = '┣', verthoriz = '╋' })

    -- [ Format options ]
    -- Recognize numbered lists when joining lines
    vim.opt.formatoptions:append('n')

    -- ctags from git dir or project root
    vim.opt.tags:prepend('./.git/tags;')

    -- Complete files and directories without regard to case
    vim.o.wildignorecase = true

    --
    -- SudoWrite function
    --
    do
        local function sudo_write()
            local name = vim.fn.bufname('%')
            if name == '' or vim.bo.buftype ~= '' then
                error('SudoWrite requires a named file buffer')
            end
            vim.cmd('write !sudo tee -- ' .. vim.fn.shellescape(vim.fn.expand('%:p'), true) .. ' >/dev/null')
            if vim.v.shell_error ~= 0 then
                error('SudoWrite failed; buffer has not been marked saved')
            end
            vim.bo.modified = false
        end
        vim.api.nvim_create_user_command('SudoWrite', sudo_write, {})
        vim.cmd("cnoreabbrev <expr> w!! getcmdtype() ==# ':' && getcmdline() ==# 'w!!' ? 'SudoWrite' : 'w!!'")
    end

    -- Abbreviation for current folder in commandline
    vim.cmd("cabbr <expr> %% expand('%:p:h')")

    -- Cursor shape per mode.
    -- Non-blinking: steady block in normal/visual, bar in insert, underline in replace.
    -- Blinking in insert mode (700 ms delay before first blink, 400 ms on, 250 ms off).
    vim.o.guicursor = 'n-v-c:block,i-ci-ve:ver40-blinkwait700-blinkon400-blinkoff250,r-cr:hor20,o:hor50'
    vim.opt.display:append('truncate')
    vim.o.termguicolors = true

end

--- END OPTIONS }}}
--- PLUGINS SETUP {{{

--- Because most plugins are hosted on GitHub, you can use the helper
--- function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

do
    local function run_build(name, cmd, cwd)
        local result = vim.system(cmd, { cwd = cwd }):wait()
        if result.code ~= 0 then
            local output = result.stderr or ''
            if output == '' then output = result.stdout or '' end
            if output == '' then output = 'No output from build command.' end
            vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
        end
    end

    -- This autocommand runs after a plugin is installed or updated and
    --  runs the appropriate build command for that plugin if necessary.
    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local name = ev.data.spec.name
            local kind = ev.data.kind
            if kind ~= 'install' and kind ~= 'update' then return end

            if name == 'LuaSnip' then
                if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
                    run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
                end
                return
            end

            if name == 'nvim-treesitter' then
                if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
                vim.cmd 'TSUpdate'
                return
            end
        end,
    })
end

--- END PLUGINS SETUP }}}
--- KEYMAPS & AUTOCMDS {{{

do
    local function diagnostic_text_enabled(bufnr)
        local enabled = vim.b[bufnr].diagnostic_virtual_text
        if enabled ~= nil then return enabled end
        return vim.bo[bufnr].filetype ~= 'markdown'
    end

    vim.diagnostic.config {
        update_in_insert  = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },

        virtual_text = function(_, bufnr) return diagnostic_text_enabled(bufnr) end,

        -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
        jump = {
            on_jump = function(_, bufnr)
                vim.diagnostic.open_float {
                    bufnr = bufnr,
                    scope = 'cursor',
                    focus = false,
                }
            end,
        },
    }

    -- Highlight when yanking (copying) text
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
        callback = function() vim.hl.on_yank() end,
    })

    vim.keymap.set('n', '<leader>,', ',', { desc = 'Repeat character motion backward' })

    vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { silent = true, desc = '[Q]uit this buffer' })
    vim.keymap.set('n', '<leader>z', '<cmd>b#<cr>',      { silent = true, desc = 'Switch to alternate buffer' })
    vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { silent = true, desc = '[W]rite this buffer' })

    -- vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>',                  { silent = true })
    -- vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>',         { silent = true })
    -- vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>',        { silent = true })
    -- vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>',            { silent = true })
    -- vim.keymap.set('n', '<leader>gl', '<cmd>Git log<cr>',              { silent = true })

    --
    -- When changing indentation, stay in visual mode if applicable
    --
    vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and keep selection' })
    vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and keep selection' })
    vim.keymap.set('v', '=', '=gv', { desc = 'Reindent and keep selection' })

    --
    -- Toggle wrapping, spell checking, and diagnostic text through leader shortcuts
    --
    vim.keymap.set('n', '<leader>tw', function() vim.wo.wrap = not vim.wo.wrap end, { desc = '[T]oggle [W]rap' })
    vim.keymap.set('n', '<leader>ts', function() vim.wo.spell = not vim.wo.spell end, { desc = '[T]oggle [S]pell checking' })
    vim.keymap.set('n', '<leader>td', function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr].diagnostic_virtual_text = not diagnostic_text_enabled(bufnr)
        vim.diagnostic.show(nil, bufnr)
    end, { desc = '[T]oggle [D]iagnostic text' })

    --
    -- Cursorline setting follows window focus
    --
    local highlight_group = vim.api.nvim_create_augroup('HighlightFollowsFocus', { clear = true })
    vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
        desc = "Cursorline when window is active",
        group = highlight_group,
        callback = function() vim.wo.cursorline = true end,
    })
    vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
        desc = "No cursorline when window is inactive",
        group = highlight_group,
        callback = function() vim.wo.cursorline = false end,
    })

    --
    -- Relativenumber setting follows window focus
    --
    local numbers_group = vim.api.nvim_create_augroup('SmartNumbers', { clear = true })
    vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
        group = numbers_group,
        callback = function() vim.wo.relativenumber = vim.wo.number end,
    })
    vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
        group = numbers_group,
        callback = function() vim.wo.relativenumber = false end,
    })

    --
    -- Enable automatic spell checking
    --
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('FileTypeSpell', { clear = true }),
        pattern = { 'markdown', 'gitcommit', 'todo' },
        callback = function() vim.o.spell = true end,
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
end

--- END KEYMAPS & AUTOCMDS }}}
--- UI & CORE PLUGINS {{{

do
    --
    -- mini.nvim: A collection of various small independent plugins/modules
    --
    vim.pack.add { gh 'nvim-mini/mini.nvim' }

    -- Support for pairs
    require('mini.pairs').setup()

    -- Toggle bracketed arguments between single-line and multiline layouts.
    require('mini.splitjoin').setup()

    -- Support for icons
    require('mini.icons').setup()
    require('mini.icons').mock_nvim_web_devicons()

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
        mappings = {
            around_next = 'aa',
            inside_next = 'ii',
        },
        n_lines = 500,
    }

    -- Easier navigation with brackets
    require('mini.bracketed').setup()

    -- Preserves window layout when deleting/wiping buffers (replaces vim-bbye)
    local bufremove = require('mini.bufremove')
    bufremove.setup  { silent = true }

    -- Close buffer, keep window split (equivalent to :Bdelete)
    vim.keymap.set('n', '<leader>c', function() bufremove.delete(0, false) end, { desc = '[C]lose buffer (keep layout)' })
    -- TODO: Consider adding a command abbreviation for :bd to call bufremove.delete(0, false). Maybe add :bd! for a forced bufremove as well

    --
    -- Statusline configuration
    --
    vim.pack.add { gh 'nvim-lualine/lualine.nvim' }
    require('lualine').setup {
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
                { 'diagnostics', sources = { 'nvim_diagnostic' } },
                'filetype',
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
    }

    --
    -- Smarter split pane management
    --
    -- TODO: Consider Alt+h/j/k/l for resizing
    vim.pack.add {
        gh 'smart-splits-nvim/smart-splits.nvim',
        gh 'smart-splits-nvim/backend-tmux',
    }

    require('smart-splits').setup {
        mux = {
            backend = 'smart-splits-backend-tmux'
        }
    }

    local ss = require('smart-splits')
    vim.keymap.set('n', '<C-h>', ss.move_cursor_left, { desc = 'Move to left split or tmux pane' })
    vim.keymap.set('n', '<C-j>', ss.move_cursor_down, { desc = 'Move to lower split or tmux pane' })
    vim.keymap.set('n', '<C-k>', ss.move_cursor_up, { desc = 'Move to upper split or tmux pane' })
    vim.keymap.set('n', '<C-l>', ss.move_cursor_right, { desc = 'Move to right split or tmux pane' })

    --
    -- gitsigns: Adds git related signs to the gutter
    --
    vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
    local gitsigns = require 'gitsigns'
    gitsigns.setup({
        on_attach = function(bufnr)
            -- Navigation
            vim.keymap.set('n', ']g', function()
                gitsigns.nav_hunk 'next'
            end, { desc = 'Next [G]it Change', buf = bufnr })

            vim.keymap.set('n', '[g', function()
                gitsigns.nav_hunk 'prev'
            end, { desc = 'Previous [G]it Change', buf = bufnr })

            -- Visual mode actions
            vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[S]tage Git [H]unk selection', buf = bufnr })
            vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[R]eset Git [H]unk selection', buf = bufnr })
            -- Normal mode actions
            vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[S]tage Git [H]unk', buf = bufnr })
            vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[R]eset Git [H]unk', buf = bufnr })
            vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage Git buffer', buf = bufnr })
            vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset Git buffer', buf = bufnr })
            vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[P]review Git [H]unk', buf = bufnr })
            vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview Git [H]unk [I]nline', buf = bufnr })
            vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'Git [B]lame line', buf = bufnr })
            vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [D]iff against index', buf = bufnr })
            vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'Git [D]iff against parent commit', buf = bufnr })
            vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'Git [H]unks to [Q]uickfix (repository)', buf = bufnr })
            vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { desc = 'Git [H]unks to [Q]uickfix (current file)', buf = bufnr })
            -- Toggles
            vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle Git line [B]lame', buf = bufnr })
            vim.keymap.set('n', '<leader>ti', gitsigns.toggle_word_diff, { desc = '[T]oggle Git [I]ntra-line diff', buf = bufnr })
            -- Text object
            vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = '[I]nside Git [H]unk', buf = bufnr })
        end,
    })

    --
    -- Highlight todo, notes, etc in comments
    --
    vim.pack.add { gh 'folke/todo-comments.nvim' }
    require('todo-comments').setup()

    --
    -- Surround keybinding support
    --
    -- Keep visual gS for mini.splitjoin; restore only ordinary visual surround.
    vim.g.nvim_surround_no_visual_mappings = true
    vim.pack.add { gh 'kylechui/nvim-surround' }
    require('nvim-surround').setup()
    vim.keymap.set('x', 'S', '<Plug>(nvim-surround-visual)', { desc = 'Add surrounding characters' })

    --
    -- Add indentation guides even on blank lines
    --
    vim.pack.add { gh 'lukas-reineke/indent-blankline.nvim' }
    require('ibl').setup()

    --
    -- File Navigation & Buffer-based Editing (oil.nvim)
    --
    vim.pack.add { gh 'stevearc/oil.nvim' }
    require('oil').setup {
        default_file_explorer = true,
        view_options = { show_hidden = true },
    }
    vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

    --
    -- Automatic highlight of word under cursor
    --
    vim.pack.add { gh 'RRethy/vim-illuminate' }
    require('illuminate').configure()

    --
    -- Diffview:
    --
    vim.pack.add { gh 'sindrets/diffview.nvim' }
    require('diffview').setup { use_icons = true }

    --
    -- Markview:
    --
    vim.pack.add { gh 'OXY2DEV/markview.nvim' }
    require('markview').setup()

    --
    -- vim-cool: Smarter highlighting support
    --
    vim.pack.add { gh 'romainl/vim-cool' }

end

--- END UI & CORE PLUGINS }}}
--- WHICH-KEY CONFIGURATION {{{

do
    vim.pack.add { gh 'folke/which-key.nvim' }

    require('which-key').setup {
        -- Delay between pressing a key and opening which-key (milliseconds)
        delay = 0,
        icons = { mappings = true },
    }
    require('which-key').add({
        { '<leader>g', group = '[G]it' },
        { '<leader>h', group = 'Git [H]unks', mode = { 'n', 'x' } },
        { '<leader>l', group = '[L]SP' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { 'g', group = 'Go to / actions', mode = { 'n', 'x', 'o' } },
        { 'gr', group = 'LSP Actions', mode = { 'n', 'x' } },
        { '[', group = 'Previous', mode = { 'n', 'x', 'o' } },
        { ']', group = 'Next', mode = { 'n', 'x', 'o' } },
    })

end

--- END WHICH-KEY CONFIGURATION }}}
--- COLORSCHEME PLUGINS {{{

do
    vim.pack.add {
        gh 'sainnhe/gruvbox-material',
        gh 'sainnhe/sonokai',
        gh 'rebelot/kanagawa.nvim',
        gh 'folke/tokyonight.nvim'
    }

    -- Enable default colorscheme
    vim.cmd.colorscheme 'kanagawa-wave'

    -- Dark background by default
    vim.o.background  = 'dark'

    -- Gruvbox material
    vim.g.gruvbox_material_background    = 'hard'
    vim.g.gruvbox_material_foreground    = 'original'
    vim.g.gruvbox_material_enable_bold   = 1
    vim.g.gruvbox_material_enable_italic = 1

    -- Sonokai
    vim.g.sonokai_style          = 'shusia'
    vim.g.sonokai_enable_italic  = 1

    --
    -- [ Colorful winsep ]
    -- Enable colorful window separators
    --
    vim.pack.add { gh 'nvim-zh/colorful-winsep.nvim' }
    require('colorful-winsep').setup { animate = { enabled = false } }

end

--- END COLORSCHEME SETTINGS }}}
--- SEARCH & NAVIGATION PLUGINS {{{

do
    -- Enable ripgrep usage within vim
    vim.o.grepprg    = 'rg --vimgrep --smart-case $*'
    vim.o.grepformat = '%f:%l:%c:%m'

    --
    -- Fzf-Lua:
    --
    vim.pack.add { gh 'ibhagwan/fzf-lua' }
    require('fzf-lua').setup {
        files = {
            fzf_opts = {
                ['--scheme'] = 'default',
            },
        },
    }

    vim.keymap.set('n', '<leader>b',  '<cmd>FzfLua buffers<cr>', { silent = true, desc = 'Find [B]uffers' })
    vim.keymap.set('n', '<leader>f',  '<cmd>FzfLua files<cr>', { silent = true, desc = '[F]ind file' })
    vim.keymap.set('n', '<leader>gf', '<cmd>FzfLua git_files<cr>', { silent = true, desc = 'Find [G]it [F]iles' })

    vim.keymap.set('n', '<leader>/',  '<cmd>FzfLua live_grep<cr>', { silent = true, desc = 'Live grep' })
    vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua blines<cr>', { silent = true, desc = '[S]earch [B]uffer' })
    vim.keymap.set('n', '<leader>so', '<cmd>FzfLua lines<cr>', { silent = true, desc = '[S]earch [O]pen Buffers' })
    vim.keymap.set('n', '<leader>sd', '<cmd>FzfLua diagnostics_workspace<cr>', { silent = true, desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>st', '<cmd>FzfLua tags<cr>', { silent = true, desc = '[S]earch [T]ags' })
    vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>', { silent = true, desc = '[S]earch [W]ord under cursor' })
    vim.keymap.set('x', '<leader>sw', '<cmd>FzfLua grep_visual<cr>', { silent = true, desc = '[S]earch selected [W]ords' })

    --
    -- flash.nvim: Navigate with search labels
    --
    vim.pack.add { gh 'folke/flash.nvim' }
    require('flash').setup()
    vim.keymap.set({'n', 'x', 'o'}, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
    vim.keymap.set({'n', 'o'}, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter select' })

    -- TODO: Consider further extensions:
    --  - Search diagnostics
end

--- END SEARCH & NAVIGATION PLUGINS }}}
--- LSP CONFIGURATION {{{

do
    -- Useful status updates for LSP.
    vim.pack.add { gh 'j-hui/fidget.nvim' }
    require('fidget').setup {}

    vim.pack.add {
        gh 'neovim/nvim-lspconfig',
    }

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspMappings', { clear = true }),
        callback = function(event)
            local fzf = require('fzf-lua')
            vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Find references for the word under your cursor
            vim.keymap.set('n', 'grr', function() fzf.lsp_references({ jump1 = false }) end, { buffer = event.buf, silent = true, desc = '[G]oto [R]eferences' })

            -- Jump to the implementation of the word under your cursor
            vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = event.buf, silent = true, desc = '[G]oto [I]mplementation' })

            -- Jump to the definition of the word under your cursor
            vim.keymap.set('n', 'grd', fzf.lsp_definitions, { buffer = event.buf, silent = true, desc = '[G]oto [D]efinition' })

            -- Jump to the type of the word under your cursor
            vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = event.buf, silent = true, desc = '[G]oto [T]ype Definition' })

            -- Fuzzy find all the symbols in your current document
            vim.keymap.set('n', 'gO', function() fzf.lsp_document_symbols({ jump1 = false }) end, { buffer = event.buf, silent = true, desc = 'Open Document Symbols' })

            -- Fuzzy find all the symbols in your current workspace
            vim.keymap.set('n', 'gW', function() fzf.lsp_live_workspace_symbols({ jump1 = false }) end, { buffer = event.buf, silent = true, desc = 'Open Workspace Symbols' })

            -- TODO: To be used?
            -- vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = event.buf, silent = true, desc = '[R]e[n]ame symbol' })
            -- vim.keymap.set({ 'n', 'x' }, 'gra', function() fzf.lsp_code_actions({ jump1 = false, silent = true }) end, { buffer = event.buf, silent = true, desc = 'Code [A]ctions' })
            -- vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = event.buf, silent = true, desc = '[G]oto [D]eclaration' })
            -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = event.buf, silent = true, desc = 'Hover information' })

            -- vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { buffer = event.buf, silent = true, desc = '[L]SP: [D]iagnostics at cursor' })
            -- vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { buffer = event.buf, silent = true, desc = '[L]SP: Diagnostics to location list' })
        end,
    })

    vim.lsp.enable('basedpyright')

    vim.lsp.config('rust_analyzer', {
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = true,
                check = { command = 'clippy' },
            },
        },
    })
    vim.lsp.enable('rust_analyzer')
    vim.lsp.config('clangd', {
        cmd = { 'clangd', '--clang-tidy=false' },
    })
    vim.lsp.enable('clangd')
    vim.lsp.enable('tinymist')

    vim.lsp.config('lua_ls', {
        on_init = function(client)
            local root = client.config.root_dir
            if root and (vim.uv.fs_stat(root .. '/.luarc.json') or vim.uv.fs_stat(root .. '/.luarc.jsonc')) then
                return
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            })
        end,
    })
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ts_ls')

    vim.lsp.config('jsonls', {
        settings = {
            json = {
                validate = { enable = true },
                schemas = {
                    { fileMatch = { 'package.json' }, url = 'https://json.schemastore.org/package.json' },
                    { fileMatch = { 'tsconfig*.json', 'jsconfig.json' }, url = 'https://json.schemastore.org/tsconfig.json' },
                },
            },
        },
    })
    vim.lsp.enable('jsonls')

end

--- END LSP CONFIGURATION }}}
--- FORMATTING CONFIGURATION {{{

do
    --
    -- Formatter plugin for Neovim
    --
    vim.pack.add { gh 'stevearc/conform.nvim' }

    require('conform').setup {
        format_on_save = function(bufnr)
            -- Filetypes that will be autoformatted
            local enabled_filetypes = {
                python = true,
            }
            if enabled_filetypes[vim.bo[bufnr].filetype] then
                return { timeout_ms = 500 }
            else
                return nil
            end
        end,
        default_format_opts = { lsp_format = 'fallback' },
        -- External formatters specified
        formatters_by_ft = {
            c      = { 'clang_format' },
            cpp    = { 'clang_format' },
            rust   = { 'rustfmt' },
            python = { 'ruff_format', 'ruff_organize_imports' },
            lua    = { 'stylua' },
            typst  = { 'typstyle' },
            sh     = { 'shfmt' },
            bash   = { 'shfmt' },
            javascript      = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescript      = { 'prettier' },
            typescriptreact = { 'prettier' },
            json   = { 'prettier' },
            jsonc  = { 'prettier' },
        },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>lf', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

--- END FORMATTING CONFIGURATION }}}
--- LINT CONFIGURATION {{{

do
    vim.pack.add { gh 'mfussenegger/nvim-lint' }

    local lint = require('lint')

    -- Resolve ESLint from the buffer's ancestors, including monorepo dependencies.
    lint.linters.eslint.cmd = function()
        local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
        while dir do
            local command = dir .. '/node_modules/.bin/eslint'
            if vim.fn.executable(command) == 1 then return command end
            local parent = vim.fs.dirname(dir)
            if parent == dir then break end
            dir = parent
        end
        return 'eslint'
    end

    lint.linters_by_ft = {
        bash     = { 'shellcheck' },
        c        = { "clangtidy" },
        cpp      = { "clangtidy" },
        javascript      = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescript      = { 'eslint' },
        typescriptreact = { 'eslint' },
        markdown = { 'markdownlint' },
        python   = { 'ruff' },
        sh       = { 'shellcheck' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
            -- Only run the linter in buffers that you can modify in order to
            -- avoid superfluous noise, notably within the handy LSP pop-ups that
            -- describe the hovered symbol using Markdown.
            if not vim.bo.modifiable then return end
            local cwd
            if vim.tbl_contains(lint.linters_by_ft[vim.bo.filetype] or {}, 'eslint') then
                cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
            end
            lint.try_lint(nil, {
                cwd = cwd,
                filter = function(linter)
                    local command = type(linter.cmd) == 'function'
                        and linter.cmd() or linter.cmd
                    if vim.fn.executable(command) == 1 then return true end

                    vim.schedule(function()
                        vim.notify_once(
                            'Skipping linter: executable not found: ' .. command,
                            vim.log.levels.WARN
                        )
                    end)
                    return false
                end,
            })
        end,
    })
end

--- END LINT CONFIGURATION }}}
--- AUTOCOMPLETE & SNIPPETS {{{

do
    vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
    vim.opt.shortmess:append('c')

    --
    -- [[ Snipper Engine ]]
    --
    vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
    require('luasnip').setup {}

    -- `friendly-snippets` contains a variety of premade snippets.
    vim.pack.add { gh 'rafamadriz/friendly-snippets' }
    require('luasnip.loaders.from_vscode').lazy_load()

    --
    -- [[ Autocomplete Engine ]]
    --
    vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range('1.*') } }
    require('blink.cmp').setup({
        keymap = {
            -- 'default' (recommended) for mappings similar to built-in completions
            --   <c-y> to accept ([y]es) the completion.
            --    This will auto-import if your LSP supports it.
            --    This will expand snippets if the LSP sent a snippet.
            preset  = 'default',
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'normal',
        },

        completion = {
            ghost_text = { enabled = true },
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        sources = {
            default = { 'lsp', 'path', 'snippets' },
        },

        snippets = { preset = 'luasnip' },

        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- By default, we use the Lua implementation instead, but you may enable
        -- the rust implementation via `'prefer_rust_with_warning'`
        --
        -- See `:help blink-cmp-config-fuzzy` for more information
        fuzzy = { implementation = 'lua' },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
    })
end

--- END CODE COMPLETION BEHAVIOR }}}
--- TREESITTER {{{

do
    --
    -- [[ Configure Treesitter ]]
    --  Used to highlight, edit, and navigate code
    --
    vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }
        -- gh 'nvim-treesitter/nvim-treesitter-textobjects',
        -- gh 'nvim-treesitter/nvim-treesitter-context',

    local parsers = { 'bash', 'c', 'cpp', 'diff', 'html', 'javascript', 'json', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'rust', 'toml', 'tsx', 'typescript', 'typst', 'vim', 'vimdoc', }
    require('nvim-treesitter').install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
        -- Check if the buffer is valid (might not be after install completes)
        if not vim.api.nvim_buf_is_valid(buf) then return end

        -- Check if a parser exists and load it
        if not vim.treesitter.language.add(language) then return end

        -- Enable syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- Enable treesitter based folds
        -- For more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'

        -- Check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

        -- Enable treesitter based indentation
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end

    local available_parsers = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local buf, filetype = args.buf, args.match

            local language = vim.treesitter.language.get_lang(filetype)
            if not language then return end

            local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

            if vim.tbl_contains(installed_parsers, language) then
                -- Enable the parser if it is already installed
                treesitter_try_attach(buf, language)
            elseif vim.tbl_contains(available_parsers, language) then
                -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
                require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
            else
                -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                treesitter_try_attach(buf, language)
            end
        end,
    })
end

--- END TREESITTER }}}
