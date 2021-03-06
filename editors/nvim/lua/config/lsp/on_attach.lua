local buf_map = require('utils').buf_map
local buf_option = require('utils').buf_option
local telescope_mapper = require('config.telescope.mappings')
local completion = require('completion')

require('config.lsp.handlers')

-- define an chain complete list
local chain_complete_list = {
  default = {
    { complete_items = { 'lsp', 'snippet' } },
    { complete_items = { 'path' }, triggered_only = { '/' } },
    { complete_items = { 'buffers' } }
  },
  string = { { complete_items = { 'path' }, triggered_only = { '/' } } },
  comment = {}
}

local function on_attach(client)
  completion.on_attach(
      {
        sorting = 'alphabet',
        matching_strategy_list = { 'exact', 'substring', 'fuzzy' },
        chain_complete_list = chain_complete_list
      }
  )
  -- buf_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_map('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_map('n', 'grn', '<cmd>lua MyLspRename()<CR>', opts)
  buf_map('n', '<leader>mr', '<cmd>lua MyLspRename()<CR>', opts)
  -- buf_map('n', 'grr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_map(
      'n', 'gle',
      '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false })<CR>',
      opts
  )
  buf_map('n', 'gep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_map('n', 'gen', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_map('n', 'glq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_map(
      'i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"',
      { expr = true, noremap = true }
  )
  buf_map(
      'i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"',
      { expr = true, noremap = true }
  )
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- telescope mappings
  telescope_mapper(
      'grr', 'lsp_references', {
        layout_strategy = 'vertical',
        sorting_strategy = 'ascending',
        prompt_position = 'top',
        ignore_filename = true
      }, true
  )

  -- TODO: I don't like these combos
  telescope_mapper(
      'grd', 'lsp_document_symbols', { ignore_filename = true }, true
  )
  telescope_mapper(
      'grw', 'lsp_workspace_symbols', { ignore_filename = true }, true
  )
  telescope_mapper(
      'grs', 'lsp_workspace_symbols', { ignore_filename = true, query = '#' },
      true
  )
  telescope_mapper('gra', 'lsp_code_actions', nil, true)

  -- if client.resolved_capabilities.document_formatting then
  --   vim.api.nvim_command [[augroup Format]]
  --   vim.api.nvim_command [[autocmd! * <buffer>]]
  --   vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
  --   vim.api.nvim_command [[augroup END]]
  -- end
end

return on_attach
