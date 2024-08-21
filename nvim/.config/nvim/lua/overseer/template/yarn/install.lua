return {
    name = "yarn-install",
    builder = function()
        return {
            cmd = "yarn",
            cwd = vim.fn.getcwd(),
            name = "yarn-install",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (yarn)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
