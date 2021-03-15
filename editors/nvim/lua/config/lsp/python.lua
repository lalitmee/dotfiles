local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

local capabilities = vim.lsp.protocol.make_client_capabilities()

lsp_config.pyls.setup(
    {
      capabilities = vim.tbl_deep_extend(
          'keep', capabilities or {}, lsp_status.capabilities
      ),
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
      end
    }
)

-- lsp_config.pyls_ms.setup(
--     {
--       capabilities = lsp_status.capabilities,
--       on_attach = function(client)
--         client.resolved_capabilities.document_formatting = false
--         on_attach(client)
--       end
--     }
-- )

-- lsp_config.pyright.setup(
--     {
--       capabilities = lsp_status.capabilities,
--       on_attach = function(client)
--         client.resolved_capabilities.document_formatting = false
--         on_attach(client)
--       end
--     }
-- )

-- lsp_config.jedi_language_server.setup(
--     {
--       capabilities = lsp_status.capabilities,
--       on_attach = function(client)
--         client.resolved_capabilities.document_formatting = false
--         on_attach(client)
--       end
--     }
-- )
