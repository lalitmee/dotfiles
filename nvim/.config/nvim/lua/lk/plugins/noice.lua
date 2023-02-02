local M = {
    "folke/noice.nvim",
    event = { "VeryLazy" },
}

M.enabled = false

 M.config = function()
    -- noice.setup({
    --     lsp = {
    --         override = {
    --             ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --             ["vim.lsp.util.stylize_markdown"] = true,
    --             ["cmp.entry.get_documentation"] = true,
    --         },
    --     },
    --     presets = {
    --         bottom_search = false,
    --         command_palette = false,
    --         long_message_to_split = true,
    --         inc_rename = true,
    --         cmdline_output_to_split = false,
    --         lsp_doc_border = true,
    --     },
    --     messages = {
    --         view = "mini",
    --     },
    --     views = {
    --         cmdline_popup = {
    --             position = {
    --                 row = 5,
    --                 col = "50%",
    --             },
    --             size = {
    --                 width = 60,
    --                 height = "auto",
    --             },
    --         },
    --         popupmenu = {
    --             relative = "editor",
    --             position = {
    --                 row = 8,
    --                 col = "50%",
    --             },
    --             size = {
    --                 width = 60,
    --                 height = 10,
    --             },
    --             border = {
    --                 style = "rounded",
    --                 padding = { 0, 1 },
    --             },
    --             win_options = {
    --                 winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
    --             },
    --         },
    --     },
    -- })

    require("noice").setup({
        popupmenu = {
            -- backend = "cmp",
        },
        views = {
            split = {
                win_options = {
                    winhighlight = { Normal = "Normal" },
                },
            },
            cmdline_popup = {
                position = {
                    row = 10,
                    col = "50%",
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 13,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = lk.style.border.rounded,
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
                },
            },
        },
        routes = {
            {
                filter = { event = "msg_show", kind = "search_count" },
                opts = { skip = true },
            },
            {
                filter = { event = "msg_show", kind = "", find = "written" },
                opts = { skip = true },
            },
        },
    })
end

return M
