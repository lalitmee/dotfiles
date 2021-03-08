local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')
local eslint = require('config.lsp.efm.eslint')
local prettier = require('config.lsp.efm.prettier')

local efm_config = os.getenv('HOME') .. '/.config/nvim/lua/lsp/efm/config.yaml'
local efm_log_dir = '/tmp/'
local efm_root_markers = { 'package.json', '.git/', '.zshrc' }
local efm_languages = {
  css = { prettier },
  graphql = { prettier },
  html = { prettier },
  javascript = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  json = { prettier },
  less = { prettier },
  markdown = { prettier },
  sass = { prettier },
  scss = { prettier },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  yaml = { prettier }
}

lsp_status.register_progress()

lsp_config.efm.setup(
    {
      cmd = {
        'efm-langserver',
        '-c',
        efm_config,
        '-logfile',
        efm_log_dir .. 'efm.log'
      },
      filetype = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact'
      },
      capabilities = lsp_status.capabilities,
      on_attach = on_attach,
      root_dir = lsp_config.util.root_pattern(unpack(efm_root_markers)),
      init_options = { documentFormatting = false },
      settings = { rootMarkers = efm_root_markers, languages = efm_languages }
    }
)
