local M = {}

-- vim.lsp.handlers["textDocument/hover"] = function(_, method, result)
--   print(vim.inspect(result))
-- end

M.autoformat = true

function M.format()
  if M.autoformat then
    vim.lsp.buf.formatting_sync()
  end
end

function M.setup(client, buf)
  local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
  local nls = require('lk/plugins/nvim_lsp/servers/null-ls')
  local efm_formatted =
      require('lk/plugins/nvim_lsp/servers/efm').formatted_languages

  local enable = false
  if nls.has_formatter(ft) then
    enable = client.name == 'null-ls'
  elseif efm_formatted[ft] then
    enable = client.name == 'efm'
  else
    enable = not (client.name == 'efm' or client.name == 'null-ls')
  end

  client.resolved_capabilities.document_formatting = enable
  -- format on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("lk/plugins/nvim_lsp/formatting").format()
      augroup END
    ]])
  end
end

return M
