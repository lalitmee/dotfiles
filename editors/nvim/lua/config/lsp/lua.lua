USER = vim.fn.expand('$USER')

local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

lsp_status.register_progress()

local sumneko_root_path = ''
local sumneko_binary = ''

if vim.fn.has('mac') == 1 then
  sumneko_root_path = '/Users/' .. USER .. '/.config/nvim/lua-language-server'
  sumneko_binary = '/Users/' .. USER ..
                       '/.config/nvim/lua-language-server/bin/macOS/lua-language-server'
elseif vim.fn.has('unix') == 1 then
  sumneko_root_path = '/home/' .. USER .. '/.config/nvim/lua-language-server'
  sumneko_binary = '/home/' .. USER ..
                       '/.config/nvim/lua-language-server/bin/Linux/lua-language-server'
else
  print('Unsupported system for sumneko')
end

lsp_config.sumneko_lua.setup(
    {
      cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
      capabilities = lsp_status.capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
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
          },
          workspace = {
            preloadFileSize = 500,
            maxPreload = 1000,
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
            }
          }
        }
      }
    }
)
