return {
    name = "yarn-tsc-watch",
    builder = function()
        return {
            cmd = "yarn", -- Assuming you're using npm to run the task; change to "yarn" if necessary
            args = { "tsc-watch" },
            cwd = vim.fn.getcwd(),
            name = "yarn-tsc-watch",
            components = {
                { "on_output_quickfix", set_diagnostics = true, open = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    desc = "Run TypeScript compiler in watch mode (tsc-watch)",
    condition = {
        callback = function()
            -- Only load this template if tsconfig.json exists in the current directory
            return vim.fn.filereadable("tsconfig.json") == 1
        end,
    },
}
