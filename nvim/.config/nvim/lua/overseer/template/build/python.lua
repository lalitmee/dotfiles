return {
    name = "python build",
    builder = function()
        local file = vim.fn.expand("%:p")
        return {
            cmd = { "python" },
            args = { file },
            cwd = vim.fn.getcwd(),
            name = "python build",
            components = {
                { "on_output_quickfix", set_diagnostics = true, open = false },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "build python file",
    condition = {
        filetype = { "python" },
    },
}
