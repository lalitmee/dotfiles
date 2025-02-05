return {
    name = "npm-run-dev",
    builder = function()
        return {
            cmd = "npm",
            args = { "run", "dev" },
            cwd = vim.fn.getcwd(),
            name = "npm-run-dev",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (npm run dev)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
