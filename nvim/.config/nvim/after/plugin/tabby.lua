local ok, tabby = lk.require("tabby")
if not ok then
    return
end

local palette = require("cobalt2.palette")
local filename = require("tabby.filename")
local cwd = function()
    return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
end
local tabname = function(tabid)
    return vim.api.nvim_tabpage_get_number(tabid)
end
local line = {
    hl = { fg = palette.yellow, bg = palette.cursor_line },
    layout = "active_tab_with_wins",
    head = {
        { cwd, hl = { fg = palette.black, bg = palette.yellow } },
        { "", hl = { fg = palette.yellow, bg = palette.cursor_line } },
    },
    active_tab = {
        label = function(tabid)
            return {
                "  " .. tabname(tabid) .. " ",
                hl = { fg = palette.yellow, bg = palette.darker_blue, style = "bold" },
            }
        end,
        left_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
        right_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
    },
    inactive_tab = {
        label = function(tabid)
            return {
                "  " .. tabname(tabid) .. " ",
                hl = { fg = palette.yellow, bg = palette.darker_blue, style = "bold" },
            }
        end,
        left_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
        right_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
    },
    top_win = {
        label = function(winid)
            return {
                "  " .. filename.unique(winid) .. " ",
                hl = { fg = palette.yellow, bg = palette.darker_blue },
            }
        end,
        left_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
        right_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
    },
    win = {
        label = function(winid)
            return {
                "  " .. filename.unique(winid) .. " ",
                hl = { fg = palette.yellow, bg = palette.darker_blue },
            }
        end,
        left_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
        right_sep = { "", hl = { fg = palette.darker_blue, bg = palette.cursor_line } },
    },
    tail = {
        { "", hl = { fg = palette.yellow, bg = palette.cursor_line } },
        { "  ", hl = { fg = palette.black, bg = palette.yellow } },
    },
}

tabby.setup({ tabline = line })
