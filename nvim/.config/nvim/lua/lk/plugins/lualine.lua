local ok, lualine = lk.safe_require("lualine")
if not ok then
  vim.notify("Failed to load lualine", "error", { title = "[lualine.nvim] error" })
  return
end

local auto_session_ok, auto_session_library = lk.safe_require("auto-session-library")
if not auto_session_ok then
  vim.notify("Failed to load auto-session-library", "error", { title = "[auto-session-library.nvim] error" })
  return
end

----------------------------------------------------------------------
-- NOTE: get session name {{{
----------------------------------------------------------------------
local function get_session_name()
  local session_name = auto_session_library.current_session_name()
  if session_name == nil then
    return "No Active Session"
  end
  -- return "[⚙ Session: " .. session_name .. "]"
  return "[" .. session_name .. "]"
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: custom filename component {{{
----------------------------------------------------------------------
local custom_fname = require("lualine.components.filename"):extend()
local highlight = require("lualine.highlight")
local colors = require("cobalt2.palette")
local default_status_colors = {
  saved = colors.green,
  modified = colors.red,
}

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
      --[[ return "[⚙ LSP: " .. client.name .. "]" ]]
      return "[" .. client.name .. "]"
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
-- NOTE: scrollbar {{{
----------------------------------------------------------------------
local function get_scroll_bar()
  local sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" }
  local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)
  local i = math.floor(curr_line / lines * (#sbar - 1)) + 1
  return string.rep(sbar[i], 2)
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
      },
    },
    lualine_b = {
      {
        "branch",
        icon = "",
      },
    },
    lualine_c = {
      --[[ { "%=", type = "stl" }, ]]
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
      { require("nomodoro").status },
      {
        get_client_name,
        color = "LualineSessionName",
      },
    },
    lualine_y = { { "progress" } },
    lualine_z = {
      { "location" },
      {
        get_scroll_bar,
        padding = 0,
        color = {
          fg = colors.yellow,
          bg = colors.cursor_hover,
        },
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
  tabline = {
    lualine_a = {
      {
        "buffers",
        mode = 2,
        filetype_names = {
          mason = "Mason.nvim",
        },
        buffers_color = {
          active = { fg = colors.yellow, bg = colors.darker_blue },
          inactive = { fg = colors.yellow, bg = colors.cobalt_bg },
        },
      },
    },
    lualine_b = {},
    lualine_x = {},
    lualine_y = {
      { "tabs" },
    },
    lualine_z = {
      {
        get_session_name,
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
