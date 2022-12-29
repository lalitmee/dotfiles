local M = {
    "neovim/nvim-lspconfig",
    ft = vim.g.enable_lspconfig_ft,
    event = "VimEnter",
    dependencies = {
        { "onsails/lspkind.nvim" },
        { "j-hui/fidget.nvim" },
        { "folke/neodev.nvim" },
        { "jose-elias-alvarez/null-ls.nvim" },
        { "folke/lsp-trouble.nvim" },
    },
}

function M.config()
    local fn = vim.fn
    local icons = lk.style.icons.lsp
    local lsp_utils = require("lk.plugins.lsp.utils")

    require("lk.highlights").plugin("lspconfig", {
        { LspInfoBorder = { link = "FloatBorder" } },
    })
    require("lspconfig.ui.windows").default_options.border = lk.style.border.rounded

    ----------------------------------------------------------------------
    -- NOTE: automatic setting up commands and handlers {{{
    ----------------------------------------------------------------------
    require("lk.plugins.lsp.commands")
    require("lk.plugins.lsp.handlers")
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: diagnostic signs {{{
    ----------------------------------------------------------------------
    local function sign(opts)
        fn.sign_define(opts.highlight, {
            text = opts.icon,
            texthl = opts.highlight,
            numhl = opts.highlight .. "Nr",
            culhl = opts.highlight .. "CursorNr",
            linehl = opts.highlight .. "Line",
        })
    end

    sign({ highlight = "DiagnosticSignError", icon = icons.error })
    sign({ highlight = "DiagnosticSignWarn", icon = icons.warn })
    sign({ highlight = "DiagnosticSignInfo", icon = icons.info })
    sign({ highlight = "DiagnosticSignHint", icon = icons.hint })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: capabilities {{{
    ----------------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    }
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: servers {{{
    ----------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: neodev setup {{{
    --------------------------------------------------------------------------------
    local ok, neodev = lk.require("neodev")
    if not ok then
        return
    end
    neodev.setup({
        library = { plugins = { "plenary.nvim" } },
    })
    -- }}}
    --------------------------------------------------------------------------------

    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: get servers config {{{
    ----------------------------------------------------------------------
    local servers = require("lk.plugins.lsp.servers")

    local custom_init = function(client)
        client.config.flags = client.config.flags or {}
        client.config.flags.allow_incremental_sync = true
    end

    local function get_server_config(name)
        local cmp_nvim_lsp_ok, cmp_nvim_lsp = lk.require("cmp_nvim_lsp")
        if not cmp_nvim_lsp_ok then
            return nil
        end
        local conf = servers[name]
        local conf_type = type(conf)
        local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
        config.flags = { debounce_text_changes = 500 }
        config.capabilities = config.capabilities or capabilities or vim.lsp.protocol.make_client_capabilities()
        cmp_nvim_lsp.default_capabilities(config.capabilities)
        config = vim.tbl_deep_extend("force", {
            on_init = custom_init,
            on_attach = lsp_utils.on_attach,
            capabilities = config.capabilities,
            flags = {
                debounce_text_changes = nil,
            },
        }, config)
        return config
    end
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: setting servers {{{
    ----------------------------------------------------------------------
    local lsp_ok, lsp = lk.require("lspconfig")
    if not lsp_ok then
        return
    end
    for name, config in pairs(servers) do
        if config then
            lsp[name].setup(get_server_config(name))
        end
    end

    -- }}}
    ----------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: null-ls {{{
    --------------------------------------------------------------------------------
    local nls = require("null-ls")
    -- local U = require("lk.plugins.lsp.utils")

    local fmt = nls.builtins.formatting
    local dgn = nls.builtins.diagnostics
    local cda = nls.builtins.code_actions

    -- Configuring null-ls
    nls.setup({
        debug = true,
        sources = {
            ----------------
            -- FORMATTING --
            ----------------
            fmt.trim_whitespace,
            fmt.tidy,
            fmt.trim_newlines,
            fmt.eslint_d,
            -----------------
            -- DIAGNOSTICS --
            -----------------
            dgn.eslint_d,
            dgn.shellcheck,
            dgn.luacheck.with({
                extra_args = {
                    "--globals",
                    "P",
                    "__lk_global_callbacks",
                    "after_each",
                    "before_each",
                    "describe",
                    "it",
                    "lk",
                    "vim",
                    "RELOAD",
                    "R",
                    "--std",
                    "luajit",
                },
            }),
            ------------------
            -- CODE ACTIONS --
            ------------------
            cda.eslint_d,
            cda.shellcheck,
        },
        -- on_attach = function(client, bufnr)
        --     -- U.fmt_on_save(client, bufnr)
        --     U.mappings()
        -- end,
    })
    -- }}}
    --------------------------------------------------------------------------------

    require("fidget").setup({
        text = {
            spinner = "bouncing_bar",
        },
        window = {
            blend = 0,
        },
        sources = {
            ["null-ls"] = {
                ignore = true,
            },
        },
    })
end

return M

-- vim:foldmethod=marker
