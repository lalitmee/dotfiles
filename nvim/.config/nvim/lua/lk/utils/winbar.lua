local M = {}

M.disabled_filetypes = { "NvimTree", "NeogitStatus", "NeogitCommitMessage" }

M.get_filename = function()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if not lk.is_empty(filename) then
    local file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(
      filename,
      extension,
      { default = true }
    )

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if lk.is_empty(file_icon) then
      file_icon = ""
      file_icon_color = ""
    end

    vim.api.nvim_set_hl(0, "Winbar", { link = "Number" })

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
  end
end

local excludes = function()
  if vim.tbl_contains(M.disabled_filetypes, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

local get_gps = function()
  local status_gps_ok, gps = lk.safe_require("nvim-navic")
  if not status_gps_ok then
    return ""
  end

  local status_ok, gps_location = pcall(gps.get_location, {})
  if not status_ok then
    return ""
  end

  if not gps.is_available() or gps_location == "error" then
    return ""
  end

  local separator = ">" --   
  if not lk.is_empty(gps_location) then
    return separator .. " " .. gps_location
  else
    return ""
  end
end

-- See :h statusline for %v values
M.eval = function()
  if excludes() then
    return
  end
  local nvim_location = get_gps()
  return string.format("%s %s", M.get_filename(), nvim_location)
end

return M
