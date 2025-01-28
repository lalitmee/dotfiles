return {
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
                -- Make the server aware of Neovim runtime files
                library = {
                    "${3rd}/luv/library",
                    vim.api.nvim_get_runtime_file("", true),
                },
                -- maxPreload = 2000,
                -- preloadFileSize = 5000,
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
