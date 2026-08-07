local M = {}

M.on_attach = function(client, bufnr)
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    local autocmds = require("plugins.lsp.autocmds")
    autocmds.setup_autocommands(client, bufnr)

    local map_opts = { noremap = false, silent = true, buffer = bufnr }
    local nmap = function(lhs, rhs, opts) vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", map_opts, opts or {})) end
    local imap = function(lhs, rhs, opts) vim.keymap.set("i", lhs, rhs, vim.tbl_extend("force", map_opts, opts or {})) end

    nmap("gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go To Definition" })
    nmap("ge", function() Snacks.picker.diagnostics({ buffer = 0 }) end, { desc = "Go To Diagnostics" })
    nmap("gE", function() Snacks.picker.diagnostics() end, { desc = "Go To Workspace Diagnostics" })
    nmap("gr", function() Snacks.picker.lsp_references() end, { desc = "Go To References" })
    nmap("gw", function() Snacks.picker.lsp_symbols() end, { desc = "Go To Document Symbols" })
    nmap("gW", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Go To Workspace Symbols" })
    nmap("ga", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Go To Workspace Symbols" })

    if client.name ~= "rust_analyzer" then
        nmap("K", vim.lsp.buf.hover, { desc = "Show Hover" })
    end

    nmap("gD", function() Snacks.picker.lsp_declarations() end, { desc = "Go to Declarations" })
    nmap("gy", function() Snacks.picker.lsp_typedefs() end, { desc = "Go to Type Definitions" })
    imap("<C-h>", vim.lsp.buf.signature_help, { desc = "Show Signature Help" })
    nmap("gz", function() Snacks.picker.lsp_implementations() end, { desc = "Go To Implementations" })

    nmap("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous Diagnostic" })
    nmap("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })

    if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
    end
    if client.server_capabilities.document_formatting then
        client.server_capabilities.document_formatting = false
    end
    if client.server_capabilities.documentFormattingProvider then
        client.server_capabilities.documentFormattingProvider = false
    end
    if client.server_capabilities.documentRangeFormattingProvider then
        client.server_capabilities.documentRangeFormattingProvider = false
    end

    if client.server_capabilities.goto_definition == true then
        vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
    end
end

return M
