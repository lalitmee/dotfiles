local M = {}
local fmt = string.format
local l = vim.log.levels

local term_wrapper = function(command, file)
    vim.cmd("vsplit")
    vim.cmd("term " .. fmt(command, file))
    vim.cmd(
        "setl nobuflisted nornu nonu nocursorline scrolloff=0 signcolumn=no laststatus=0"
    )
    vim.cmd("silent! file CompileAndRun")
    vim.cmd("startinsert")
    vim.cmd("au WinLeave * set laststatus=2")
end

local commands = {
    cpp = "g++ %s && ./a.out",
    javascript = "node %s",
    lua = "lua %s",
    python = "python3 %s",
}

M.compile_and_run = function()
    local filetype = vim.bo.filetype
    local cmd = commands[filetype]
    if cmd then
        term_wrapper(cmd, vim.fn.expand("%"))
    else
        vim.notify(fmt('Filetype "%s" is not supported yet', filetype), l.INFO)
    end
end

return M
