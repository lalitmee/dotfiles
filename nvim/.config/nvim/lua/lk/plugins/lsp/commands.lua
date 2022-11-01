local command = lk.command

----------------------------------------------------------------------
-- NOTE: lsp settings {{{
----------------------------------------------------------------------
command("ReloadLSP", function()
    vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
    vim.cmd([[edit]])
end, {})

command("LogLSP", function()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end, {})

command("DebugLSP", function()
    print(vim.inspect(vim.lsp.get_active_clients()))
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: code actions {{{
----------------------------------------------------------------------
command("LspCodeActions", function()
    vim.lsp.buf.code_action()
end, {})

command("LspRangeCodeAction", function()
    vim.lsp.buf.range_code_action()
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: declaration & references {{{
----------------------------------------------------------------------
command("LspClearReferences", function()
    vim.lsp.buf.clear_references()
end, {})

command("LspReferences", function()
    vim.lsp.buf.references()
    vim.lsp.buf.clear_references()
end, {})

command("LspDeclaration", function()
    vim.lsp.buf.declaration()
    vim.lsp.buf.clear_references()
end, {})

command("LspDefinition", function()
    vim.lsp.buf.definition()
    vim.lsp.buf.clear_references()
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: document related {{{
----------------------------------------------------------------------
command("LspDocumentHighlight", function()
    vim.lsp.buf.document_highlight()
end, {})

command("LspDocumentSymbols", function()
    vim.lsp.buf.document_symbol()
end, {})

command("LspDocumentFormatting", function()
    vim.lsp.buf.formatting()
end, {})

command("LspHover", function()
    vim.lsp.buf.hover()
end, {})

command("LspSignatureHelp", function()
    vim.lsp.buf.signature_help()
end, {})

command("LspImplementation", function()
    vim.lsp.buf.implementation()
end, {})

command("LspIncomingCalls", function()
    vim.lsp.buf.incoming_calls()
end, {})

command("LspOutgoingCalls", function()
    vim.lsp.buf.outgoing_calls()
end, {})

command("LspRename", function()
    vim.lsp.buf.rename()
end, {})

command("LspTypeDefinition", function()
    vim.lsp.buf.type_definition()
end, {})

command("LspWorkspaceSymbols", function()
    vim.lsp.buf.workspace_symbol()
end, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: diagnostics {{{
----------------------------------------------------------------------
-- Go to the next diagnostic, but prefer going to errors first
-- In general, I pretty much never want to go to the next hint
local severity_levels = {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
}

local get_highest_error_severity = function()
    for _, level in ipairs(severity_levels) do
        local diags = vim.diagnostic.get(0, { severity = { min = level } })
        if #diags > 0 then
            return level, diags
        end
    end
end

command("LspGetAllDiagnostics", function()
    vim.diagnostic.get()
end, {})

command("LspGotoNextDiagnostic", function()
    vim.diagnostic.goto_next({
        severity = get_highest_error_severity(),
        wrap = true,
        float = false,
    })
end, {})

command("LspGotoPrevDiagnostic", function()
    vim.diagnostic.goto_prev({
        severity = get_highest_error_severity(),
        wrap = true,
        float = false,
    })
end, {})

command("ShowLineDiagnosticInFlot", function()
    vim.diagnostic.open_float(0, {
        scope = "line",
    })
end, {})

-- loclist
command("LspSetLoclist", function()
    vim.diagnostic.setloclist()
end, {})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
