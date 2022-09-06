local ok, bufferline = lk.require("bufferline")
if not ok then
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

----------------------------------------------------------------------
-- NOTE: scope.nvim setup {{{
----------------------------------------------------------------------
local scope_ok, scope = lk.require("scope")
if not scope_ok then
  return
end

scope.setup()
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
