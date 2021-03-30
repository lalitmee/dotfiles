-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

-- Complextras.nvim configuration
vim.api.nvim_set_keymap('i', '<C-x><C-m>', [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]], {
  noremap = true
})
vim.api.nvim_set_keymap('i', '<C-x><C-d>', [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]], {
  noremap = true
})
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
      treesitter = true,
      emoji = true
    }
  }
end
