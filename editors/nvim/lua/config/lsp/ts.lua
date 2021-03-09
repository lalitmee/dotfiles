local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

lsp_status.register_progress()

lsp_config.tsserver.setup(
    {
      capabilities = lsp_status.capabilities,
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
      end
    }
)

-- lsp_config.rome.setup(
--     {
--       capabilities = lsp_status.capabilities,
--       on_attach = function(client)
--         client.resolved_capabilities.document_formatting = false
--         on_attach(client)
--       end
--     }
-- )
