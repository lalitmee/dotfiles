local wk = require("which-key")

wk.add({
    { "<leader>e", group = "errors", mode = { "n", "v" } },
    {
        "<leader>ed",
        function()
            vim.diagnostic.enable(true, { bufnr = 0 })
            vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
        end,
        desc = "Disable Diagnostic",
    },
    {
        "<leader>ee",
        function()
            vim.diagnostic.enable(true, { bufnr = 0 })
            vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
        end,
        desc = "Enable Diagnostic",
    },
    {
        "<leader>en",
        function()
            vim.diagnostic.jump({
                count = 1,
                severity = lk.get_highest_error_severity(),
                wrap = true,
                float = true,
            })
        end,
        desc = "Next Diagnostics",
    },
    {
        "<leader>ep",
        function()
            vim.diagnostic.jump({
                count = -1,
                severity = lk.get_highest_error_severity(),
                wrap = true,
                float = true,
            })
        end,
        desc = "Prev Diagnostics",
    },
    { "<leader>eq", ":LspDiagnostics<CR>", desc = "Quickfix Diagnostics" },
    {
        "<leader>ev",
        function()
            vim.diagnostic.open_float({ scope = "line" })
        end,
        desc = "Diagnostic Float Preview",
    },
})
