local M = {
    "nanozuki/tabby.nvim",
    dependencies = { "tiagovla/scope.nvim" },
}

function M.config()
    local ok, tabby = lk.require("tabby")
    if not ok then
        return
    end

    local scope_ok, scope = lk.require("scope")
    if not scope_ok then
        return
    end

    scope.setup()

    local util = require("tabby.util")
    local filename = require("tabby.filename")

    local hl_tabline_sel = util.extract_nvim_hl("lualine_a_normal")
    local hl_tabline = util.extract_nvim_hl("lualine_b_normal")
    local hl_tabline_fill = util.extract_nvim_hl("lualine_c_normal")

    -- local palette = require("cobalt2.palette")
    -- local hl_tabline_sel = { bg = palette.yellow, fg = palette.black }
    -- local hl_tabline = { bg = palette.darker_blue, fg = palette.black }
    -- local hl_tabline_fill = { bg = palette.cursor_line, fg = palette.black }

    --------------------------------------------------------------------------------
    --  NOTE: icons and separators {{{
    --------------------------------------------------------------------------------
    local space_between = " "
    local separators = {
        -- right = "",
        -- left = "",
        right = " ",
        left = "",
    }
    local icons = {
        tab = { active = "  ", inactive = "  " },
        win = { top = "  ", normal = "  " },
        tail = "  ",
    }
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: utilities {{{
    --------------------------------------------------------------------------------
    local cwd = function()
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
    end

    local tabname = function(tabid)
        return vim.api.nvim_tabpage_get_number(tabid)
    end

    local left_sep = function()
        return { separators.left, hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } }
    end

    local right_sep = function()
        return { separators.right, hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } }
    end

    local tab_label = function(id, icon)
        return {
            icon .. tabname(id) .. space_between,
            hl = {
                fg = hl_tabline_sel.bg,
                bg = hl_tabline.bg,
                style = "bold",
            },
        }
    end

    local win_label = function(id, icon)
        return {
            icon .. filename.unique(id) .. space_between,
            hl = {
                fg = hl_tabline_sel.bg,
                bg = hl_tabline.bg,
                style = "bold",
            },
        }
    end

    -- }}}
    --------------------------------------------------------------------------------

    local line = {
        hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg },
        layout = "active_tab_with_wins",
        head = {
            {
                cwd,
                hl = {
                    fg = hl_tabline_sel.fg,
                    bg = hl_tabline_sel.bg,
                    style = "bold",
                },
            },
            {
                separators.right,
                hl = {
                    fg = hl_tabline_sel.bg,
                    bg = hl_tabline_fill.bg,
                },
            },
        },
        active_tab = {
            label = function(tabid)
                return tab_label(tabid, icons.tab.active)
            end,
            left_sep = left_sep(),
            right_sep = right_sep(),
        },
        inactive_tab = {
            label = function(tabid)
                return tab_label(tabid, icons.tab.inactive)
            end,
            left_sep = left_sep(),
            right_sep = right_sep(),
        },
        top_win = {
            label = function(winid)
                return win_label(winid, icons.win.top)
            end,
            left_sep = left_sep(),
            right_sep = right_sep(),
        },
        win = {
            label = function(winid)
                return win_label(winid, icons.win.normal)
            end,
            left_sep = left_sep(),
            right_sep = right_sep(),
        },
        tail = {
            {
                separators.left,
                hl = {
                    fg = hl_tabline_sel.bg,
                    bg = hl_tabline_fill.bg,
                },
            },
            {
                icons.tail,
                hl = {
                    fg = hl_tabline_sel.fg,
                    bg = hl_tabline_sel.bg,
                    style = "bold",
                },
            },
        },
    }

    tabby.setup({ tabline = line })
end

return M
