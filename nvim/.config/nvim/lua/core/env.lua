local home = vim.env.HOME or vim.fn.expand("~")

local function prepend_path(dir)
    if dir == "" or vim.fn.isdirectory(dir) == 0 then
        return
    end

    local path = vim.env.PATH or ""
    for segment in path:gmatch("[^:]+") do
        if segment == dir then
            return
        end
    end

    vim.env.PATH = dir .. ":" .. path
end

-- GUI and non-login shells often skip zsh fnm hooks; use the fnm default alias.
if vim.fn.executable("node") == 0 then
    prepend_path(home .. "/.local/share/fnm/aliases/default/bin")
end

prepend_path(home .. "/.local/share/nvim/mason/bin")
prepend_path(home .. "/.local/bin")
