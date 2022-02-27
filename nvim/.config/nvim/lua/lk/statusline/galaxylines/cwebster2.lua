local gl = require("galaxyline")
local gls = gl.section
local extension = require("galaxyline.provider_extensions")
local fileinfo = require("galaxyline.provider_fileinfo")
local diagnostic = require("galaxyline.provider_diagnostic")
local condition = require("galaxyline.condition")
local u = require("utils").u
local theme = require("theme")
local colors = theme.galaxyline_colors
local mode_color = theme.mode_color

-- heavily based from the following links
-- https://github.com/kraftwerk28/dotfiles/blob/master/.config/nvim/lua/cfg/galaxyline.lua
-- https://github.com/LoydAndrew/nvim/blob/main/evilline.lua

gl.short_line_list = {
  "LuaTree",
  "vista",
  "dbui",
  "startify",
  "term",
  "nerdtree",
  "fugitive",
  "fugitiveblame",
  "plug",
}

VistaPlugin = extension.vista_nearest

local sep = {
  slant_left = "",
  slant_right = "",
  slant_alt_left = "",
  slant_alt_right = "",
  right_filled = u("e0b2"),
  left_filled = u("e0b0"),
  right = u("e0b3"),
  left = u("e0b1"),
}

local icons = {
  locked = "🔒",
  unsaved = u("f693"),
  dos = u("e70f"),
  unix = u("f17c"),
  mac = u("f179"),
  error = "✘",
  warning = "⚠",
  branch = " ",
}

local mode_map = {
  n = "NORMAL",
  i = "INSERT",
  c = "COMMAND",
  V = "VISUAL",
  [""] = "VISUAL",
  v = "VISUAL",
  -- c  = 'COMMAND-LINE',
  ["r?"] = ":CONFIRM",
  rm = "--MORE",
  R = "REPLACE",
  Rv = "VIRTUAL",
  s = "SELECT",
  S = "SELECT",
  ["r"] = "HIT-ENTER",
  [""] = "SELECT",
  t = "TERMINAL",
  ["!"] = "SHELL",
}
local mode_alias = mode_map

local function has_file_type()
  local f_type = vim.bo.filetype
  if not f_type or f_type == "" then
    return false
  end
  return true
end

local function mode_label()
  return mode_map[vim.fn.mode()] or "N/A"
end
local function mode_hl()
  return mode_color[vim.fn.mode()] or colors.none
end

local function highlight(group, fg, bg, gui)
  local cmd = string.format("highlight %s guifg=%s guibg=%s", group, fg, bg)
  if gui ~= nil then
    cmd = cmd .. " gui=" .. gui
  end
  vim.cmd(cmd)
end

local function buffer_not_empty()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

local function diagnostic_exists()
  return vim.tbl_isempty(vim.lsp.buf_get_clients(0))
end

local function wide_enough()
  local squeeze_width = vim.fn.winwidth(0)
  if squeeze_width > 80 then
    return true
  end
  return false
end

local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

gls.left = {
  {
    FirstElement = {
      provider = function()
        return " "
      end,
      highlight = { colors.blue, colors.line_bg },
    },
  },
  {
    ViMode = {
      provider = function()
        -- auto change color according the vim mode
        highlight("GalaxyViMode", mode_hl(), colors.line_bg)
        return mode_label() .. " "
      end,
      highlight = { mode_hl(), colors.line_bg, "bold" },
    },
  },
  {
    GitIcon = {
      provider = function()
        return "  "
      end,
      condition = condition.check_git_workspace,
      separator = " ",
      separator_highlight = { "NONE", colors.bg },
      highlight = { colors.violet, colors.bg, "bold" },
    },
  },
  {
    GitBranch = {
      provider = "GitBranch",
      condition = condition.check_git_workspace,
      highlight = { colors.violet, colors.bg, "bold" },
    },
  },
  {
    Spacer = {
      provider = function()
        return " "
      end,
      highlight = { colors.fg, colors.line_bg },
    },
  },
  {
    DiffAdd = {
      provider = "DiffAdd",
      condition = checkwidth,
      icon = " ",
      highlight = { colors.green, colors.line_bg },
    },
  },
  {
    DiffModified = {
      provider = "DiffModified",
      condition = checkwidth,
      icon = " ",
      highlight = { colors.diffchg, colors.line_bg },
    },
  },
  {
    DiffRemove = {
      provider = "DiffRemove",
      condition = checkwidth,
      icon = " ",
      highlight = { colors.red, colors.line_bg },
    },
  },
  {
    FileIcon = {
      provider = "FileIcon",
      condition = buffer_not_empty,
      highlight = {
        require("galaxyline.provider_fileinfo").get_file_icon_color,
        colors.line_bg,
      },
    },
  },
  {
    FileName = {
      provider = { "FileName", "FileSize" },
      condition = buffer_not_empty,
      highlight = { colors.fg, colors.line_bg, "italic" },
    },
  },
  -- {
  --  FileStatus = {
  --    provider = function()
  --      local status = ""
  --      if vim.bo.readonly then status = status .. ' ' .. icons.locked end
  --      if vim.bo.modified then status = status .. ' ' .. icons.unsaved end
  --      return ' ' .. status .. ' '
  --    end,
  --    highlight = {colors.red, colors.line_bg}
  --  }
  -- },
  {
    LeftEnd = {
      provider = function()
        return ""
      end,
      separator = sep.slant_alt_left,
      -- separator = sep.slant_left,
      separator_highlight = { colors.line_bg, colors.bg_none },
      highlight = { colors.line_bg, colors.line_bg },
    },
  },
  {
    VistaNearest = {
      provider = extension.vista_nearest,
      highlight = { colors.gray, colors.bg_none },
    },
  },
}
-- gls.left[11] = {
--    TrailingWhiteSpace = {
--     provider = TrailingWhiteSpace,
--     icon = '  ',
--     highlight = {colors.yellow,colors.bg},
--    }
-- }

gls.right = {
  {
    FileType = {
      provider = function()
        if not buffer_not_empty() then
          return ""
        end
        local icon = icons[vim.bo.fileformat] or ""
        return string.format(" %s %s ", icon, vim.bo.filetype)
      end,
      highlight = { colors.gray, colors.bg_none },
    },
  },
  {
    FileEncoding = {
      provider = function()
        return string.lower(fileinfo.get_file_encode())
      end,
      highlight = { colors.gray, colors.bg_none },
    },
  },
  {
    RightEnd = {
      provider = function()
        return ""
      end,
      separator = sep.slant_alt_right,
      separator_highlight = { colors.line_bg, colors.bg_none },
      highlight = { colors.line_bg, colors.line_bg },
    },
  },
  {
    LspStatus = {
      provider = function()
        local clients = vim.lsp.buf_get_clients(0)
        local connected = not vim.tbl_isempty(clients)
        if connected then
          local status = " " .. u("f817") .. " ( "
          for id, client in ipairs(clients) do
            status = status .. client.name .. " "
          end
          status = status .. ") "
          return status
        else
          return ""
        end
      end,
      highlight = { colors.fg, colors.line_bg },
    },
  },
  {
    DiagnosticWarn = {
      provider = function()
        local n = vim.lsp.diagnostic.get_count(0, "Warning")
        if n == 0 then
          return ""
        end
        return string.format(" %s %d ", icons.warning, n)
      end,
      highlight = { "yellow", colors.line_bg },
    },
    DiagnosticError = {
      -- provider = diagnostic.get_diagnostic_error,
      provider = function()
        local n = vim.lsp.diagnostic.get_count(0, "Error")
        if n == 0 then
          return ""
        end
        return string.format(" %s %d ", icons.error, n)
      end,
      highlight = { "red", colors.line_bg },
    },
  },
  {
    PositionInfo = {
      provider = {
        function()
          return string.format(" %s:%s ", vim.fn.line("."), vim.fn.col("."))
        end,
      },
      highlight = { colors.fg, colors.bg_none },
      condition = buffer_not_empty,
      separator = sep.slant_alt_left,
      separator_highlight = { colors.line_bg, colors.bg_none },
    },
  },
  {
    PercentInfo = {
      provider = fileinfo.current_line_percent,
      highlight = { colors.fg, colors.bg_none },
      condition = buffer_not_empty,
    },
  },
}

-- for k, v in pairs(gls.left) do gls.short_line_left[k] = v end
-- table.remove(gls.short_line_left, 1)
--
-- for k, v in pairs(gls.right) do gls.short_line_right[k] = v end
-- table.remove(gls.short_line_right)
-- table.remove(gls.short_line_right)

-- gls.right[1]= {
--  FileFormat = {
--    provider = 'FileFormat',
--    separator = ' ',
--    separator_highlight = {colors.bg,colors.line_bg},
--    highlight = {colors.fg,colors.line_bg,'bold'},
--  }
-- }
-- gls.right[4] = {
--  LineInfo = {
--    provider = 'LineColumn',
--    separator = ' | ',
--    separator_highlight = {colors.blue,colors.line_bg},
--    highlight = {colors.fg,colors.line_bg},
--  },
-- }
-- gls.right[5] = {
--  PerCent = {
--    provider = 'LinePercent',
--    separator = ' ',
--    separator_highlight = {colors.line_bg,colors.line_bg},
--    highlight = {colors.cyan,colors.darkblue,'bold'},
--  }
-- }
--
---- gls.right[4] = {
----   ScrollBar = {
----     provider = 'ScrollBar',
----     highlight = {colors.blue,colors.purple},
----   }
---- }
----
---- gls.right[3] = {
----   Vista = {
----     provider = VistaPlugin,
----     separator = ' ',
----     separator_highlight = {colors.bg,colors.line_bg},
----     highlight = {colors.fg,colors.line_bg,'bold'},
----   }
---- }
--
gls.short_line_left[1] = {
  BufferType = {
    provider = "FileTypeName",
    condition = has_file_type,
    highlight = { colors.gray, colors.line_bg },
  },
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon",
    condition = has_file_type,
    highlight = { colors.gray, colors.line_bg },
  },
}
