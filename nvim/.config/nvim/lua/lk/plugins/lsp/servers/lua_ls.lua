return {
    settings = {
        Lua = {
            hint = { enable = true },
            format = { enable = false },
            diagnostics = {
                globals = {
                    "vim",
                    "describe",
                    "it",
                    "before_each",
                    "after_each",
                    "require",
                },
            },
            completion = {
                keywordSnippet = "Replace",
                callSnippet = "Replace",
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                -- library = vim.api.nvim_get_runtime_file("", true),
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
