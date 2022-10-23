local M = {}

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

        vim.api.nvim_set_hl(0, "Winbar", { link = "Variable" })

        return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
    end
end

local get_gps = function()
    local status_gps_ok, gps = lk.require("nvim-navic")
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

M.eval = function()
    local nvim_location = get_gps()
    return string.format("%s %s", M.get_filename(), nvim_location)
    -- return string.format("%s", nvim_location)
end

return M
