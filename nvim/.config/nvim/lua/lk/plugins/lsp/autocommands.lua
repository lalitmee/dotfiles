local M = {}

M.setup_autocommands = function(client)
  local augroup = lk.augroup

  augroup("LspLocationList", {
    {
      event = { "InsertLeave", "BufWrite", "BufEnter" },
      buffer = 0,
      command = function()
        vim.diagnostic.setloclist({ open = false })
      end,
    },
  })

  if client and client.server_capabilities.document_highlight then
    augroup("LspCursorCommands", {
      {
        event = { "CursorHold", "CursorHoldI" },
        buffer = 0,
        command = function()
          vim.lsp.buf.document_highlight()
        end,
      },
      {
        event = { "CursorMoved" },
        buffer = 0,
        command = function()
          vim.lsp.buf.clear_references()
        end,
      },
    })
  end
  if client and client.server_capabilities.document_formatting then
    -- format on save
    augroup("LspFormat", {
      {
        event = { "BufWritePre" },
        buffer = 0,
        command = function()
          vim.lsp.buf.formatting_sync(nil, 1000)
        end,
      },
    })
  end
end

return M
