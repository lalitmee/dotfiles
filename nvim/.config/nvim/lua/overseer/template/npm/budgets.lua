return {
    name = "npm-run-budgets",
    builder = function()
        return {
            cmd = "npm",
            args = { "run", "budgets" },
            cwd = vim.fn.getcwd(),
            name = "npm-run-budgets",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Budgets (npm run budgets)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
