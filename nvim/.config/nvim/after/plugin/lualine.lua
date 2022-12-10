local ok, lualine = lk.require("lualine")
if not ok then
    return
end

----------------------------------------------------------------------
-- NOTE: trailing whitespaces {{{
----------------------------------------------------------------------
local function get_trailing_whitespace()
    local space = vim.fn.search([[\s\+$]], "nwc")
    return space ~= 0 and "TW:" .. space or ""
end
-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: active lsp clients {{{
--------------------------------------------------------------------------------
local function get_active_lsp_clients()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    local active_clients = {}
    for _, client in ipairs(clients) do
        table.insert(active_clients, client.name)
    end
    return table.concat(active_clients, ", ")
end
-- }}}
--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
lualine.setup({
    options = {
        theme = "cobalt2",
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
                "filetype",
                icon_only = true,
                padding = { left = 1, right = 0 },
            },
            {
                "filename",
                path = 1,
                color = {
                    gui = "bold",
                },
            },
        },
        lualine_c = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = {
                    error = "",
                    warn = "",
                    hint = "",
                    info = "",
                },
            },
        },
        lualine_x = {
            { get_active_lsp_clients },
            { get_trailing_whitespace },
        },
        lualine_y = {
            {
                "branch",
                icon = "",
                color = {
                    gui = "bold",
                },
            },
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
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
