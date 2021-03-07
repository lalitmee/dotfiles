local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

lsp_status.register_progress()

lsp_config.sumneko_lua.setup(
    {
      cmd = {
        '/home/lalitmee/data/Github/lua-language-server/bin/Linux/lua-language-server',
        '-E',
        '/home/lalitmee/data/Github/lua-language-server/main.lua'
      },
      capabilities = lsp_status.capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            enable = true,
            globals = {
              'vim',
              'describe',
              'it',
              'before_each',
              'after_each',
              'awesome',
              'theme',
              'client'
            }
          }
        }
      }
    }
)
