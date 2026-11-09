local M = {}

local state_home = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
local path = state_home .. "/omarchy/current/theme/neovim.lua"
local chunk = loadfile(path)
local ok, specs = false, nil
if chunk then
    ok, specs = pcall(chunk)
end

M.specs = {}
if ok and type(specs) == "table" then
    for _, spec in ipairs(specs) do
        if spec[1] == "LazyVim/LazyVim" then
            M.colorscheme = spec.opts and spec.opts.colorscheme
        else
            table.insert(M.specs, spec)
        end
    end
end

function M.apply()
    if M.colorscheme then
        vim.o.background = "dark"
        local applied, err = pcall(vim.cmd.colorscheme, M.colorscheme)
        if applied then
            return
        end
        vim.notify("Omarchy theme unavailable; using Cobalt2: " .. tostring(err), vim.log.levels.WARN)
    end
    vim.cmd.colorscheme("cobalt2")
end

return M
