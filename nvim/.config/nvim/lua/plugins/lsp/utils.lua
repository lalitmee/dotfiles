local M = {}

local map_opts = { noremap = false, silent = true }

----------------------------------------------------------------------
-- NOTE: servers config {{{
----------------------------------------------------------------------
local autocmds = require("plugins.lsp.autocmds")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: on attach function {{{
----------------------------------------------------------------------
M.on_attach = function(client, bufnr)
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    autocmds.setup_autocommands(client, bufnr)

    -- mappings
    M.mappings(client)

    -- capabilities
    M.capabilities(client, bufnr)

    -- -- navic
    -- M.navic(client, bufnr)

    -- -- inlay-hints
    -- require("lsp-inlayhints").on_attach(client, bufnr)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
local function extend_map_opts(tbl)
    local merged_table = vim.tbl_deep_extend("keep", map_opts, tbl)
    return merged_table
end

M.mappings = function(client)
    local nmap = lk.nmap
    local imap = lk.imap

    nmap("gd", "<cmd>Telescope lsp_definitions<CR>", extend_map_opts({ desc = "go-to-definition" }))
    nmap("ge", function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
    end, extend_map_opts({ desc = "go-to-diagnostics" }))
    nmap("gE", "<cmd>Telescope diagnostics<CR>", extend_map_opts({ desc = "go-to-diagnostics" }))
    nmap("gr", "<cmd>Telescope lsp_references<CR>", extend_map_opts({ desc = "go-to-refrences" }))
    nmap("gw", "<cmd>Telescope lsp_document_symbols<CR>", extend_map_opts({ desc = "go-to-document-symbols" }))
    nmap(
        "gW",
        "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
        extend_map_opts({ desc = "go-to-dynamic-workspace-symbols" })
    )
    nmap("ga", "<cmd>Telescope lsp_workspace_symbols<CR>", extend_map_opts({ desc = "go-to-workspace-symbols" }))
    if client.name ~= "rust_analyzer" then
        nmap("K", vim.lsp.buf.hover, map_opts)
    end
    nmap("gD", "<cmd>FzfLua lsp_declarations<CR>", extend_map_opts({ desc = "Go to Declarations" }))
    nmap("gy", "<cmd>FzfLua lsp_typedefs<CR>", extend_map_opts({ desc = "Go to Type Definitions" }))
    imap("<C-h>", vim.lsp.buf.signature_help, extend_map_opts({ desc = "Show Signature Help" }))
    nmap("gz", "<cmd>FzfLua lsp_implementations<CR>", extend_map_opts({ desc = "Go To Implementations" }))

    nmap("[d", function()
        vim.diagnostic.goto_prev({
            severity = lk.get_highest_error_severity(),
            wrap = true,
            float = true,
        })
    end)
    nmap("]d", function()
        vim.diagnostic.goto_next({
            severity = lk.get_highest_error_severity(),
            wrap = true,
            float = true,
        })
    end)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: format on save {{{
----------------------------------------------------------------------
---Common format-on-save for lsp servers that implements formatting
---@param client table
---@param buf integer
M.fmt_on_save = function(client, buf)
    if client.supports_method("textDocument/formatting") then
        lk.augroup("format_on_save_au", {
            event = { "BufWritePre" },
            buffer = buf,
            command = function()
                vim.lsp.buf.format({
                    filter = function(cli)
                        return cli.name == "null-ls"
                    end,
                    timeout_ms = 3000,
                    buffer = buf,
                })
            end,
        })
    end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: capabilities {{{
----------------------------------------------------------------------
M.capabilities = function(client, bufnr)
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

    -- if client.server_capabilities.inlayHintProvider then
    --     vim.lsp.buf.inlay_hint(bufnr, true)
    -- end
    if client.server_capabilities.goto_definition == true then
        vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
    end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: nvim-navic setup {{{
----------------------------------------------------------------------
M.navic = function(client, bufnr)
    local navic_ok, navic = lk.require("nvim-navic")
    if navic_ok then
        local skipNavicLsps = {
            "ltex",
            "cssls",
            "eslint",
            "html",
            "remark_ls",
            "bashls",
            "tailwindcss",
            "emmet_ls",
        }
        if lk.has_value(skipNavicLsps, client.name) == false then
            navic.attach(client, bufnr)
        end
    end
end
-- }}}
----------------------------------------------------------------------

return M
