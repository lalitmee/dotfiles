local ok, lualine = lk.safe_require("lualine")
if not ok then
  vim.notify("Failed to load lualine", "error", { title = "[lualine.nvim] error" })
  return
end

----------------------------------------------------------------------
-- NOTE: custom filename component {{{
----------------------------------------------------------------------
local custom_fname = require("lualine.components.filename"):extend()
local highlight = require("lualine.highlight")
local colors = require("cobalt2.palette")
local default_status_colors = { saved = colors.green, modified = colors.red }

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      { fg = default_status_colors.saved },
      "filename_status_saved",
      self.options
    ),
    modified = highlight.create_component_highlight_group(
      { fg = default_status_colors.modified },
      "filename_status_modified",
      self.options
    ),
  }
  if self.options.color == nil then
    self.options.color = ""
  end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  data = highlight.component_format_highlight(
    vim.bo.modified and self.status_colors.modified or self.status_colors.saved
  ) .. data
  return data
end

-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: to get the current client server name {{{
--------------------------------------------------------------------------------
local function get_client_name()
  local msg = "[No Active Lsp]"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return "[⚙ LSP: " .. client.name .. "]"
      -- return "[" .. client.name .. "]"
    end
  end
  return msg
end
-- }}}
--------------------------------------------------------------------------------

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
lualine.setup({
  options = {
    theme = "auto",
    globalstatus = true,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    disabled_filetypes = {
      winbar = { "NvimTree", "NeogitStatus", "NeogitCommitMessage" },
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return "<" .. str:sub(1, 1) .. ">"
        end,
      },
    },
    lualine_b = {
      {
        "branch",
        icon = "",
      },
    },
    lualine_c = {
      { "diff" },
      { "%=", type = "stl" },
      { "filetype", icon_only = true },
      {
        custom_fname,
        path = 1,
        color = "LualineFileName",
        symbols = {
          modified = " []",
          readonly = " []",
        },
      },
      {
        get_client_name,
        color = "LualineSessionName",
        separator = { right = "", left = "" },
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
    lualine_y = { { "progress" } },
    lualine_z = { { "location", icon = "" } },
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
    lualine_c = { get_winbar, { color = { link = "Cursor" } } },
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

----------------------------------------------------------------------
-- NOTE: lsp_progress {{{
----------------------------------------------------------------------
-- {
--   "lsp_progress",
--   colors = {
--     lsp_client_name = colors.yellow,
--     title = colors.white,
--     message = colors.dark_orange,
--     percentage = colors.blue,
--     spinner = colors.dark_pink,
--     use = true,
--   },
--   display_components = { "lsp_client_name", { "title", "message", "percentage" }, "spinner" },
--   timer = { spinner = 200 },
--   separators = {
--     message = { commenced = ".", completed = "OK" },
--   },
--   spinner_symbols = {
--     "[    ]",
--     "[=   ]",
--     "[==  ]",
--     "[=== ]",
--     "[ ===]",
--     "[  ==]",
--     "[   =]",
--     "[    ]",
--     "[   =]",
--     "[  ==]",
--     "[ ===]",
--     "[====]",
--     "[=== ]",
--     "[==  ]",
--     "[=   ]",
--   },
-- },
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
