local lsp_config = require('lspconfig')
local lsp_status = require('lsp-status')
local on_attach = require('config.lsp.on_attach')

local capabilities = vim.lsp.protocol.make_client_capabilities()

lsp_config.jsonls.setup(
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
