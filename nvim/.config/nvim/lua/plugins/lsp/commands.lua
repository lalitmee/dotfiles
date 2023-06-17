local command = lk.command

----------------------------------------------------------------------
-- NOTE: lsp settings {{{
----------------------------------------------------------------------
command("ReloadLSP", function()
    vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
    vim.cmd([[edit]])
end)

command("LogLSP", function()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end)

command("DebugLSP", function()
    print(vim.inspect(vim.lsp.get_active_clients()))
end)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: code actions {{{
----------------------------------------------------------------------
command("LspCodeActions", function()
    vim.lsp.buf.code_action()
end)
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: declaration & references {{{
----------------------------------------------------------------------
command("LspClearReferences", vim.lsp.buf.clear_references, {})
command("LspReferences", vim.lsp.buf.references, {})
command("LspDeclaration", vim.lsp.buf.declaration, {})
command("LspDefinition", vim.lsp.buf.definition, {})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: document related {{{
----------------------------------------------------------------------
command("LspDocumentHighlight", vim.lsp.buf.document_highlight, {})
command("LspDocumentSymbols", vim.lsp.buf.document_symbol, {})
command("LspFormat", function()
    vim.lsp.buf.format({ bufnr = 0 })
end)
command("LspHover", vim.lsp.buf.hover, {})
command("LspSignatureHelp", vim.lsp.buf.signature_help, {})
command("LspImplementation", vim.lsp.buf.implementation, {})
command("LspIncomingCalls", vim.lsp.buf.incoming_calls, {})
command("LspOutgoingCalls", vim.lsp.buf.outgoing_calls, {})
command("LspRename", function()
    vim.lsp.buf.rename()
end)
command("LspTypeDefinition", vim.lsp.buf.type_definition, {})
command("LspWorkspaceSymbols", vim.lsp.buf.workspace_symbol, {})
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

command("LspDiagnosticEnable", function()
    vim.diagnostic.enable()
end)
command("LspDiagnosticDisable", function()
    vim.diagnostic.disable()
end)
command("LspGetAllDiagnostics", vim.diagnostic.get, {})
command("LspGotoNextDiagnostic", function()
    vim.diagnostic.goto_next({
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
    })
end)
command("LspGotoPrevDiagnostic", function()
    vim.diagnostic.goto_prev({
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
    })
end)
command("ShowLineDiagnosticInFloat", function()
    vim.diagnostic.open_float({ scope = "line" })
end)

-- loclist
command("LspSetLoclist", vim.diagnostic.setloclist, {})
-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: workspace folder {{{
--------------------------------------------------------------------------------
command("LspAddWorkspaceFolder", function(args)
    local path = args["args"]
    vim.lsp.buf.add_workspace_folder(path)
end, { nargs = 1, complete = "dir" })
command("LspListWorkspaceFolders", function()
    P(vim.lsp.buf.list_workspace_folders())
end)
command("LspRemoveWorkspaceFolder", function(args)
    local path = args["args"]
    vim.lsp.buf.remove_workspace_folder(path)
end, { nargs = 1, complete = "dir" })
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
