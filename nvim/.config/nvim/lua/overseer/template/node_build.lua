return {
    name = "node build",
    builder = function()
        local file = vim.fn.expand("%:p")
        return {
            cmd = { "node" },
            args = { file },
            cwd = vim.fn.getcwd(),
            name = "node build",
            components = {
                { "on_output_quickfix", set_diagnostics = true, open = false },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "build node",
    condition = {
        filetype = {
            "javascript",
            "typescript",
        },
    },
}
