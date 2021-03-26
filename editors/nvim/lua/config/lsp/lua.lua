USER = vim.fn.expand('$USER')

local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

local system_name
if vim.fn.has('mac') == 1 then
  system_name = 'macOS'
elseif vim.fn.has('unix') == 1 then
  system_name = 'Linux'
elseif vim.fn.has('win32') == 1 then
  system_name = 'Windows'
else
  print('Unsupported system for sumneko')
end

local sumneko_root_path = ''
local sumneko_binary = ''

if vim.fn.has('unix') == 1 then
  sumneko_root_path = '/home/' .. USER .. '/data/Github/lua-language-server'
  sumneko_binary = sumneko_root_path .. '/bin/Linux/lua-language-server'
else
  print('Unsupported system for sumneko')
end

lsp_config.sumneko_lua.setup(
    {
      cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
          diagnostics = {
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
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
            },
            maxPreload = 1000,
            preloadFileSize = 1000
          }
        }
      }
    }
)
