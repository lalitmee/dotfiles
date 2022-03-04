-- module export
M = {}

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
  local python = handle:read("*a"):sub(1, -2)
  handle:close()
  return python
end

return M
