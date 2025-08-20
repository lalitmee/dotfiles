return {
    name = "yarn-run-build",
    builder = function()
        return {
            cmd = "yarn",
            args = { "run", "build" },
            cwd = vim.fn.getcwd(),
            name = "yarn-run-build",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (yarn run build)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
