local api = vim.api
local border, L = lk.style.border.rounded, vim.log.levels

local noice = {
    "folke/noice.nvim",
    event = { "VeryLazy" },
    opts = {
        cmdline = {
            format = {
                cmdline = { title = "" },
                lua = { title = "" },
                search_down = { title = "" },
                search_up = { title = "" },
                filter = { title = "" },
                help = { title = "" },
                input = { title = "" },
                IncRename = { title = "" },
                substitute = {
                    pattern = "^:%%?s/",
                    icon = " ",
                    ft = "regex",
                    title = "",
                },
            },
        },
        lsp = {
            documentation = {
                opts = {
                    border = { style = border },
                    position = { row = 2 },
                },
            },
            signature = {
                enabled = false,
                opts = {
                    position = { row = 2 },
                },
            },
            hover = { enabled = true },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        views = {
            vsplit = { size = { width = "auto" } },
            split = {
                win_options = {
                    winhighlight = { Normal = "Normal" },
                },
            },
            popup = {
                border = { style = border, padding = { 0, 1 } },
            },
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 80,
                    height = "auto",
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 8,
                    col = "50%",
                },
                size = {
                    width = 80,
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = {
                        Normal = "Normal",
                        FloatBorder = "FloatBorder",
                    },
                },
            },
            confirm = {
                border = {
                    style = border,
                    padding = { 0, 1 },
                    text = { top = "" },
                },
            },
        },
        redirect = { view = "popup", filter = { event = "msg_show" } },
        routes = {
            {
                opts = { skip = true },
                filter = {
                    any = {
                        { event = "msg_show", find = "written" },
                        { event = "msg_show", find = "%d+ lines, %d+ bytes" },
                        { event = "msg_show", kind = "search_count" },
                        { event = "msg_show", find = "%d+L, %d+B" },
                        { event = "msg_show", find = "^Hunk %d+ of %d" },
                        -- TODO: investigate the source of this LSP message and disable it happens in typescript files
                        { event = "notify", find = "No information available" },
                    },
                },
            },
            {
                view = "notify",
                filter = {
                    -- Hover when cursor not on anything
                    find = "No information available",
                },
                opts = { skip = true },
            },
            {
                view = "vsplit",
                filter = { event = "msg_show", min_height = 20 },
            },
            {
                view = "notify",
                filter = {
                    any = {
                        { event = "msg_show", min_height = 10 },
                        { event = "msg_show", find = "Treesitter" },
                    },
                },
                opts = { timeout = 10000 },
            },
            {
                view = "mini",
                filter = {
                    any = {
                        { event = "msg_show", find = "^E486:" },
                    },
                }, -- minimise pattern not found messages
            },
            {
                view = "notify",
                filter = {
                    any = {
                        { warning = true },
                        { event = "msg_show", find = "^Warn" },
                        { event = "msg_show", find = "^W%d+:" },
                        { event = "msg_show", find = "^No hunks$" },
                    },
                },
                opts = {
                    title = "Warning",
                    level = L.WARN,
                    merge = false,
                    replace = false,
                },
            },
            {
                view = "notify",
                opts = {
                    title = "Error",
                    level = L.ERROR,
                    merge = true,
                    replace = false,
                },
                filter = {
                    any = {
                        { error = true },
                        { event = "msg_show", find = "^Error" },
                        { event = "msg_show", find = "^E%d+:" },
                    },
                },
            },
            {
                view = "notify",
                opts = { title = "" },
                filter = {
                    kind = {
                        "emsg",
                        "echo",
                        "echomsg",
                    },
                },
            },
        },
        commands = {
            history = { view = "vsplit" },
        },
        presets = {
            inc_rename = true,
            command_palette = true,
            long_message_to_split = true,
            lsp_doc_border = true,
            bottom_search = false,
        },
    },
    enabled = false,
}

local nvim_notify = {
    "rcarriga/nvim-notify",
    event = { "VeryLazy" },
    init = function()
        local notify = require("notify")

        notify.setup({
            -- background_colour = "NormalFloat",
            timeout = 3000,
            stages = "slide",
            max_width = function()
                return math.floor(vim.go.columns * 0.8)
            end,
            max_height = function()
                return math.floor(vim.go.lines * 0.8)
            end,
            on_open = function(win)
                if api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_set_config(win, {
                        border = {
                            "╭",
                            "─",
                            "╮",
                            "│",
                            "╯",
                            "─",
                            "╰",
                            "│",
                        },
                    })
                end
            end,
            render = function(...)
                local notif = select(2, ...)
                local style = notif.title[1] == "" and "minimal" or "default"
                require("notify.render")[style](...)
            end,
            icons = lk.style.icons.notify,
        })
        vim.notify = notify

        local notify_filter = vim.notify
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.notify = function(msg, ...)
            if
                msg:match("warning: multiple different client offset_encodings")
            then
                return
            end
            if msg:match("character_offset must be called") then
                return
            end
            if msg:match("No information available") then
                return
            end

            notify_filter(msg, ...)
        end

        lk.command("NotifyDismiss", notify.dismiss, {})
    end,
}

local smartcolumn = {
    "m4xshen/smartcolumn.nvim",
    event = { "BufReadPost" },
    opts = {
        disabled_filetypes = {
            "toggleterm",
            "lazy",
            "mason",
            "help",
        },
    },
}

local devicons = {
    "yamatsum/nvim-nonicons",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
        require("nvim-web-devicons").setup({
            get_icons = require("nvim-nonicons"),
        })
    end,
}

return {
    devicons,
    noice,
    nvim_notify,
    smartcolumn,
}
