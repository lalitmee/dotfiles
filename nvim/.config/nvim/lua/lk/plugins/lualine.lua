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
-- NOTE: search count {{{
----------------------------------------------------------------------
local function search_count()
  if vim.api.nvim_get_vvar("hlsearch") == 1 then
    local res = vim.fn.searchcount({ maxcount = 999, timeout = 500 })

    if res.total > 0 then
      return string.format("[%d/%d]", res.current, res.total)
    end
  end
  return ""
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
}

lualine.setup({
  options = {
    theme = "auto",
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
        search_count,
        type = "lua_expr",
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
      { "filetype", icon_only = true },
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = {
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
      { get_trailing_whitespace },
    },
    lualine_y = {
      {
        "progress",
      },
    },
    lualine_z = {
      {
        "location",
        color = { gui = "bold" },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 0 } },
    lualine_x = { "filetype" },
    lualine_z = { "location" },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { get_winbar },
    lualine_x = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { get_winbar },
    lualine_x = {},
    lualine_z = {},
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
