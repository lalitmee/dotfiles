local command = lk.command
local border, L = lk.style.border.rounded, vim.log.levels

return {
    { --[[ dressing ]]
        "stevearc/dressing.nvim",
        event = { "VeryLazy" },
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        config = function()
            -- NOTE: the limit is half the max lines because this is the cursor theme so
            -- unless the cursor is at the top or bottom it realistically most often will
            -- only have half the screen available
            local function get_height(self, _, max_lines)
                local results = #self.finder.results
                local PADDING = 4 -- this represents the size of the telescope window
                local LIMIT = math.floor(max_lines / 2)
                return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
            end

            local theme = require("telescope.themes").get_dropdown({
                layout_config = { height = get_height },
            })

            require("dressing").setup({
                input = {
                    insert_only = false,
                    win_options = { winblend = 0 },
                    title_pos = "center",
                    get_config = function(opts)
                        if opts.kind == "browse" then
                            return {
                                relative = "editor",
                                max_width = { 140, 0.9 },
                                min_width = { 40, 0.4 },
                            }
                        end
                    end,
                },
                select = {
                    winblend = 0,
                    get_config = function(opts)
                        -- center the picker for treesitter prompts
                        if opts.kind == "codeaction" then
                            return {
                                backend = "telescope",
                                telescope = theme,
                            }
                        end
                    end,
                    telescope = theme,
                },
            })
        end,
    },

    { --[[ noice ]]
        "folke/noice.nvim",
        event = { "VeryLazy" },
        opts = {
            lsp = {
                progress = { enabled = true },
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
                        row = 10,
                        col = "50%",
                    },
                    size = {
                        width = 80,
                        height = "auto",
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 13,
                        col = "50%",
                    },
                    size = {
                        width = 80,
                        height = "auto",
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "DiagnosticSignInfo",
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
                {
                    filter = {
                        event = "notify",
                        min_height = 15,
                    },
                    view = "split",
                },
            },
            commands = {
                history = { view = "vsplit" },
            },
            presets = {
                inc_rename = true,
                command_palette = false,
                long_message_to_split = true,
                lsp_doc_border = true,
                bottom_search = false,
            },
        },
        -- enabled = false,
    },

    { --[[ notify ]]
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
                    if vim.api.nvim_win_is_valid(win) then
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
                if type(msg) == "string" then
                    if msg:match("warning: multiple different client offset_encodings") then
                        return
                    end
                    if msg:match("character_offset must be called") then
                        return
                    end
                    if msg:match("No information available") then
                        return
                    end
                end
                notify_filter(msg, ...)
            end

            command("NotifyDismiss", notify.dismiss, {})
        end,
    },

    { --[[ virtcolumn ]]
        "xiyaowong/virtcolumn.nvim",
        event = { "VeryLazy" },
    },

    { --[[ devicons ]]
        "kyazdani42/nvim-web-devicons",
        config = true,
    },
}
