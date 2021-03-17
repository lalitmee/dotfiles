local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

local capabilities = vim.lsp.protocol.make_client_capabilities()

lsp_config.tsserver.setup(
    {
      capabilities = vim.tbl_deep_extend(
          'keep', capabilities or {}, lsp_status.capabilities
      ),
      on_attach = function(client)
        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
        lsp_status.on_attach(client)
      end
    }
)
