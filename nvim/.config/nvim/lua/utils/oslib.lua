-- The operating system is assigned to a global variable that
-- that can be used elsewhere for conditional system based logic
local uname = vim.loop.os_uname()

if uname.sysname == "Darwin" then
    vim.g.open_command = "open"
    vim.g.system_name = "macOS"
    vim.g.is_mac = true
elseif uname.sysname == "Linux" then
    vim.g.open_command = "xdg-open"
    vim.g.system_name = "Linux"
    vim.g.is_linux = true
end

-- module export
local M = {}

M.get_open_cmd = function()
    return vim.g.open_command
end

-- get operating system name
M.get_os = function(table)
    if table == nil then
        table = {
            macOS = "macOS",
            linux = "Linux",
        }
    end

    if os.getenv("HOME"):find("/Users") then
        return table.macOS
    else
        return table.linux
    end
end

-- get username ($USER)
M.get_username = function()
    return os.getenv("USER")
end

-- get home dir ($HOME)
M.get_homedir = function()
    return os.getenv("HOME")
end

M.get_cwd = function()
    return vim.fn["getcwd"]()
end

M.get_python = function()
    local handle = io.popen("which python3")
    local python = handle and handle:read("*a"):sub(1, -2)
    if handle then
        handle:close()
    end
    return python
end

M.get_second_brain_path = function()
  if vim.env.HOME == "/home/lalitmee" then
    return vim.env.HOME .. "/Projects/Personal/Github/second-brain"
  else
    return vim.env.HOME .. "/Projects/Work/Github/second-brain"
  end
end

return M
