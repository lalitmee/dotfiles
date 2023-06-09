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
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
M.mappings = function(client)
    local nmap = lk.nmap
    local imap = lk.imap

    -- lsp mapping for the client
    -- NOTE: using this somehow goes into telescope with two definitions so not
    -- using this for now until I figure out why it was happening

    -- --telescope
    -- nmap("gd", "<cmd>Telescope lsp_definitions<CR>", map_opts)
    -- -- nmap("gd", vim.lsp.buf.definition, map_opts)
    -- nmap("ge", "<cmd>Telescope diagnostics<CR>", map_opts)
    -- nmap("gr", "<cmd>Telescope lsp_references<CR>", map_opts)
    -- nmap("gw", "<cmd>Telescope lsp_document_symbols<CR>", map_opts)
    -- nmap("gW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", map_opts)
    -- if client.name ~= "rust_analyzer" then
    --     nmap("K", vim.lsp.buf.hover, map_opts)
    -- end
    -- nmap("gD", vim.lsp.buf.declaration, map_opts)
    -- nmap("gy", vim.lsp.buf.type_definition, map_opts)
    -- imap("<C-h>", vim.lsp.buf.signature_help, map_opts)
    -- nmap("gz", vim.lsp.buf.implementation, map_opts)

    -- fzf-lua
    nmap("ga", "<cmd>FzfLua lsp_code_actions<CR>", map_opts)
    nmap("gd", function()
        if client.name == "tsserver" then
            vim.cmd("TypescriptGoToSourceDefinition")
        else
            require("fzf-lua").lsp_definitions({
                jump_to_single_result = true,
            })
        end
    end, map_opts)
    nmap("<C-]>", function()
        require("fzf-lua").lsp_definitions({
            jump_to_single_result = true,
            jump_to_single_result_action = require("fzf-lua.actions").file_vsplit,
        })
    end, map_opts)
    nmap("ge", "<cmd>FzfLua lsp_document_diagnostics<CR>", map_opts)
    nmap("gE", "<cmd>FzfLua lsp_workspace_diagnostics<CR>", map_opts)
    nmap("gl", "<cmd>FzfLua lsp_finder<CR>", map_opts)
    nmap("gr", "<cmd>FzfLua lsp_references<CR>", map_opts)
    nmap("gw", "<cmd>FzfLua lsp_document_symbols<CR>", map_opts)
    nmap("gW", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", map_opts)
    if client.name ~= "rust_analyzer" then
        nmap("K", vim.lsp.buf.hover, map_opts)
    end
    nmap("gD", "<cmd>FzfLua lsp_declarations", map_opts)
    nmap("gy", "<cmd>FzfLua lsp_typedefs<CR>", map_opts)
    imap("<C-h>", vim.lsp.buf.signature_help, map_opts)
    nmap("gz", "<cmd>FzfLua lsp_implementations<CR>", map_opts)

    nmap("[e", "<cmd>LspGotoPrevDiagnostic<CR>")
    nmap("]e", "<cmd>LspGotoNextDiagnostic<CR>")
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
    -- if client.name == "tsserver" then
    --     client.server_capabilities.semanticTokensProvider = nil
    -- elseif client.server_capabilities.semanticTokensProvider then
    --     vim.lsp.semantic_tokens.stop(bufnr, client.id)
    -- end
    if client.server_capabilities.document_formatting then
        client.server_capabilities.document_formatting = false
    end
    -- if client.server_capabilities.goto_definition == true then
    --     vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    -- end

    -- NOTE: using `formatter.nvim` to format
    -- if client.server_capabilities.document_formatting == true then
    --     vim.api.nvim_buf_set_option(
    --         bufnr,
    --         "formatexpr",
    --         "v:lua.vim.lsp.formatexpr()"
    --     )
    --     -- Add this <leader> bound mapping so formatting the entire document is easier.
    --     map("n", "<leader>gq", "<cmd>lua vim.lsp.buf.format()<CR>", map_opts)
    -- end
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
