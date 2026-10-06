-- Run from the repository root with:
-- nvim --headless -u NONE -i NONE -n -l nvim/tests/enter-mapping.lua
local plugin_dir = vim.fn.stdpath('data') .. '/plugged/'
vim.opt.runtimepath:append(plugin_dir .. 'auto-pairs')
vim.opt.runtimepath:append(plugin_dir .. 'blink.cmp')
vim.cmd.source(plugin_dir .. 'auto-pairs/plugin/auto-pairs.vim')

local init = table.concat(vim.fn.readfile('nvim/init.vim'), '\n')
local options = assert(init:match("require%('blink%.cmp'%)%.setup%((%b{})%)"), 'blink.cmp setup not found')
local config = assert(load('return ' .. options))()
local enter = config.keymap['<CR>']
assert(enter[1] == 'accept', 'Enter must still accept completions')
assert(type(enter[2]) == 'function', 'Enter must handle auto-pairs without blink fallback')

local function check(input, expected)
  vim.cmd('enew!')
  require('blink.cmp.keymap.apply').set('i', '<CR>', enter[2], 'blink.cmp: Accept')
  vim.api.nvim_feedkeys(vim.keycode('i' .. input .. '<Esc>'), 'xt', false)
  local actual = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  assert(vim.deep_equal(actual, expected), vim.inspect({ input = input, expected = expected, actual = actual }))
end

check('abc<CR>def', { 'abc', 'def' })
check('{<CR>', { '{', '', '}' })
print('Enter works with and without an auto-pair')
