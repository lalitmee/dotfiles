return {
    name = "yarn-tsc-watch",
    builder = function()
        return {
            cmd = "yarn",
            args = { "tsc-watch" },
            cwd = vim.fn.getcwd(),
            name = "yarn-tsc-watch",
            components = {
                { "on_output_quickfix", set_diagnostics = true, open = true },
                { "on_result_diagnostics", remove_on_restart = true },
                { "on_result_diagnostics_quickfix", close = true },
                { "on_result_diagnostics_trouble", close = true },
                "default",
            },
        }
    end,
    desc = "Run Package Manager (yarn tsc-watch)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
