return {
    name = "yarn-build",
    builder = function()
        return {
            cmd = "yarn",
            args = { "build" },
            cwd = vim.fn.getcwd(),
            name = "yarn-build",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (yarn build)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
