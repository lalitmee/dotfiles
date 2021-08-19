local map = lk_utils.map

-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

local has_compe, compe = pcall(require, 'compe')
if has_compe then
  compe.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'always',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    allow_prefix_unmatch = false,

    source = {
      path = true,
      buffer = true,
      calc = true,
      vsnip = true,
      nvim_lsp = true,
      nvim_lua = true,
      spell = true,
      tags = false,
      snippets_nvim = true,
      ultisnips = true,
      tabnine = true,
      treesitter = true,
      emoji = true,
      vCard = true,
    },
  }
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
-- move to prev/next item in completion menuone
-- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn.call('vsnip#available', { 1 }) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn.call('vsnip#jumpable', { -1 }) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    return t '<S-Tab>'
  end
end

map('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
map('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
map('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
map('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })

-- NOTE: auto-pairs mapping <CR> for indentation inside html files
local npairs = require('nvim-autopairs')

vim.g.completion_confirm_key = ''
lk_utils.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()['selected'] ~= -1 then
      vim.fn['compe#confirm']()
      return npairs.esc('<c-y>')
    else
      vim.defer_fn(function()
        vim.fn['compe#confirm']('<cr>')
      end, 20)
      return npairs.esc('<c-n>')
    end
  else
    return npairs.check_break_line_char()
  end
end

map('i', '<CR>', 'v:lua.lk_utils.completion_confirm()',
    { expr = true, noremap = true })
