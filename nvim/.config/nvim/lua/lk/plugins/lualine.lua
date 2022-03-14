local colors = require("cobalt2.palette")
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

--------------------------------------------------------------------------------
-- NOTE: to get the current client server name {{{
--------------------------------------------------------------------------------
local function get_client_name()
  local msg = "No Active Lsp"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return "[ ⚙ LSP: " .. client.name .. " ]"
    end
  end
  return msg
end
-- }}}
--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
lualine.setup({
  options = {
    theme = "auto",
    -- theme = 'cobalt2',
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { { "mode", fmt = string.upper } },
    lualine_b = { { "branch", icon = "" } },
    lualine_c = {
      { "filetype", icon_only = true },
      { "filename", path = 1 },
      { "diff" },
      {
        "lsp_progress",
        colors = {
          lsp_client_name = colors.yellow,
          title = colors.white,
          message = colors.dark_orange,
          percentage = colors.blue,
          spinner = colors.dark_pink,
          use = true,
        },
        display_components = { "lsp_client_name", { "title", "message", "percentage" }, "spinner" },
        separators = {
          message = { commenced = ".", completed = "OK" },
        },
        spinner_symbols = {
          "[    ]",
          "[=   ]",
          "[==  ]",
          "[=== ]",
          "[ ===]",
          "[  ==]",
          "[   =]",
          "[    ]",
          "[   =]",
          "[  ==]",
          "[ ===]",
          "[====]",
          "[=== ]",
          "[==  ]",
          "[=   ]",
        },
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", hint = " ", info = " " },
        update_in_insert = true,
      },
      {
        get_client_name,
        color = { fg = colors.yellow },
      },
      { "filesize" },
      { "filetype" },
      {
        auto_session_library.current_session_name,
        color = { fg = colors.black, bg = colors.blue },
      },
    },
    lualine_y = { { "progress" } },
    lualine_z = { { "location" } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 0 } },
    lualine_x = { "filetype" },
    lualine_z = { "location" },
  },
  extensions = { "fzf", "fugitive", "nvim-tree", "quickfix", "toggleterm", "symbols-outline" },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker