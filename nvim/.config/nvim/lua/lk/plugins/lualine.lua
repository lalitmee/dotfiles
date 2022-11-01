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

----------------------------------------------------------------------
-- NOTE: winbar {{{
----------------------------------------------------------------------
local function get_winbar()
    return require("lk.utils.winbar").eval()
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
local winbar_excluded_filetypes = {
    "",
    "DressingSelect",
    "Jaq",
    "NeogitCommitMessage",
    "NeogitCommitPopup",
    "NeogitHelpPopup",
    "NeogitPopup",
    "NeogitStatus",
    "NvimTree",
    "Outline",
    "OverseerList",
    "Trouble",
    "Trouble",
    "alpha",
    "checkhealth",
    "dap-repl",
    "dap-terminal",
    "dapui_breakpoints",
    "dapui_console",
    "dapui_scopes",
    "dapui_stacks",
    "dapui_watches",
    "dashboard",
    "dirbuf",
    "harpoon",
    "help",
    "lab",
    "lir",
    "markdown",
    "packer",
    "qf",
    "spectre_panel",
    "startify",
    "toggleterm",
    "fugitive",
}

lualine.setup({
    options = {
        theme = "cobalt2",
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {
            winbar = winbar_excluded_filetypes,
        },
    },
    sections = {
        lualine_a = {
            {
                "searchcount",
                color = "LualineSessionName",
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
                color = {
                    gui = "bold",
                },
            },
        },
        lualine_c = {
            { "%=", type = "stl" },
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            {
                "filename",
                path = 1,
                color = {
                    gui = "bold",
                },
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = {
                    error = " ",
                    warn = " ",
                    hint = " ",
                    info = " ",
                },
            },
        },
        lualine_x = {
            { get_trailing_whitespace },
        },
        lualine_y = {
            {
                "progress",
                color = {
                    gui = "bold",
                },
            },
        },
        lualine_z = {
            {
                "location",
                color = {
                    gui = "bold",
                },
            },
        },
    },
    winbar = {
        lualine_c = {
            { get_winbar },
        },
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_c = {
            {
                "filetype",
                icon_only = true,
            },
            {
                "filename",
                path = 1,
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
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
