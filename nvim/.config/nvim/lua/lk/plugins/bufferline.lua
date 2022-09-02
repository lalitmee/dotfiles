local ok, bufferline = lk.safe_require("bufferline")
if not ok then
  lk.package_notify("bufferline.nvim", "error")
  return
end

----------------------------------------------------------------------
-- NOTE: sorting of buffers {{{
----------------------------------------------------------------------
local function sort_by_mtime(a, b)
  local astat = vim.loop.fs_stat(a.path)
  local bstat = vim.loop.fs_stat(b.path)
  local mod_a = astat and astat.mtime.sec or 0
  local mod_b = bstat and bstat.mtime.sec or 0
  return mod_a > mod_b
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
bufferline.setup({
  options = {
    sort_by = sort_by_mtime,
    numbers = "none",
    separator_style = "thick",
    show_close_icon = false,
    show_buffer_close_icons = false,
    diagnostics = "coc",
    offsets = {
      {
        filetype = "undotree",
        text = "Undotree",
        highlight = "PanelHeading",
        padding = 1,
      },
      {
        filetype = "NvimTree",
        text = "Explorer",
        highlight = "PanelHeading",
        padding = 1,
      },
      {
        filetype = "DiffviewFiles",
        text = "Diff View",
        highlight = "PanelHeading",
        padding = 1,
      },
      {
        filetype = "flutterToolsOutline",
        text = "Flutter Outline",
        highlight = "PanelHeading",
      },
      {
        filetype = "packer",
        text = "Packer",
        highlight = "PanelHeading",
        padding = 1,
      },
    },
    custom_areas = {},
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
