-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

-- Complextras.nvim configuration
vim.api.nvim_set_keymap(
    'i', '<C-x><C-m>',
    [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
    { noremap = true }
)
vim.api.nvim_set_keymap(
    'i', '<C-x><C-d>',
    [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
    { noremap = true }
)
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
      path = { kind = '  ' },
      buffer = { kind = '  ' },
      calc = { kind = '  ' },
      vsnip = { kind = '  ' },
      nvim_lsp = { kind = '  ' },
      nvim_lua = { kind = '  ' },
      spell = { kind = '  ' },
      tags = false,
      snippets_nvim = { kind = '  ' },
      ultisnips = { kind = '  ' },
      treesitter = { kind = '  ' },
      emoji = { kind = ' ﲃ ', filetypes = { 'markdown' } }
    }
  }
end
