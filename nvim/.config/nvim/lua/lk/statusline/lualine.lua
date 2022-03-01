local ok, lualine = lk.safe_require("lualine")
if not ok then
  return
end

-- NOTE: to get the current client server name
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
      { "lsp_progress" },
      { "diff" },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = { error = " :", warn = " :", info = " :", hint = "💡" },
        update_in_insert = true,
      },
      {
        get_client_name,
        color = { fg = "#FFC600" },
      },
      { "filesize" },
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
