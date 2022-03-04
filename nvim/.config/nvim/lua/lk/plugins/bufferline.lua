local groups = require("bufferline.groups")
local List = require("plenary.collections.py_list")

local fn = vim.fn

local function is_ft(b, ft)
  return vim.bo[b].filetype == ft
end

local symbols = { error = " ", warning = " ", info = " " }

local function diagnostics_indicator(_, _, diagnostics)
  local result = {}
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. count)
    end
  end
  result = table.concat(result, " ")
  return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
  local logs = vim.tbl_filter(function(b)
    return is_ft(b, "log")
  end, buf_nums)
  if vim.tbl_isempty(logs) then
    return true
  end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr("$")
  local is_log = is_ft(buf, "log")
  if last_tab == 1 then
    return true
  end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

---@diagnostic disable-next-line: unused-function, unused-local
local function sort_by_mtime(a, b)
  local astat = vim.loop.fs_stat(a.path)
  local bstat = vim.loop.fs_stat(b.path)
  local mod_a = astat and astat.mtime.sec or 0
  local mod_b = bstat and bstat.mtime.sec or 0
  return mod_a > mod_b
end

require("bufferline").setup({
  options = {
    sort_by = sort_by_mtime,
    numbers = "none",
    separator_style = "thick",
    -- separator_style = os.getenv 'KITTY_WINDOW_ID' and 'slant' or 'padded_slant',
    show_close_icon = false,
    show_buffer_close_icons = true,
    diagnostics = "coc",
    diagnostics_indicator = diagnostics_indicator,
    custom_filter = custom_filter,
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
