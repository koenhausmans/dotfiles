-- vim: foldmethod=marker

--- OPTIONS {{{
do
    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    -- Set <space> as the leader key
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
    vim.o.cursorline  = true

    -- Minimal number of screen lines to keep above and below the cursor.
    vim.o.scrolloff = 5
    vim.o.sidescrolloff = 2

    -- If performing an operation that would fail due to unsaved changes raise a dialog asking if you wish to save the current file(s)
    -- See `:help 'confirm'`
    vim.o.confirm = true

    -- Case-insensitive searching
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Highlight search
    vim.o.hlsearch   = true

    --
    -- Indentation behavior
    --
    vim.o.expandtab   = true
    vim.o.shiftround  = true
    vim.o.shiftwidth  = 4
    vim.o.softtabstop = 4
    vim.o.tabstop     = 4

    -- Enable break indent
    vim.o.breakindent = true

    -- Enable break character display
    vim.o.showbreak = '↪ '

    vim.api.nvim_create_user_command('Indent', function(args)
        local n = tonumber(args.args)
        vim.o.shiftwidth  = n
        vim.o.softtabstop = n
        vim.o.tabstop     = n
    end, { nargs = 1 })

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
            vim.cmd('write !sudo tee -- ' .. vim.fn.shellescape(vim.fn.expand('%:p'), 1) .. ' >/dev/null')
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
    -- This autocommand runs after a plugin is installed or updated and
    --  runs the appropriate build command for that plugin if necessary.
    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local name = ev.data.spec.name
            local kind = ev.data.kind
            if kind ~= 'install' and kind ~= 'update' then return end

            -- if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
            --     run_build(name, { 'make' }, ev.data.path)
            --     return
            -- end

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
    vim.diagnostic.config {
        update_in_insert  = false,
        severty_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },

        virtual_text = true, -- Text shows up at the end of the line

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

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

    -- Highlight when yanking (copying) text
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function() vim.hl.on_yank() end,
    })

    -- vim.keymap.set('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true, silent = true })
    -- vim.keymap.set('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true, silent = true })
    -- vim.keymap.set('n', '$', 'g$', { silent = true })
    -- vim.keymap.set('n', '0', 'g^', { silent = true })
    -- vim.keymap.set('n', "'", '`')

    vim.keymap.set('n', '<leader>,', ',')

    -- vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>',    { silent = true })
    vim.keymap.set('n', '<leader>z', '<cmd>b#<cr>',      { silent = true })
    -- vim.keymap.set('n', '<leader>w', '<cmd>write<cr>',   { silent = true })
    -- vim.keymap.set({'n', 'x'}, '<leader>y', '"+y')
    -- vim.keymap.set('n', '<leader>p', '"+p')

    -- vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>',                  { silent = true })
    -- vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>',         { silent = true })
    -- vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>',        { silent = true })
    -- vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>',            { silent = true })
    -- vim.keymap.set('n', '<leader>gl', '<cmd>Git log<cr>',              { silent = true })

    vim.keymap.set('v', '<', '<gv')
    vim.keymap.set('v', '>', '>gv')
    vim.keymap.set('v', '=', '=gv')

    -- vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
    --     group = vim.api.nvim_create_augroup('HighlightFollowsFocus', { clear = true }),
    --     callback = function() vim.o.cursorline = true end,
    -- })
    -- vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
    --     group = vim.api.nvim_create_augroup('HighlightFollowsFocus', {}),
    --     callback = function() vim.o.cursorline = false end,
    -- })
    --
    -- vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
    --     group = vim.api.nvim_create_augroup('SmartNumbers', { clear = true }),
    --     callback = function()
    --         if vim.o.number then vim.o.relativenumber = true end
    --     end,
    -- })
    -- vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
    --     group = vim.api.nvim_create_augroup('SmartNumbers', {}),
    --     callback = function()
    --         if vim.o.number then vim.o.relativenumber = false end
    --     end,
    -- })

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

    -- Clear search highlight on pressing <Esc> in normal mode
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
end


--- END KEYMAPS & AUTOCMDS }}}
--- UI & CORE PLUGINS {{{

do
    --
    -- mini.nvim: A collection of various small independent plugins/modules
    --
    vim.pack.add { gh 'nvim-mini/mini.nvim' }

    require('mini.pairs').setup()

    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()

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
    vim.keymap.set('n', '<leader>c', function() bufremove.delete(0, false) end, { desc = 'Delete buffer (keep layout)' })
    -- TODO: Consider adding a command abbreviation for :bd to call bufremove.delete(0, false)

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
    vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
    vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
    vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
    vim.keymap.set('n', '<C-l>', ss.move_cursor_right)

    --
    -- gitsigns: Adds git related signs to the gutter
    --
    vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
    local gitsigns = require 'gitsigns'
    gitsigns.setup({
        on_attach = function(bufnr)
            -- Navigation
            vim.keymap.set('n', ']c', function()
                if vim.wo.diff then
                    vim.cmd.normal { ']c', bang = true }
                else
                    gitsigns.nav_hunk 'next'
                end
            end, { desc = 'Jump to next git [c]hange', buf = bufnr })

            vim.keymap.set('n', '[c', function()
                if vim.wo.diff then
                    vim.cmd.normal { '[c', bang = true }
                else
                    gitsigns.nav_hunk 'prev'
                end
            end, { desc = 'Jump to previous git [c]hange', buf = bufnr })

            -- Visual mode actions
            vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk', buf = bufnr })
            vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk', buf = bufnr })
            -- Normal mode actions
            vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk', buf = bufnr })
            vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk', buf = bufnr })
            vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer', buf = bufnr })
            vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer', buf = bufnr })
            vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk', buf = bufnr })
            vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline', buf = bufnr })
            vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line', buf = bufnr })
            vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index', buf = bufnr })
            vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'git [D]iff against last commit', buf = bufnr })
            vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (all files in repo)', buf = bufnr })
            vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)', buf = bufnr })
            -- Toggles
            vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })
            vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })
            -- Text object
            vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'text object [i]nside [h]unk', buf = bufnr })
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
    vim.pack.add { gh 'kylechui/nvim-surround' }
    require('nvim-surround').setup()

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
    -- File Navigation & Buffer-based Editing (oil.nvim)
    --
    vim.pack.add { gh 'RRethy/vim-illuminate' }
    require('illuminate').configure()

    --
    -- Diffview: 
    --
    vim.pack.add { gh 'sindrets/diffview.nvim' }
    require'diffview'.setup { use_icons = true }

    --
    -- Markview: 
    --
    vim.pack.add { gh 'OXY2DEV/markview.nvim' }
    require('markview').setup()

end

--- END UI & CORE PLUGINS }}}
--- WHICH-KEY CONFIGURATION {{{

do
    vim.pack.add { gh 'folke/which-key.nvim' }

    require('which-key').setup {
        -- Delay between pressing a key and opening which-key (milliseconds)
        delay = 0,
        icons = { mappings = vim.g.have_nerd_font },
    }
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
        -- { '<leader>q',  desc = 'Quit window' },
        { '<leader>z',  desc = 'Alternate buffer' },
        -- { '<leader>w',  desc = 'Write' },
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
        -- Kanagawa reports "" for all three variants.
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

    -- The saved theme in plugin/last-used-colorscheme.vim overrides this fallback.
    vim.cmd.colorscheme 'kanagawa-wave'
end

--- END COLORSCHEME SETTINGS }}}
--- SEARCH & NAVIGATION PLUGINS {{{

-- TODO: Consider using telescope
do
    -- Enable ripgrep usage within vim
    vim.o.grepprg    = 'rg --vimgrep --smart-case $*'
    vim.o.grepformat = '%f:%l:%c:%m'

    vim.pack.add { gh 'ibhagwan/fzf-lua' }
    require('fzf-lua').setup()

    vim.keymap.set('n', '<leader>b',  '<cmd>FzfLua buffers<cr>',   { silent = true })
    vim.keymap.set('n', '<leader>f',  '<cmd>FzfLua files<cr>',     { silent = true })
    vim.keymap.set('n', '<leader>t',  '<cmd>FzfLua tags<cr>',      { silent = true })
    vim.keymap.set('n', '<leader>gf', '<cmd>FzfLua git_files<cr>', { silent = true })

    vim.keymap.set('n', '<leader>/',  '<cmd>FzfLua live_grep<cr>',   { silent = true })
    vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>',  { silent = true })

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

end

--- END LSP CONFIGURATION }}}
--- FORMATTING CONFIGURATION {{{

do
    vim.pack.add { gh 'stevearc/conform.nvim' }

    require('conform').setup {
        format_on_save = function(bufnr)
            -- Filetypes that will be autoformatted
            local enabled_filetypes = {
                lua = true,
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
        },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>lf', function() require('conform').format { async = true } end, { desc = "Format buffer" })
end

--- END FORMATTING CONFIGURATION }}}
--- LINT CONFIGURATION {{{

do
    vim.pack.add { gh 'mfussenegger/nvim-lint' }

    local lint = require('lint')

    lint.linters_by_ft = {
        bash     = { 'shellcheck' },
        c        = { "clangtidy" },
        cpp      = { "clangtidy" },
        json     = { 'jsonlint' },
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
            if vim.bo.modifiable then lint.try_lint() end
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

    local parsers = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'rust', 'toml', 'typst', 'vim', 'vimdoc', }
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
