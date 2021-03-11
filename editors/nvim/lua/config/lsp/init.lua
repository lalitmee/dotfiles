local fn = vim.fn

require('config.lsp.status')
require('lspkind').init({})
require('config.lsp.handlers')

fn.sign_define(
    'LspDiagnosticsSignError',
    { text = 'E', numhl = 'LspDiagnosticsDefaultError' }
)
fn.sign_define(
    'LspDiagnosticsSignWarning',
    { text = 'W', numhl = 'LspDiagnosticsDefaultWarning' }
)
fn.sign_define(
    'LspDiagnosticsSignInformation',
    { text = 'I', numhl = 'LspDiagnosticsDefaultInformation' }
)
fn.sign_define(
    'LspDiagnosticsSignHint',
    { text = 'H', numhl = 'LspDiagnosticsDefaultHint' }
)

require('config.lsp.angular')
require('config.lsp.bash')
-- require('config.lsp.clang')
require('config.lsp.css')
-- require('config.lsp.diagnostics')
require('config.lsp.docker')
require('config.lsp.efm')
require('config.lsp.go')
require('config.lsp.html')
require('config.lsp.json')
require('config.lsp.lua')
require('config.lsp.python')
require('config.lsp.rust')
require('config.lsp.sql')
require('config.lsp.ts')
require('config.lsp.vim')
require('config.lsp.vue')
require('config.lsp.yaml')
