local lsp_wrapper = {}

-- buf

function lsp_wrapper.add_to_workspace_folder()
  vim.lsp.buf.add_workspace_folder()
end

function lsp_wrapper.clear_references()
  vim.lsp.buf.clear_references()
end

function lsp_wrapper.code_action()
  vim.lsp.buf.code_action()
end

function lsp_wrapper.declaration()
  vim.lsp.buf.declaration()
  vim.lsp.buf.clear_references()
end

function lsp_wrapper.definition()
  vim.lsp.buf.definition()
  vim.lsp.buf.clear_references()
end

function lsp_wrapper.document_highlight()
  vim.lsp.buf.document_highlight()
end

function lsp_wrapper.document_symbol()
  vim.lsp.buf.document_symbol()
end

function lsp_wrapper.formatting()
  vim.lsp.buf.formatting()
end

function lsp_wrapper.formatting_sync()
  vim.lsp.buf.formatting_sync()
end

function lsp_wrapper.hover()
  vim.lsp.buf.hover()
end

function lsp_wrapper.signature_help()
  vim.lsp.buf.signature_help()
end

function lsp_wrapper.implementation()
  vim.lsp.buf.implementation()
end

function lsp_wrapper.incoming_calls()
  vim.lsp.buf.incoming_calls()
end

function lsp_wrapper.list_workspace_folders()
  vim.lsp.buf.list_workspace_folders()
end

function lsp_wrapper.outgoing_calls()
  vim.lsp.buf.outgoing_calls()
end

function lsp_wrapper.range_code_action()
  vim.lsp.buf.range_code_action()
end

function lsp_wrapper.range_formatting()
  vim.lsp.buf.range_formatting()
end

function lsp_wrapper.references()
  vim.lsp.buf.references()
  vim.lsp.buf.clear_references()
end

function lsp_wrapper.remove_workspace_folder()
  vim.lsp.buf.remove_workspace_folder()
end

function lsp_wrapper.rename()
  vim.lsp.buf.rename()
end

function lsp_wrapper.type_definition()
  vim.lsp.buf.type_definition()
end

function lsp_wrapper.workspace_symbol()
  vim.lsp.buf.workspace_symbol()
end

-- diagnostic

function lsp_wrapper.get_all_diagnostics()
  vim.lsp.diagnostic.get_all()
end

function lsp_wrapper.get_next_diagnostic()
  vim.lsp.diagnostic.get_next()
end

function lsp_wrapper.get_prev_diagnostic()
  vim.lsp.diagnostic.get_prev()
end

function lsp_wrapper.goto_next_diagnostic()
  vim.lsp.diagnostic.goto_next()
end

function lsp_wrapper.goto_prev_diagnostic()
  vim.lsp.diagnostic.goto_prev()
end

function lsp_wrapper.show_line_diagnostics()
  vim.lsp.diagnostic.show_line_diagnostics()
end

function lsp_wrapper.set_diagnostics_loclist()
  vim.lsp.diagnostic.set_loclist()
end

return lsp_wrapper
