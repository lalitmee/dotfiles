local M = {}

M.setup_autocommands = function(client)
  local autocommands = require("lk/autocommands")

  -- autocommands.augroup('LspLocationList', {
  --   {
  --     events = { 'InsertLeave', 'BufWrite', 'BufEnter' },
  --     targets = { '<buffer>' },
  --     command = [[lua vim.lsp.diagnostic.setloclist({open = false})]],
  --   },
  -- })
  if client and client.resolved_capabilities.document_highlight then
    autocommands.augroup("LspCursorCommands", {
      {
        events = { "CursorHold" },
        targets = { "<buffer>" },
        command = "lua vim.lsp.buf.document_highlight()",
      },
      {
        events = { "CursorHoldI" },
        targets = { "<buffer>" },
        command = "lua vim.lsp.buf.document_highlight()",
      },
      {
        events = { "CursorMoved" },
        targets = { "<buffer>" },
        command = "lua vim.lsp.buf.clear_references()",
      },
    })
  end
  -- if client and client.resolved_capabilities.document_formatting then
  --   -- format on save
  --   autocommands.augroup('LspFormat', {
  --     {
  --       events = { 'BufWritePre' },
  --       targets = { '<buffer>' },
  --       command = 'lua vim.lsp.buf.formatting_sync(nil, 1000)',
  --     },
  --   })
  -- end
end

return M
