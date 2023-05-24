local fn = vim.fn

local lspsaga = {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    opts = {
        symbol_in_winbar = {
            enable = true,
            separator = "  ",
        },
        ui = {
            border = "rounded",
        },
        beacon = {
            enable = true,
        },
    },
    enabled = false,
}

local mason = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    event = { "VeryLazy" },
    config = function()
        require("mason").setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls",
                "cssls",
                "clangd",
                "dockerls",
                "emmet_ls",
                "gopls",
                "jsonls",
                "pyright",
                "rust_analyzer",
                "lua_ls",
                "tsserver",
                "vimls",
            },
        })
    end,
}

local lsp = {
    "neovim/nvim-lspconfig",
    ft = vim.g.enable_lspconfig_ft,
    event = { "VeryLazy" },
    dependencies = {
        { "j-hui/fidget.nvim" },
        {
            "folke/neodev.nvim",
            ft = "lua",
        },
        {
            "jose-elias-alvarez/null-ls.nvim",
            dependencies = { "jay-babu/mason-null-ls.nvim" },
        },
        {
            "simrat39/rust-tools.nvim",
            ft = "rust",
        },
        {
            "dmmulroy/tsc.nvim",
            cmd = { "TSC" },
            opts = {},
            enabled = false,
        },
    },
    config = function()
        local lsp_utils = require("plugins.lsp.utils")

        require("lspconfig.ui.windows").default_options.border =
            lk.style.border.rounded

        ----------------------------------------------------------------------
        -- NOTE: automatic setting up commands and handlers {{{
        ----------------------------------------------------------------------
        require("plugins.lsp.commands")
        require("plugins.lsp.handlers")
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

        sign({ highlight = "DiagnosticSignError", icon = "E" })
        sign({ highlight = "DiagnosticSignWarn", icon = "W" })
        sign({ highlight = "DiagnosticSignInfo", icon = "I" })
        sign({ highlight = "DiagnosticSignHint", icon = "H" })
        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: capabilities {{{
        ----------------------------------------------------------------------
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport =
            true
        capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

        -- Completion configuration
        vim.tbl_deep_extend(
            "force",
            capabilities,
            require("cmp_nvim_lsp").default_capabilities()
        )
        capabilities.textDocument.completion.completionItem.insertReplaceSupport =
            false

        capabilities.textDocument.codeLens = { dynamicRegistration = false }
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
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

        ----------------------------------------------------------------------
        --  NOTE: neodev setup {{{
        ----------------------------------------------------------------------
        require("neodev").setup({
            library = {
                plugins = {
                    "plenary.nvim",
                    "neotest",
                    types = true,
                },
            },
        })
        -- }}}
        ----------------------------------------------------------------------

        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: get servers config {{{
        ----------------------------------------------------------------------
        local servers = require("plugins.lsp.servers")

        local custom_init = function(client)
            client.config.flags = client.config.flags or {}
            client.config.flags.allow_incremental_sync = true
        end

        local function get_server_config(name)
            local conf = servers[name]
            local conf_type = type(conf)
            local config = conf_type == "table" and conf
                or conf_type == "function" and conf()
                or {}
            config.flags = { debounce_text_changes = 500 }
            config.capabilities = capabilities or {}
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
        for name, config in pairs(servers) do
            if config then
                require("lspconfig")[name].setup(get_server_config(name))
            end
        end

        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        --  NOTE: null-ls {{{
        ----------------------------------------------------------------------
        local nls = require("null-ls")
        -- local U = require("plugins.lsp.utils")

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
                fmt.eslint,
                -----------------
                -- DIAGNOSTICS --
                -----------------
                dgn.eslint,
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
                cda.eslint,
                cda.shellcheck,
                cda.refactoring,
            },
            -- on_attach = function(client, bufnr)
            --     -- U.fmt_on_save(client, bufnr)
            --     U.mappings()
            -- end,
        })
        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        --  fidget
        ----------------------------------------------------------------------
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

        ----------------------------------------------------------------------
        --  rust-tools
        ----------------------------------------------------------------------
        local rt = require("rust-tools")
        rt.setup({
            server = {
                on_attach = function(_, bufnr)
                    -- Hover actions
                    vim.keymap.set(
                        "n",
                        "K",
                        rt.hover_actions.hover_actions,
                        { buffer = bufnr }
                    )
                    -- Code action groups
                    vim.keymap.set(
                        "n",
                        "<Leader>la",
                        rt.code_action_group.code_action_group,
                        { buffer = bufnr }
                    )
                end,
            },
        })
    end,
}

return {
    lsp,
    mason,
    lspsaga,
}
