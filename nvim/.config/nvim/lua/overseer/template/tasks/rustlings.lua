return {
    name = "rustlings watch",
    builder = function()
        return {
            cmd = "rustlings watch",
            cwd = vim.fn.getcwd(),
            name = "rustlings watch",
            components = {
                { "on_output_quickfix", set_diagnostics = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run the rustlings exercies",
    condition = {
        filetype = { "rs" },
    },
}
