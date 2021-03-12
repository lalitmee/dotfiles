local buf_map = require('utils').buf_map
local buf_option = require('utils').buf_option
local telescope_mapper = require('config.telescope.mappings')
local _ = require('config.lsp.handlers')

local function on_attach(_)
  local opts = { noremap = true, silent = true }
  buf_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_map('n', '<leader>Fa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_map('n', '<leader>Fr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_map('n', '<leader>Fl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_map('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_map('n', 'grr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_map('n', 'gel', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false })<CR>', opts)
  buf_map('n', 'gep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_map('n', 'gen', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_map('n', 'geq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_map('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', { expr = true, noremap = true })
  buf_map('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', { expr = true, noremap = true })
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- telescope mappings
  local telescope_opts = { prompt_position = 'top' }
  telescope_mapper('gra', 'lsp_code_actions', telescope_opts, true)
  telescope_mapper('grd', 'lsp_document_symbols', telescope_opts, true)
  telescope_mapper('grr', 'lsp_references', telescope_opts, true)
  telescope_mapper('grs', 'lsp_workspace_symbols', telescope_opts, true)
  telescope_mapper('grw', 'symbols', telescope_opts, true)

end

return on_attach
