local M = {}

local status_gps_ok, gps = lk.safe_require("nvim-gps")
if not status_gps_ok then
  return
end

local get_filename = function()
  local filename = vim.fn.expand("%:t", "", "")
  local extension = ""
  local file_icon = ""
  local file_icon_color = ""
  local default_file_icon = ""
  local default_file_icon_color = ""

  if not lk.is_empty(filename) then
    extension = vim.fn.expand("%:e", "", "")

    local default = false

    if lk.is_empty(extension) then
      extension = ""
      default = true
    end

    file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = default })

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if file_icon == nil then
      file_icon = default_file_icon
      file_icon_color = default_file_icon_color
    end

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#LineNr#" .. filename .. "%*"
  end
end

local get_gps = function()
  local status_ok, gps_location = pcall(gps.get_location, {})
  if not status_ok then
    return ""
  end

  local icons = lk.style.icons

  if not gps.is_available() then -- Returns boolean value indicating whether a output can be provided
    return ""
  end

  if gps_location == "error" then
    return ""
  else
    if not lk.is_empty(gps_location) then
      return icons.ui.ChevronRight .. " " .. gps_location
    else
      return ""
    end
  end
end

local excludes = function()
  local winbar_filetype_exclude = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "alpha",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
  }

  if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end

  return false
end

M.get_winbar = function()
  if excludes() then
    return
  end
  local value = get_filename()

  if not lk.is_empty(value) then
    local gps_value = get_gps()
    value = value .. " " .. gps_value
  end

  if not lk.is_empty(value) and lk.get_buf_option("mod") then
    local mod = "[]"
    value = value .. " " .. "%#LineNr#" .. mod .. "%*"
  end

  vim.opt_local.winbar = value
end

return M
