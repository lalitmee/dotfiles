return {
    name = "npm-install",
    builder = function()
        return {
            cmd = "npm",
            args = { "install" },
            cwd = vim.fn.getcwd(),
            name = "npm-install",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (npm install)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
