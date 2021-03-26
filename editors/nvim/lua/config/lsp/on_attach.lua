local lsp_status = require('lsp-status')
local buf_map = require('utils').buf_map
local buf_option = require('utils').buf_option
local telescope_mapper = require('config.telescope.mappings')
local _ = require('config.lsp.handlers')

local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  buf_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- buf native lsp key maps
  buf_map('i', '<C-h>', '<cmd>LspSignatureHelp<CR>', opts)
  buf_map('n', 'K', '<cmd>LspHover<CR>', opts)
  buf_map('n', 'gD', '<cmd>LspDeclaration<CR>', opts)

  -- diagnostics mappings
  buf_map('n', 'geN', '<cmd>LspGetNextDiagnostic<CR>', opts)
  buf_map('n', 'geP', '<cmd>LspGetPrevDiagnostic<CR>', opts)
  buf_map('n', 'gea', '<cmd>LspGetAllDiagnostics<CR>', opts)
  buf_map('n', 'gel', '<cmd>LspShowLineDiagnostics<CR>', opts)
  buf_map('n', 'gen', '<cmd>LspGotoNextDiagnostic<CR>', opts)
  buf_map('n', 'gep', '<cmd>LspGotoPrevDiagnostic<CR>', opts)
  buf_map('n', 'geq', '<cmd>LspSetDiagnosticsLocList<CR>', opts)

  -- formaaing mappings
  buf_map('n', 'gff', '<cmd>LspFormatting<CR>', opts)
  buf_map('n', 'gfs', '<cmd>LspFormattingSync<CR>', opts)

  -- workspace mappings
  buf_map('n', 'gi', '<cmd>LspImplementation<CR>', opts)
  buf_map('n', 'grc', '<cmd>LspClearReferences<CR>', opts)
  buf_map('n', 'grn', '<cmd>lua MyLspRename()<CR>', opts)
  buf_map('n', 'gy', '<cmd>LspTypeDefinition<CR>', opts)

  -- telescope mappings for lsp and more
  buf_map('n', 'gca', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_map('n', 'gcA', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
  buf_map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  buf_map('n', 'ge', '<cmd>Telescope lsp_document_diagnostics<CR>', opts)
  buf_map('n', 'gE', '<cmd>Telescope lsp_workspace_diagnostics<CR>', opts)
  buf_map('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_map('n', 'gw', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  -- buf_map('n', 'gW', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
  buf_map(
      'n', 'gW',
      '<cmd>lua require("config.telescope.lens").live_workspace_symbols()<CR>',
      opts
  )

  local telescope_opts = { prompt_position = 'top' }
  telescope_mapper('gta', 'lsp_code_actions', telescope_opts, true)
  telescope_mapper('gtA', 'lsp_range_code_actions', telescope_opts, true)
  telescope_mapper('gtd', 'lsp_definitions', telescope_opts, true)
  telescope_mapper('gte', 'lsp_document_diagnostics', telescope_opts, true)
  telescope_mapper('gtE', 'lsp_workspace_diagnostics', telescope_opts, true)
  telescope_mapper('gtr', 'lsp_references', telescope_opts, true)
  telescope_mapper('gtw', 'lsp_document_symbols', telescope_opts, true)
  telescope_mapper('gtW', 'lsp_workspace_symbols', telescope_opts, true)

  if client.resolved_capabilities.goto_definition then
    buf_map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  end
  if client.resolved_capabilities.code_action then
    vim.cmd [[augroup CodeAction]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd CursorHold * lua require'nvim-lightbulb'.update_lightbulb()]]
    vim.cmd [[augroup END]]
  end
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_map('n', 'gff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_map('n', 'gfr', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
        [[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false
    )
  end
end

return on_attach
