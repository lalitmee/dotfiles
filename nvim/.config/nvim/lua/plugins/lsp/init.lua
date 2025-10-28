local lsp_utils = require("plugins.lsp.utils")

return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    { --[[ lspsaga ]]
        enabled = false,
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
        event = "BufReadPre",
        dependencies = {
            {
                "williamboman/mason.nvim",
                cmd = {
                    "Mason",
                    "MasonInstall",
                    "MasonUninstall",
                    "MasonUninstallAll",
                    "MasonLog",
                    "MasonUpdate",
                },
                event = "BufReadPre",
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
            { "neovim/nvim-lspconfig" },
        },
        opts = {
            ensure_installed = {
                "bashls",
                "clangd",
                "cssls",
                "dockerls",
                "emmet_ls",
                "gopls",
                "jsonls",
                "lua_ls",
                "marksman",
                "pyright",
                "rust_analyzer",
                "tailwindcss",
                "taplo",
                "vimls",
                "copilot",
            },
            automatic_enable = {
                exclude = { "lua_ls" },
            },
        },
    },

    { --[[ lspconfig ]]
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        cmd = { "LspInfo", "LspInstall", "LspStart", "LspStop", "LspRestart", "LspCopilotSignIn" },
        init = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>l", group = "lsp", mode = { "n", "v" } },
            })
        end,
        keys = {
            {
                "<leader>la",
                function()
                    vim.lsp.buf.code_action()
                end,
                desc = "Code Action",
            },
            {
                "<leader>ld",
                function()
                    vim.lsp.buf.definition()
                end,
                desc = "Definition",
            },
            {
                "<leader>lD",
                function()
                    vim.lsp.buf.declaration()
                end,
                desc = "Declaration",
            },
            {
                "<leader>lh",
                function()
                    vim.lsp.buf.hover()
                end,
                desc = "Hover Doc",
            },
            { "<leader>li", ":LspInfo<CR>", desc = "Lsp Info" },
            {
                "<leader>lI",
                function()
                    vim.lsp.buf.implementation()
                end,
                desc = "Implementation",
            },
            {
                "<leader>ll",
                function()
                    vim.cmd("edit " .. vim.lsp.get_log_path())
                end,
                desc = "Lsp Log",
            },
            { "<leader>lm", ":Mason<CR>", desc = "Lsp Installer Info" },
            {
                "<leader>lr",
                function()
                    vim.lsp.buf.rename()
                end,
                desc = "Rename",
            },
            {
                "<leader>lR",
                function()
                    vim.lsp.buf.references()
                end,
                desc = "References",
            },
            {
                "<leader>ls",
                function()
                    vim.lsp.buf.document_symbol()
                end,
                desc = "Document Symbols",
            },
            {
                "<leader>lt",
                function()
                    vim.lsp.buf.type_definition()
                end,
                desc = "Type Definition",
            },
            {
                "<leader>lw",
                function()
                    vim.lsp.buf.workspace_symbol()
                end,
                desc = "Workspace Symbols",
            },
        },
        dependencies = {
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
                        desc = "Lsp Inlayhints Toggle",
                    },
                },
                enabled = false,
            },
        },
        config = function()
            require("plugins.lsp.keys")
            require("plugins.lsp.handlers")
            require("plugins.lsp.diagnostics")

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

            -- Completion configuration
            -- vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))
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

            local servers = require("plugins.lsp.servers")

            vim.lsp.inline_completion.enable(true)

            vim.lsp.config("*", {
                root_markers = { ".git" },
            })

            -- Base configuration to apply to all servers
            local base_config = {
                on_attach = lsp_utils.on_attach,
                capabilities = capabilities,
            }

            -- Loop through all the servers defined in your `servers` directory
            for server_name, server_config in pairs(servers) do
                local final_config = base_config

                -- If you have a custom config table for the server, merge it
                if type(server_config) == "table" then
                    final_config = vim.tbl_deep_extend("force", base_config, server_config)
                end

                -- Use the new, correct Neovim API
                vim.lsp.config(server_name, final_config)
                vim.lsp.enable(server_name)
            end
        end,
    },

    { --[[ nvim-lint ]]
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
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
                javascriptreact = { "eslint_d" },
                json = { "jsonlint" },
                lua = { "luacheck" },
                markdown = { "vale" },
                python = { "bandit", "pylint", "pydocstyle" },
                sh = { "shellcheck" },
                typescript = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                yaml = { "yamllint" },
                zsh = { "zsh" },
            }

            lk.augroup("nvim_lint_au", {
                {
                    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
                    pattern = {
                        ".env",
                        "css",
                        "html",
                        "javascript",
                        "javascriptreact",
                        "json",
                        "lua",
                        "markdown",
                        "python",
                        "sh",
                        "typescript",
                        "typescriptreact",
                        "yaml",
                        "zsh",
                    },
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
            { "<leader>bf", "<cmd>Format<cr>", desc = "Format", silent = true },
            { "<leader>be", "<cmd>FormatEnable<cr>", desc = "Format Enable", silent = true },
            { "<leader>bk", "<cmd>FormatDisable<cr>", desc = "Format Disable", silent = true },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        config = function()
            local slow_format_filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "liquid",
            }
            require("conform").setup({
                formatters = {
                    curlylint = {
                        command = "curlylint",
                        args = { "-f", "stylish" },
                    },
                    shfmt = {
                        command = "shfmt",
                        prepend_args = { "-i", "4", "-ci", "-sr" },
                    },
                    mdformat = {
                        command = "mdformat",
                        args = { "--number", "false" },
                    },
                },
                formatters_by_ft = {
                    ["*"] = { "trim_newlines", "trim_whitespace" },
                    css = { "prettierd" },
                    dart = { "dart_format" },
                    go = { "gofmt", "goimports", "golines" },
                    html = { "prettierd" },
                    javascript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    json = { "prettierd" },
                    liquid = { "curlylint" },
                    lua = { "stylua" },
                    markdown = { "markdownlint", "mdformat" },
                    python = { "black" },
                    rust = { "rustfmt" },
                    scss = { "prettierd" },
                    sh = { "shfmt" },
                    svg = { "prettierd" },
                    toml = { "taplo" },
                    typescript = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    yaml = { "yamlfmt" },
                },
                format_on_save = function(bufnr)
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
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_fallback = true, range = range })
            end, { range = true })

            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {
                desc = "Disable autoformat-on-save",
                bang = true,
            })
            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = "Re-enable autoformat-on-save",
            })

            -- lk.augroup("conform_au", {
            --     {
            --         event = { "BufWritePost" },
            --         pattern = { "*" },
            --         command = function(args)
            --             require("conform").format({ async = true, lsp_fallback = true, buf = args.buf }, function(err)
            --                 if not err then
            --                     vim.api.nvim_buf_call(args.buf, function()
            --                         vim.cmd.update()
            --                     end)
            --                 end
            --             end)
            --         end,
            --     },
            -- })
        end,
        -- enabled = false,
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

    { --[[ flutter-tools ]]
        enabled = false,
        "akinsho/flutter-tools.nvim",
        init = function()
            require("telescope").load_extension("flutter")
        end,
        config = true,
    },
}
