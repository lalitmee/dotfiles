local tabby = {
    "nanozuki/tabby.nvim",
    event = { "VimEnter" },
    config = function()
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
                    local hl = tab.is_current() and theme.current_tab
                        or theme.tab
                    return {
                        line.sep(separators.left, hl, theme.line),
                        tab.is_current() and icons.tab.active
                            or icons.tab.inactive,
                        string.format("%s:", tab.number()),
                        tab.name(),
                        line.sep(separators.right, hl, theme.line),
                        margin = " ",
                        hl = hl,
                    }
                end),
                line.spacer(),
                line.wins_in_tab(line.api.get_current_tab())
                    .foreach(function(win)
                        return {
                            line.sep(separators.left, theme.win, theme.line),
                            win.is_current() and icons.win.top
                                or icons.win.normal,
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
    end,
}

local lualine = {
    "nvim-lualine/lualine.nvim",
    event = { "BufEnter" },
    config = function()
        local function get_trailing_whitespace()
            local space = vim.fn.search([[\s\+$]], "nwc")
            return space ~= 0 and "TW:" .. space or ""
        end

        local function get_active_lsp_clients()
            local bufnr = vim.fn.bufnr(0)
            local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
            local active_clients = {}
            for _, client in ipairs(clients) do
                table.insert(active_clients, client.name)
            end
            return table.concat(active_clients, ", ")
        end

        require("lualine").setup({
            options = {
                theme = "auto",
                globalstatus = true,
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = {
                    {
                        require("NeoComposer.ui").status_recording,
                        color = "lualine_b_normal",
                    },
                    {
                        "searchcount",
                        color = "lualine_b_normal",
                    },
                    {
                        "selectioncount",
                        color = "lualine_b_normal",
                    },
                    {
                        "mode",
                        fmt = function(str)
                            return "<" .. str:sub(1, 1) .. ">"
                        end,
                        color = {
                            gui = "bold",
                        },
                    },
                },
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                        fmt = function(str)
                            if vim.api.nvim_strwidth(str) > 40 then
                                return ("%s…"):format(str:sub(1, 39))
                            end

                            return str
                        end,
                    },
                },
                lualine_c = {
                    { "%=", type = "stl" },
                    {
                        "filetype",
                        icon_only = true,
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        path = 1,
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = "E:",
                            warn = "W:",
                            hint = "H:",
                            info = "I:",
                        },
                        always_visible = false,
                    },
                },
                lualine_x = {
                    { "overseer" },
                    { get_active_lsp_clients },
                    { get_trailing_whitespace },
                },
                lualine_y = {
                    { "progress" },
                },
                lualine_z = {
                    { "location", color = { gui = "bold" } },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = "lualine_b_normal",
                    },
                },
            },
            extensions = {
                "man",
                "nvim-tree",
                "quickfix",
                "toggleterm",
            },
        })
    end,
}

return {
    lualine,
    tabby,
}
