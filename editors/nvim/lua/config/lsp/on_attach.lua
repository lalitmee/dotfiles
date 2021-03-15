local lsp_status = require('lsp-status')
local buf_map = require('utils').buf_map
local buf_option = require('utils').buf_option
local telescope_mapper = require('config.telescope.mappings')
local _ = require('config.lsp.handlers')

local function on_attach(client, bufnr)
  lsp_status.on_attach(client)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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

  -- these can be set from Telescope that's why commented out
  -- buf_map('n', 'gcA', '<cmd>LspRangeCodeActions<CR>', opts)
  -- buf_map('n', 'gca', '<cmd>LspCodeActions<CR>', opts)
  -- buf_map('n', 'gd', '<cmd>LspDefinition<CR>', opts)
  -- buf_map('n', 'gr', '<cmd> LspReferences<CR>', opts)
  -- buf_map('n', 'gw', '<cmd> LspDocumentSymbols<CR>', opts)
  buf_map('n', 'gW', '<cmd> LspWorkspaceSymbols<CR>', opts)

  -- formaaing mappings
  buf_map('n', 'gff', '<cmd>LspFormatting<CR>', opts)
  buf_map('n', 'gfs', '<cmd>LspFormattingSync<CR>', opts)

  -- workspace mappings
  buf_map('n', 'gi', '<cmd> LspImplementation<CR>', opts)
  buf_map('n', 'grc', '<cmd> LspClearReferences<CR>', opts)
  buf_map('n', 'grn', '<cmd> LspRename<CR>', opts)
  buf_map('n', 'gy', '<cmd> LspTypeDefinition<CR>', opts)

  -- telescope mappings for lsp and more
  buf_map('n', 'gca', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_map('n', 'gcA', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
  buf_map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  buf_map('n', 'ge', '<cmd>Telescope lsp_document_diagnostics<CR>', opts)
  buf_map('n', 'gE', '<cmd>Telescope lsp_workspace_diagnostics<CR>', opts)
  buf_map('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_map('n', 'gw', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  -- buf_map('n', 'gW', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)

  local telescope_opts = { prompt_position = 'top' }
  telescope_mapper('gta', 'lsp_code_actions', telescope_opts, true)
  telescope_mapper('gtA', 'lsp_range_code_actions', telescope_opts, true)
  telescope_mapper('gtd', 'lsp_definitions', telescope_opts, true)
  telescope_mapper('gte', 'lsp_document_diagnostics', telescope_opts, true)
  telescope_mapper('gtE', 'lsp_workspace_diagnostics', telescope_opts, true)
  telescope_mapper('gtr', 'lsp_references', telescope_opts, true)
  telescope_mapper('gtw', 'lsp_document_symbols', telescope_opts, true)
  telescope_mapper('gtW', 'lsp_workspace_symbols', telescope_opts, true)

  if client.resolved_capabilities.document_formatting then
    return true
  end
  if client.resolved_capabilities.goto_definition then
    buf_map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  end
  if client.resolved_capabilities.code_action then
    vim.cmd [[augroup CodeAction]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd CursorHold * lua require'nvim-lightbulb'.update_lightbulb()]]
    vim.cmd [[augroup END]]
  end
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[augroup Format]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd BufWritePost <buffer> lua formatting()]]
    vim.cmd [[augroup END]]
  end
end

return on_attach

-- -- NOTE: source: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/lsp.lua
-- vim.lsp.handlers['textDocument/formatting'] =
--     function(err, _, result, _, bufnr)
--       if err ~= nil or result == nil then
--         return
--       end
--       if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, bufnr)
--         vim.fn.winrestview(view)
--         if bufnr == vim.api.nvim_get_current_buf() then
--           vim.cmd [[noautocmd :update]]
--           -- vim.cmd [[GitGutter]]
--         end
--       end
--     end

-- local format_options_prettier = {
--   tabWidth = 4,
--   singleQuote = true,
--   trailingComma = 'all',
--   configPrecedence = 'prefer-file'
-- }
-- vim.g.format_options_typescript = format_options_prettier
-- vim.g.format_options_javascript = format_options_prettier
-- vim.g.format_options_typescriptreact = format_options_prettier
-- vim.g.format_options_javascriptreact = format_options_prettier
-- vim.g.format_options_json = format_options_prettier
-- vim.g.format_options_css = format_options_prettier
-- vim.g.format_options_scss = format_options_prettier
-- vim.g.format_options_html = format_options_prettier
-- vim.g.format_options_yaml = format_options_prettier
-- vim.g.format_options_markdown = format_options_prettier

-- FormatToggle = function(value)
--   vim.g[string.format('format_disabled_%s', vim.bo.filetype)] = value
-- end
-- vim.cmd [[command! FormatDisable lua FormatToggle(true)]]
-- vim.cmd [[command! FormatEnable lua FormatToggle(false)]]

-- _G.formatting = function()
--   if not vim.g[string.format('format_disabled_%s', vim.bo.filetype)] then
--     vim.lsp.buf.formatting(
--         vim.g[string.format('format_options_%s', vim.bo.filetype)] or {}
--     )
--   end
-- end
