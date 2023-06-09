local lsp_utils = require("plugins.lsp.utils")

return {
    { --[[ lspsaga ]]
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        opts = {
            symbol_in_winbar = {
                enable = false,
                separator = "  ",
            },
            ui = {
                border = "rounded",
            },
            beacon = {
                enable = true,
            },
        },
    },

    { --[[ mason ]]
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
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
    },

    { --[[ lspconfig ]]
        "neovim/nvim-lspconfig",
        ft = vim.g.enable_lspconfig_ft,
        event = { "VeryLazy" },
        dependencies = {
            {
                "jose-elias-alvarez/typescript.nvim",
                opts = {
                    server = {
                        on_attach = lsp_utils.on_attach,
                        settings = {
                            javascript = {
                                inlayHints = {
                                    includeInlayEnumMemberValueHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                },
                            },
                            typescript = {
                                inlayHints = {
                                    includeInlayEnumMemberValueHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                },
                            },
                        },
                    },
                },
            },
            {
                "folke/neodev.nvim",
                ft = "lua",
            },
            {
                "dmmulroy/tsc.nvim",
                cmd = { "TSC" },
                opts = {},
                enabled = false,
            },
        },
        config = function()
            require("plugins.lsp.handlers")
            require("plugins.lsp.diagnostics")
            require("plugins.lsp.commands")

            require("lspconfig.ui.windows").default_options.border = lk.style.border.rounded

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

            -- Completion configuration
            vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

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

            require("neodev").setup({
                library = {
                    plugins = {
                        "nvim-dap-ui",
                        "plenary.nvim",
                        "neotest",
                    },
                    types = true,
                },
            })

            local servers = require("plugins.lsp.servers")

            local custom_init = function(client)
                client.config.flags = client.config.flags or {}
                client.config.flags.allow_incremental_sync = true
            end

            local function get_server_config(name)
                local conf = servers[name]
                local conf_type = type(conf)
                local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
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

            for name, config in pairs(servers) do
                if config then
                    require("lspconfig")[name].setup(get_server_config(name))
                end
            end
        end,
    },

    { --[[ null-ls ]]
        "jose-elias-alvarez/null-ls.nvim",
        event = { "LspAttach" },
        dependencies = {
            "jay-babu/mason-null-ls.nvim",
            {
                "lukas-reineke/lsp-format.nvim",
                config = true,
            },
        },
        config = function()
            local nls = require("null-ls")

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
                    fmt.black,
                    fmt.clang_format,
                    fmt.eslint_d,
                    fmt.prettierd,
                    fmt.rustfmt,
                    fmt.shfmt,
                    fmt.stylua,
                    fmt.taplo,
                    fmt.tidy,
                    fmt.trim_newlines,
                    fmt.trim_whitespace,
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
                    cda.refactoring,

                    -- typescript.nvim
                    require("typescript.extensions.null-ls.code-actions"),
                },
                on_attach = function(client)
                    local buffer_name = vim.fn.expand("%:t")
                    if buffer_name ~= "COMMIT_EDITMSG" then
                        if client.supports_method("textDocument/formatting") then
                            require("lsp-format").on_attach(client)
                        end
                    end
                end,
            })
        end,
    },

    { --[[ fidget ]]
        "j-hui/fidget.nvim",
        event = { "LspAttach" },
        opts = {
            text = {
                spinner = "bouncing_bar",
            },
            window = {
                blend = 0,
            },
            sources = {
                ["null-ls"] = { ignore = true },
            },
        },
    },

    { --[[ rust-tools ]]
        "simrat39/rust-tools.nvim",
        ft = "rust",
        opts = {
            server = {
                on_attach = function(_, bufnr)
                    -- Hover actions
                    lk.nnoremap("K", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
                    -- Code action groups
                    lk.nnoremap("<leader>la", require("rust-tools").action_group.code_action_group, { buffer = bufnr })
                end,
            },
        },
    },
}
