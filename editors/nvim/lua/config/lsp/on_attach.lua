local buf_map = require('utils').buf_map
local buf_option = require('utils').buf_option
local telescope_mapper = require('config.telescope.mappings')
local _ = require('config.lsp.handlers')

local function on_attach(_)
  local opts = { noremap = true, silent = true }
  buf_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- buf native lsp key maps
  buf_map('i', '<C-h>', '<cmd>LspSignatureHelp<CR>', opts)
  buf_map('n', 'K', '<cmd>LspHover<CR>', opts)
  buf_map('n', 'gd', '<cmd>LspDefinition<CR>', opts)
  buf_map('n', 'gD', '<cmd>LspDeclaration<CR>', opts)

  -- diagnostics mappings
  buf_map('n', 'geN', '<cmd>LspGetNextDiagnostic<CR>', opts)
  buf_map('n', 'geP', '<cmd>LspGetPrevDiagnostic<CR>', opts)
  buf_map('n', 'gea', '<cmd>LspGetAllDiagnostics<CR>', opts)
  buf_map('n', 'gel', '<cmd>LspShowLineDiagnostics<CR>', opts)
  buf_map('n', 'gen', '<cmd>LspGotoNextDiagnostic<CR>', opts)
  buf_map('n', 'gep', '<cmd>LspGotoPrevDiagnostic<CR>', opts)
  buf_map('n', 'geq', '<cmd>LspSetDiagnosticsLocList<CR>', opts)

  -- code actions mappings
  buf_map('n', 'gcA', '<cmd>LspRangeCodeActions<CR>', opts)
  buf_map('n', 'gca', '<cmd>LspCodeActions<CR>', opts)

  -- formaaing mappings
  buf_map('n', 'gff', '<cmd>LspFormatting<CR>', opts)
  buf_map('n', 'gfs', '<cmd>LspFormattingSync<CR>', opts)

  -- workspace mappings
  buf_map('n', 'gW', '<cmd> LspWorkspaceSymbols<CR>', opts)
  buf_map('n', 'gi', '<cmd> LspImplementation<CR>', opts)
  buf_map('n', 'gr', '<cmd> LspReferences<CR>', opts)
  buf_map('n', 'grc', '<cmd> LspClearReferences<CR>', opts)
  buf_map('n', 'grn', '<cmd> LspRename<CR>', opts)
  buf_map('n', 'gw', '<cmd> LspDocumentSymbols<CR>', opts)
  buf_map('n', 'gy', '<cmd> LspTypeDefinition<CR>', opts)

  -- telescope mappings
  local telescope_opts = { prompt_position = 'top' }
  telescope_mapper('gta', 'lsp_code_actions', telescope_opts, true)
  telescope_mapper('gtA', 'lsp_range_code_actions', telescope_opts, true)
  telescope_mapper('gtd', 'lsp_definitions', telescope_opts, true)
  telescope_mapper('gte', 'lsp_document_diagnostics', telescope_opts, true)
  telescope_mapper('gtE', 'lsp_workspace_diagnostics', telescope_opts, true)
  telescope_mapper('gtr', 'lsp_references', telescope_opts, true)
  telescope_mapper('gtw', 'lsp_document_symbols', telescope_opts, true)
  telescope_mapper('gtW', 'lsp_workspace_symbols', telescope_opts, true)

  -- commented key maps
  -- buf_map(
  --     'i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"',
  --     { expr = true, noremap = true }
  -- )
  -- buf_map(
  --     'i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"',
  --     { expr = true, noremap = true }
  -- )
end

return on_attach
