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
    hl = { fg = palette.yellow, bg = palette.cobalt_bg },
    layout = "active_wins_at_tail",
    head = {
        { cwd, hl = { fg = palette.black, bg = palette.yellow } },
        { "", hl = { fg = palette.yellow, bg = palette.cobalt_bg } },
    },
    active_tab = {
        label = function(tabid)
            return {
                "  " .. tabname(tabid) .. " ",
                hl = { fg = palette.yellow, bg = palette.cursor_hover, style = "bold" },
            }
        end,
        left_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
        right_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
    },
    inactive_tab = {
        label = function(tabid)
            return {
                "  " .. tabname(tabid) .. " ",
                hl = { fg = palette.yellow, bg = palette.cursor_hover, style = "bold" },
            }
        end,
        left_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
        right_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
    },
    top_win = {
        label = function(winid)
            return {
                "  " .. filename.unique(winid) .. " ",
                hl = { fg = palette.yellow, bg = palette.cursor_hover },
            }
        end,
        left_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
        right_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
    },
    win = {
        label = function(winid)
            return {
                "  " .. filename.unique(winid) .. " ",
                hl = { fg = palette.yellow, bg = palette.cursor_hover },
            }
        end,
        left_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
        right_sep = { "", hl = { fg = palette.cursor_hover, bg = palette.cobalt_bg } },
    },
    tail = {
        { "", hl = { fg = palette.yellow, bg = palette.cobalt_bg } },
        { "  ", hl = { fg = palette.black, bg = palette.yellow } },
    },
}

tabby.setup({ tabline = line })
