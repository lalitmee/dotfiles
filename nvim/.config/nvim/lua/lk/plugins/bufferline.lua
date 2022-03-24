local groups = require("bufferline.groups")
local List = require("plenary.collections.py_list")

local fn = vim.fn

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
require("bufferline").setup({
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
    groups = {
      options = { toggle_hidden_on_enter = true },
      items = {
        groups.builtin.ungrouped,
        {
          highlight = { guisp = "#51AFEF", gui = "underline" },
          name = "tests",
          icon = "",
          matcher = function(buf)
            return buf.filename:match("_spec") or buf.filename:match("test")
          end,
        },
        {
          name = "view models",
          highlight = { guisp = "#03589C", gui = "underline" },
          matcher = function(buf)
            return buf.filename:match("view_model%.dart")
          end,
        },
        {
          name = "screens",
          matcher = function(buf)
            return buf.path:match("screen")
          end,
        },
        {
          name = "terminals",
          matcher = function(buf)
            return buf.filename:match("/usr/bin/zsh")
          end,
        },
        {
          highlight = { guisp = "#C678DD", gui = "underline" },
          name = "docs",
          auto_close = true,
          matcher = function(buf)
            local list = List({ "md", "txt", "org", "norg", "wiki" })
            return list:contains(fn.fnamemodify(buf.path, ":e"))
          end,
        },
      },
    },
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
