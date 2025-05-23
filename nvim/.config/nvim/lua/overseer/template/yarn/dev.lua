return {
    name = "yarn-run-dev",
    builder = function()
        return {
            cmd = "yarn",
            args = { "run", "dev" },
            cwd = vim.fn.getcwd(),
            name = "yarn-run-dev",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Yarn Dev (yarn run dev)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
