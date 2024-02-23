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
        enabled = false,
    },

    { --[[ mason ]]
        "williamboman/mason-lspconfig.nvim",
        event = "BufEnter",
        dependencies = {
            {
                "williamboman/mason.nvim",
                event = "BufEnter",
                opts = {
                    ui = {
                        border = "rounded",
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                },
            },
        },
        opts = {
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
                "tailwindcss",
            },
        },
    },

    { --[[ lspconfig ]]
        "neovim/nvim-lspconfig",
        event = { "VeryLazy" },
        dependencies = {
            {
                "pmizio/typescript-tools.nvim",
                keys = {
                    { "<leader>le", "<cmd>TSToolsAddMissingImports<cr>", desc = "add-missing-imports", silent = true },
                    { "<leader>lj", "<cmd>TSToolsFixAll<cr>", desc = "fix-all", silent = true },
                    {
                        "<leader>lg",
                        "<cmd>TSToolsGoToSourceDefinition<cr>",
                        desc = "go-to-source-definition",
                        silent = true,
                    },
                    { "<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", desc = "organize-imports", silent = true },
                    { "<leader>lO", "<cmd>TSToolsSortImports<cr>", desc = "sort-imports", silent = true },
                    {
                        "<leader>lu",
                        "<cmd>TSToolsRemoveUnusedImports<cr>",
                        desc = "remove-unused-imports",
                        silent = true,
                    },
                    { "<leader>lx", "<cmd>TSToolsRemoveUnused<cr>", desc = "remove-unused", silent = true },
                },
                opts = {
                    on_attach = lsp_utils.on_attach,
                    root_dir = function(fname)
                        -- return require("lspconfig.util").root_pattern(".git", "package.json", "jsconfig.json")(fname)

                        -- NOTE: want to have only one `tsserver` running for a monorepo project
                        return require("lspconfig.util").root_pattern(".git")(fname)
                    end,
                    settings = {
                        tsserver_file_preferences = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                        tsserver_format_options = {},
                    },
                },
                -- enabled = false,
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
            {
                "lvimuser/lsp-inlayhints.nvim",
                event = "LspAttach",
                opts = {},
                keys = {
                    {
                        "<leader>lh",
                        function()
                            require("lsp-inlayhints").toggle()
                        end,
                        desc = "lsp-inlayhints-toggle",
                    },
                },
                enabled = false,
            },
        },
        config = function()
            require("plugins.lsp.handlers")
            require("plugins.lsp.diagnostics")

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

    {
        "mfussenegger/nvim-lint",
        event = { "VeryLazy" },
        config = function()
            local lint = require("lint")
            local luacheck = lint.linters.luacheck
            luacheck.args = {
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
            }
            lint.linters_by_ft = {
                ["*"] = { "typos", "woke" },
                [".env"] = { "dotenv_linter" },
                css = { "stylelint" },
                go = { "golangcilint" },
                html = { "tidy" },
                javascript = { "eslint_d" },
                json = { "jsonlint" },
                lua = { "luacheck" },
                markdown = { "vale" },
                python = { "bandit", "pylint", "pydocstyle" },
                sh = { "shellcheck" },
                typescript = { "eslint_d" },
                yaml = { "yamllint" },
                zsh = { "zsh" },
            }

            lk.augroup("nvim_lint_au", {
                {
                    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
                    pattern = { "*" },
                    command = function()
                        lint.try_lint()
                    end,
                },
            })
        end,
        enabled = false,
    },

    { --[[ conform.nvim ]]
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        keys = {
            { "<leader>bf", "<cmd>Format<cr>", desc = "format", silent = true },
            { "<leader>be", "<cmd>FormatEnable<cr>", desc = "format-enable", silent = true },
            { "<leader>bk", "<cmd>FormatDisable<cr>", desc = "format-disable", silent = true },
        },
        config = function()
            local slow_format_filetypes = {}
            require("conform").setup({
                formatters_by_ft = {
                    ["*"] = { "trim_newlines", "trim_whitespace" },
                    go = { "gofmt", "goimports", "golines" },
                    javascript = { "eslint_d", "prettierd" },
                    javascriptreact = { "eslint_d", "prettierd" },
                    lua = { "stylua" },
                    rust = { "rustfmt" },
                    sh = { "shfmt" },
                    toml = { "taplo" },
                    typescript = { "eslint_d", "prettierd" },
                    typescriptreact = { "eslint_d", "prettierd" },
                    yaml = { "yamlfmt" },
                },
                format_on_save = function(bufnr)
                    -- Disable with a global or buffer-local variable
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end

                    if slow_format_filetypes[vim.bo[bufnr].filetype] then
                        return
                    end
                    local function on_format(err)
                        if err and err:match("timeout$") then
                            slow_format_filetypes[vim.bo[bufnr].filetype] = true
                        end
                    end

                    return { timeout_ms = 200, lsp_fallback = true }, on_format
                end,

                format_after_save = function(bufnr)
                    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                        return
                    end
                    return { lsp_fallback = true }
                end,
            })

            lk.command("Format", function(args)
                local count = args["count"]
                local line1 = args["line1"]
                local line2 = args["line2"]
                local range = nil
                if count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, line2 - 1, line2, true)[1]
                    range = {
                        start = { line1, 0 },
                        ["end"] = { line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_fallback = true, range = range })
            end, { range = true })

            lk.command("FormatDisable", function(args)
                local bang = args["bang"]
                if bang then
                    -- `FormatDisable!` will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                    vim.notify("Formatting is disabled for this buffer")
                else
                    vim.g.disable_autoformat = true
                    vim.notify("Formatting is disabled globally")
                end
            end, { desc = "Disable autoformat-on-save", bang = true })

            lk.command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
                vim.notify("Formatting is enabled")
            end, { desc = "Re-enable autoformat-on-save" })

            lk.augroup("conform_au", {
                {
                    event = { "BufWritePre" },
                    pattern = { "*" },
                    command = function()
                        vim.cmd("Format")
                    end,
                },
            })
        end,
        enabled = false,
    },

    { --[[ null-ls ]]
        "nvimtools/none-ls.nvim",
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
                    fmt.clang_format.with({
                        extra_args = {
                            "--style=file:" .. vim.fn.expand("$PWD/.clang-format"),
                        },
                    }),
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
        tag = "legacy",
        event = "LspAttach",
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
