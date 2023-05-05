local M = {
    "nanozuki/tabby.nvim",
    event = { "VimEnter" },
}

-- M.enabled = false

M.config = function()
    vim.opt.showtabline = 2
    local palette = require("cobalt2.palette")

    local separators = {
        -- right = "",
        -- left = "",
        right = " ",
        left = "",
    }
    local icons = {
        tab = { active = "", inactive = "" },
        win = { top = "", normal = "" },
        tail = "  ",
    }

    local theme = {
        line = { fg = palette.black, bg = palette.cursor_line },
        head = { fg = palette.black, bg = palette.yellow, style = "bold" },
        current_tab = {
            fg = palette.yellow,
            bg = palette.darker_blue,
            style = "bold",
        },
        tab = { fg = palette.white, bg = palette.darker_blue },
        win = { fg = palette.white, bg = palette.darker_blue },
        tail = { fg = palette.black, bg = palette.yellow, style = "bold" },
    }

    local line = function(line)
        local cwd = " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
        return {
            {
                { cwd, hl = theme.head },
                line.sep(separators.right, theme.head, theme.line),
            },
            line.tabs().foreach(function(tab)
                local hl = tab.is_current() and theme.current_tab or theme.tab
                return {
                    line.sep(separators.left, hl, theme.line),
                    tab.is_current() and icons.tab.active or icons.tab.inactive,
                    string.format("%s:", tab.number()),
                    tab.name(),
                    line.sep(separators.right, hl, theme.line),
                    margin = " ",
                    hl = hl,
                }
            end),
            line.spacer(),
            line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
                return {
                    line.sep(separators.left, theme.win, theme.line),
                    win.is_current() and icons.win.top or icons.win.normal,
                    win.buf_name(),
                    line.sep(separators.right, theme.win, theme.line),
                    margin = " ",
                    hl = theme.win,
                }
            end),
            {
                line.sep(separators.left, theme.tail, theme.line),
                { icons.tail, hl = theme.tail },
            },
            hl = theme.line,
        }
    end

    require("tabby.tabline").set(line, {
        buf_name = { mode = "unique" },
    })
end

return M
