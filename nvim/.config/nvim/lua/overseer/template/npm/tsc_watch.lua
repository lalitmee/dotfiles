local tsc_errorformat = {
    "%E%f:%l:%c: error %m", -- Error: file, line, column, message
    "%E%f:%l:%c - error %m", -- Another common error format (seen in newer versions)
    "%C%m", -- Continued error messages
    "%-G%.%#", -- Ignore any other lines
}

return {
    name = "npm-tsc-watch",
    builder = function()
        return {
            cmd = "npm",
            args = { "tsc-watch" },
            cwd = vim.fn.getcwd(),
            name = "npm-tsc-watch",
            components = {
                {
                    "on_output_quickfix",
                    set_diagnostics = true,
                    open = false,
                    errorformat = table.concat(tsc_errorformat, ","),
                    open_on_match = true,
                    close = true,
                },
                {
                    "on_result_diagnostics",
                    remove_on_restart = true,
                },
                {
                    "on_result_diagnostics_quickfix",
                    close = true,
                    open = true,
                    set_empty_result = true,
                },
                {
                    "on_result_notify",
                    system = "unfocused",
                },
                "default",
            },
        }
    end,
    desc = "Run TypeScript compiler in watch mode (npm tsc-watch)",
    condition = {
        callback = function()
            return vim.fn.filereadable("package.json") == 1
        end,
    },
}
