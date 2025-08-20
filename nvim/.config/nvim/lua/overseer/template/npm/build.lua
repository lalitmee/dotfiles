return {
    name = "npm-run-build",
    builder = function()
        return {
            cmd = "npm",
            args = { "run", "build" },
            cwd = vim.fn.getcwd(),
            name = "npm-run-build",
            components = {
                { "on_complete_notify", on_change = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run Package Manager (npm run build)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
