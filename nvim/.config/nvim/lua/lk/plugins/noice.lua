local M = {
    "folke/noice.nvim",
    event = { "VeryLazy" },
}

M.enabled = false

function M.config()
    local ok, noice = lk.require("noice")
    if not ok then
        return
    end

    noice.setup({
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = false,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = true,
            cmdline_output_to_split = false,
            lsp_doc_border = true,
        },
        messages = {
            view = "mini",
        },
        views = {
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 60,
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
                    width = 60,
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
        },
    })
end

return M
