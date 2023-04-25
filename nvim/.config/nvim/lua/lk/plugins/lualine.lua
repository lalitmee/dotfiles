local M = {
    "nvim-lualine/lualine.nvim",
    event = { "BufEnter" },
}

M.config = function()
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
            },
        },
        extensions = {
            "man",
            "nvim-tree",
            "quickfix",
            "toggleterm",
        },
    })
end

return M
