local lsp_config = require('lspconfig')
local lsp = vim.lsp
local fn = vim.fn

_ = require('lspkind').init()
require('config.lsp.handlers')

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
-- lsp.diagnostic.on_publish_diagnostics, {
--   underline = true,
--   virtual_text = {
--     prefix = "●",
--     spacing = 4,
--   }
-- }
-- )

fn.sign_define(
    'LspDiagnosticsSignError',
    { text = '🞮', numhl = 'LspDiagnosticsDefaultError' }
)
fn.sign_define(
    'LspDiagnosticsSignWarning',
    { text = '▲', numhl = 'LspDiagnosticsDefaultWarning' }
)
fn.sign_define(
    'LspDiagnosticsSignInformation',
    { text = '⁈', numhl = 'LspDiagnosticsDefaultInformation' }
)
fn.sign_define(
    'LspDiagnosticsSignHint',
    { text = '⯁', numhl = 'LspDiagnosticsDefaultHint' }
)

require('config.lsp.bash')
require('config.lsp.css')
require('config.lsp.efm')
require('config.lsp.html')
require('config.lsp.json')
require('config.lsp.lua')
require('config.lsp.rust')
require('config.lsp.sql')
require('config.lsp.ts')
require('config.lsp.vim')
