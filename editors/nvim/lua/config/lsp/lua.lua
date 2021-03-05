local lsp_config = require('lspconfig')
local on_attach = require('config.lsp.on_attach')

lsp_config.sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = {
          "vim",
          "describe",
          "it",
          "before_each",
          "after_each",
          "awesome",
          "theme",
          "client"
        }
      }
    }
  }
})


-- if true then
--   require('nlua.lsp.nvim').setup(lsp_config, {
--     on_attach = custom_attach,

--     globals = {
--       "Color", "c", "Group", "g", "s",
--       "RELOAD",
--     }
--   })
-- else
--   lsp_config.sumneko_lua.setup({
--     on_attach = on_attach,
--     settings = {
--       Lua = {
--         diagnostics = {
--           enable = true,
--           globals = {
--             "vim",
--             "describe",
--             "it",
--             "before_each",
--             "after_each",
--             "awesome",
--             "theme",
--             "client"
--           }
--         }
--       }
--     }
--   })
-- end
