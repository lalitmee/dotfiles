return {
    name = "yarn-dev",
    builder = function()
        return {
            cmd = "yarn",
            args = { "dev" },
            cwd = vim.fn.getcwd(),
            name = "yarn-dev",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (yarn dev)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
