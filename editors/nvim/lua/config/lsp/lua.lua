USER = vim.fn.expand('$USER')

local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

local sumneko_root_path = ''
local sumneko_binary = ''

if vim.fn.has('mac') == 1 then
  sumneko_root_path = '/Users/' .. USER .. '/data/Github/lua-language-server'
  sumneko_binary = sumneko_root_path .. '/bin/macOS/lua-language-server'
elseif vim.fn.has('unix') == 1 then
  sumneko_root_path = '/home/' .. USER .. '/data/Github/lua-language-server'
  sumneko_binary = sumneko_root_path .. '/bin/Linux/lua-language-server'
else
  print('Unsupported system for sumneko')
end

local function get_lua_runtime()
  local result = {}
  for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. '/lua/'
    if vim.fn.isdirectory(lua_path) then
      result[lua_path] = true
    end
  end
  result[vim.fn.expand('$VIMRUNTIME/lua')] = true
  result[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true

  return result
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

lsp_config.sumneko_lua.setup(
    {
      cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
      capabilities = vim.tbl_deep_extend(
          'keep', capabilities or {}, lsp_status.capabilities
      ),
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
            library = get_lua_runtime(),
            maxPreload = 1000,
            preloadFileSize = 1000
          }
        }
      }
    }
)
