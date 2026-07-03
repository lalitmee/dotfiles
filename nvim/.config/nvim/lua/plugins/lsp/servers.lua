return {
    bashls = {},
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        init_options = {
            clangdFileStatus = true,
        },
    },
    cssls = {},
    dockerls = {},
    emmet_ls = {
        on_attach = function(client, bufnr)
            vim.keymap.set("i", ",,", function()
                client.request("textDocument/completion", vim.lsp.util.make_position_params(), function(_, result)
                    local textEdit = result[1].textEdit
                    local snip_string = textEdit.newText
                    textEdit.newText = ""
                    vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
                    require("luasnip").lsp_expand(snip_string)
                end, bufnr)
            end)
            local lsp_utils = require("plugins.lsp.utils")
            lsp_utils.on_attach(client, bufnr)
        end,
    },
    gopls = {
        settings = {
            gopls = {
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    },
    jsonls = {},
    lua_ls = {
        settings = {
            Lua = {
                hint = { enable = true },
                format = { enable = false },
                diagnostics = {
                    globals = {
                        "P",
                        "R",
                        "RELOAD",
                        "Snacks",
                        "__lk_global_callbacks",
                        "after_each",
                        "before_each",
                        "describe",
                        "it",
                        "lk",
                        "require",
                        "vim",
                        "_dd",
                        "_bt",
                    },
                },
                completion = {
                    keywordSnippet = "Replace",
                    callSnippet = "Replace",
                },
                workspace = {
                    library = {
                        "${3rd}/luv/library",
                        vim.api.nvim_get_runtime_file("", true),
                    },
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    marksman = {},
    pyright = {},
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                inlayHints = { locationLinks = true },
                diagnostics = { enable = true, experimental = { enable = true } },
                hover = { actions = { enable = true } },
                procMacro = { enable = true },
                cargo = { allFeatures = true },
                checkOnSave = {
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
            },
        },
    },
    tailwindcss = {
        filetypes = {
            "astro",
            "css",
            "html",
            "javascript",
            "javascriptreact",
            "scss",
            "svelte",
            "tsx",
            "typescript",
            "typescriptreact",
            "vue",
        },
    },
    taplo = {},
    ts_ls = false,
    tsgo = {},
}
