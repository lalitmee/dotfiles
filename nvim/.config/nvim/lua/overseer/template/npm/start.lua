return {
    name = "npm-start",
    builder = function()
        return {
            cmd = "npm",
            args = { "start" },
            cwd = vim.fn.getcwd(),
            name = "npm-start",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (npm start)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
