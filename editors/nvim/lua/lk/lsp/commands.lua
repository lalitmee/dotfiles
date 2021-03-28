local command = lk_utils.command

-- from akinsho dotfiles

command {
  'ReloadLSP',
  function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd [[edit]]
  end
}

command {
  'LogLSP',
  function()
    local path = vim.lsp.get_log_path()
    vim.cmd('edit ' .. path)
  end
}
command {
  'DebugLSP',
  function()
    print(vim.inspect(vim.lsp.get_active_clients()))
  end
}
command {
  'Format',
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end
}

-- buf

command {
  'LspAddToWorkspaceFolder',
  function()
    vim.lsp.buf.add_workspace_folder()
  end
}

command {
  'LspClearReferences',
  function()
    vim.lsp.buf.clear_references()
  end
}

command {
  'LspCodeActions',
  function()
    vim.lsp.buf.code_action()
  end
}

command {
  'LspDeclaration',
  function()
    vim.lsp.buf.declaration()
    vim.lsp.buf.clear_references()
  end
}

command {
  'LspDefinition',
  function()
    vim.lsp.buf.definition()
    vim.lsp.buf.clear_references()
  end
}

command {
  'LspDocumentHighlight',
  function()
    vim.lsp.buf.document_highlight()
  end
}

command {
  'LspDocumentSymbols',
  function()
    vim.lsp.buf.document_symbol()
  end
}

command {
  'LspDocumentFormatting',
  function()
    vim.lsp.buf.formatting()
  end
}

command {
  'LspFormattingSync',
  function()
    vim.lsp.buf.formatting_sync()
  end
}

command {
  'LspHover',
  function()
    vim.lsp.buf.hover()
  end
}

command {
  'LspSignatureHelp',
  function()
    vim.lsp.buf.signature_help()
  end
}

command {
  'LspImplementation',
  function()
    vim.lsp.buf.implementation()
  end
}

command {
  'LspIncomingCalls',
  function()
    vim.lsp.buf.incoming_calls()
  end
}

command {
  'LspOutgoingCalls',
  function()
    vim.lsp.buf.outgoing_calls()
  end
}

command {
  'LspWorkspaceFolders',
  function()
    vim.lsp.buf.list_workspace_folders()
  end
}

command {
  'LspRangeCodeAction',
  function()
    vim.lsp.buf.range_code_action()
  end
}

command {
  'LspRangeFormatting',
  function()
    vim.lsp.buf.range_formatting()
  end
}

command {
  'LspReferences',
  function()
    vim.lsp.buf.references()
    vim.lsp.buf.clear_references()
  end
}

command {
  'LspRemoveWorkspaceFolder',
  function()
    vim.lsp.buf.remove_workspace_folder()
  end
}

command {
  'LspRename',
  function()
    vim.lsp.buf.rename()
  end
}

command {
  'LspTypeDefinition',
  function()
    vim.lsp.buf.type_definition()
  end
}

command {
  'LspWorkspaceSymbols',
  function()
    vim.lsp.buf.workspace_symbol()
  end
}

-- diagnostic

command {
  'LspGetAllDiagnostics',
  function()
    vim.lsp.diagnostic.get_all()
  end
}

command {
  'LspGetNextDiagnostic',
  function()
    vim.lsp.diagnostic.get_next()
  end
}

command {
  'LspGetPrevDiagnostic',
  function()
    vim.lsp.diagnostic.get_prev()
  end
}

command {
  'LspGotoNextDiagnostic',
  function()
    vim.lsp.diagnostic.goto_next()
  end
}

command {
  'LspGotoPrevDiagnostic',
  function()
    vim.lsp.diagnostic.goto_prev()
  end
}

command {
  'LspShowLineDiagnostics',
  function()
    vim.lsp.diagnostic.show_line_diagnostics()
  end
}

command {
  'LspSetLoclist',
  function()
    vim.lsp.diagnostic.set_loclist()
  end
}
