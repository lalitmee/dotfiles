return {
    name = "yarn-run-budgets",
    builder = function()
        return {
            cmd = "yarn",
            args = { "run", "budgets" },
            cwd = vim.fn.getcwd(),
            name = "yarn-run-budgets",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Budgets (yarn run budgets)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
