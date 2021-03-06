local lsp_config = require('lspconfig')
local on_attach = require('config.lsp.on_attach')
local capabilities = require('config.lsp.capabilities')

lsp_config.sumneko_lua.setup(
    {
      capabilities = capabilities,
      cmd = { '/home/lalitmee/data/Github/lua-language-server/bin/Linux/lua-language-server' },
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            enable = true,
            globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'awesome', 'theme', 'client' }
          }
        }
      }
    }
)
