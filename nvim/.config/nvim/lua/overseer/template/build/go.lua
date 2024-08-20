return {
    name = "go build",
    builder = function()
        return {
            cmd = "go",
            args = { "build" },
            cwd = vim.fn.getcwd(),
            name = "go build",
            components = {
                { "on_output_quickfix", set_diagnostics = true, open = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Builds the project",
    condition = {
        filetype = { "go" },
    },
}
