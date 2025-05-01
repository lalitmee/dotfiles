return {
    name = "yarn-run-start",
    builder = function()
        return {
            cmd = "yarn",
            args = { "run", "start" },
            cwd = vim.fn.getcwd(),
            name = "yarn-run-start",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (yarn run start)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
