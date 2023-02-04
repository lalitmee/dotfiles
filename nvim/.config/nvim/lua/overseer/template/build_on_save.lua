return {
    name = "build on save",
    builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = { file }
        if vim.bo.filetype == "go" then
            cmd = { "go", "run", file }
        elseif vim.bo.filetype == "python" then
            cmd = { "python", file }
        elseif vim.bo.filetype == "sh" then
            cmd = { "bash", file }
        elseif vim.bo.filetype == "lua" then
            cmd = { "lua", file }
        elseif vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
            cmd = { "node", file }
        end
        return {
            cmd = cmd,
            components = {
                { "on_output_quickfix", set_diagnostics = true, open = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = {
            "go",
            "javascript",
            "lua",
            "python",
            "sh",
            "typescript",
        },
    },
}
