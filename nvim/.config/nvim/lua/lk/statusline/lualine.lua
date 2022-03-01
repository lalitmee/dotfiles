local ok, lualine = lk.safe_require("lualine")
if not ok then
  return
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
      {
        "diagnostics",
        -- sources = { "coc" },
        sources = { "nvim_diagnostic" },
        symbols = { error = " :", warn = " :", info = " :", hint = "💡" },
        update_in_insert = true,
      },
      { "lsp_progress" },
      { "diff" },
    },
    lualine_x = { { "filesize" } },
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
  -- tabline = {
  --   lualine_a = { 'buffers' },
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = { 'tabs' },
  -- },
  extensions = { "fzf", "fugitive", "nvim-tree", "quickfix", "toggleterm" },
})
