-- from glepnir dotfiles
-- local gl = require('galaxyline')
-- local gls = gl.section
-- gl.short_line_list = {'NvimTree','vista','dbui'}

-- local colors = {
--   bg = '#202328',
--   fg = '#bbc2cf',
--   yellow = '#fabd2f',
--   cyan = '#008080',
--   darkblue = '#081633',
--   green = '#98be65',
--   orange = '#FF8800',
--   violet = '#a9a1e1',
--   magenta = '#c678dd',
--   blue = '#51afef';
--   red = '#ec5f67';
-- }

-- local buffer_not_empty = function()
--   if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
--     return true
--   end
--   return false
-- end

-- gls.left[1] = {
--   RainbowRed = {
--     provider = function() return '▊ NVIM  ' end,
--     highlight = {colors.blue,colors.bg}
--   },
-- }
-- gls.left[2] = {
--   ViMode = {
--     provider = function()
--       -- auto change color according the vim mode
--       local mode_color = {n = colors.magenta, i = colors.green,v=colors.blue,
--                           [''] = colors.blue,V=colors.blue,
--                           c = colors.red,no = colors.magenta,s = colors.orange,
--                           S=colors.orange,[''] = colors.orange,
--                           ic = colors.yellow,R = colors.violet,Rv = colors.violet,
--                           cv = colors.red,ce=colors.red, r = colors.cyan,
--                           rm = colors.cyan, ['r?'] = colors.cyan,
--                           ['!']  = colors.red,t = colors.red}
--       vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
--       return '  '
--     end,
--     highlight = {colors.red,colors.bg,'bold'},
--   },
-- }
-- gls.left[3] = {
--   FileSize = {
--     provider = 'FileSize',
--     condition = buffer_not_empty,
--     highlight = {colors.fg,colors.bg}
--   }
-- }
-- gls.left[4] ={
--   FileIcon = {
--     provider = 'FileIcon',
--     condition = buffer_not_empty,
--     highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
--   },
-- }

-- gls.left[5] = {
--   FileName = {
--     provider = {'FileName'},
--     condition = buffer_not_empty,
--     highlight = {'#F3EA98',colors.bg,'bold'}
--   }
-- }

-- gls.left[6] = {
--   LineInfo = {
--     provider = 'LineColumn',
--     separator = '  ❱  ',
--     separator_highlight = {colors.fg,colors.bg},
--     highlight = {colors.fg,colors.bg},
--   },
-- }

-- gls.left[7] = {
--   PerCent = {
--     provider = 'LinePercent',
--     separator = '  ❱  ',
--     separator_highlight = {colors.fg,colors.bg},
--     highlight = {colors.fg,colors.bg,'bold'},
--   }
-- }

-- gls.left[8] = {
--   DiagnosticError = {
--     provider = 'DiagnosticError',
--     icon = '  ',
--     highlight = {colors.red,colors.bg}
--   }
-- }
-- gls.left[9] = {
--   DiagnosticWarn = {
--     provider = 'DiagnosticWarn',
--     icon = '  ',
--     highlight = {colors.yellow,colors.bg},
--   }
-- }

-- gls.left[10] = {
--   DiagnosticHint = {
--     provider = 'DiagnosticHint',
--     icon = '  ',
--     highlight = {colors.cyan,colors.bg},
--   }
-- }

-- gls.left[11] = {
--   DiagnosticInfo = {
--     provider = 'DiagnosticInfo',
--     icon = '  ',
--     highlight = {colors.blue,colors.bg},
--   }
-- }

-- gls.right[1] = {
--   FileEncode = {
--     provider = 'FileEncode',
--     separator = '  ❰  ',
--     separator_highlight = {colors.fg,colors.bg},
--     highlight = {colors.cyan,colors.bg,'bold'}
--   }
-- }

-- gls.right[2] = {
--   FileFormat = {
--     provider = 'FileFormat',
--     separator = '  ❰  ',
--     separator_highlight = {colors.fg,colors.bg},
--     highlight = {colors.cyan,colors.bg,'bold'}
--   }
-- }

-- gls.right[3] = {
--   GitIcon = {
--     provider = function() return '  ' end,
--     condition = require('galaxyline.provider_vcs').check_git_workspace,
--     separator = '  ❰  ',
--     separator_highlight = {colors.fg,colors.bg},
--     highlight = {colors.violet,colors.bg,'bold'},
--   }
-- }

-- gls.right[4] = {
--   GitBranch = {
--     provider = 'GitBranch',
--     condition = require('galaxyline.provider_vcs').check_git_workspace,
--     highlight = {colors.violet,colors.bg,'bold'},
--   }
-- }

-- local checkwidth = function()
--   local squeeze_width  = vim.fn.winwidth(0) / 2
--   if squeeze_width > 40 then
--     return true
--   end
--   return false
-- end

-- gls.right[5] = {
--   DiffAdd = {
--     provider = 'DiffAdd',
--     condition = checkwidth,
--     icon = '  ',
--     highlight = {colors.green,colors.bg},
--   }
-- }
-- gls.right[6] = {
--   DiffModified = {
--     provider = 'DiffModified',
--     condition = checkwidth,
--     icon = ' 柳',
--     highlight = {colors.orange,colors.bg},
--   }
-- }
-- gls.right[7] = {
--   DiffRemove = {
--     provider = 'DiffRemove',
--     condition = checkwidth,
--     icon = '  ',
--     highlight = {colors.red,colors.bg},
--   }
-- }

-- gls.right[8] = {
--   RainbowBlue = {
--     provider = function() return '  ▊' end,
--     highlight = {colors.blue,colors.bg}
--   },
-- }

-- gls.short_line_left[1] = {
--   BufferType = {
--     provider = 'FileTypeName',
--     separator = '  ❱  ',
--     separator_highlight = {colors.fg,colors.bg},
--     highlight = {colors.blue,colors.bg,'bold'}
--   }
-- }

-- gls.short_line_left[2] = {
--   SFileName = {
--     provider = function ()
--       local fileinfo = require('galaxyline.provider_fileinfo')
--       local fname = fileinfo.get_current_file_name()
--       for _,v in ipairs(gl.short_line_list) do
--         if v == vim.bo.filetype then
--           return ''
--         end
--       end
--       return fname
--     end,
--     condition = buffer_not_empty,
--     highlight = {colors.fg,colors.bg,'bold'}
--   }
-- }

-- gls.short_line_right[1] = {
--   BufferIcon = {
--     provider= 'BufferIcon',
--     highlight = {colors.fg,colors.bg}
--   }
-- }

---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- from kraftwerk28 dotfiles
local gl = require 'galaxyline'
local gls = gl.section

local fileinfo = require 'galaxyline.provider_fileinfo'
local u = require 'utils'.u
local devicons = require 'nvim-web-devicons'
local cl = require 'colors'

gl.short_line_list = {'NvimTree', 'vista', 'dbui'}

local mode_map = {
  ['n'] = {'NORMAL', cl.normal},
  ['i'] = {'INSERT', cl.insert},
  ['R'] = {'REPLACE', cl.replace},
  ['v'] = {'VISUAL', cl.visual},
  ['V'] = {'V-LINE', cl.visual},
  ['c'] = {'COMMAND', cl.command},
  ['s'] = {'SELECT', cl.visual},
  ['S'] = {'S-LINE', cl.visual},
  ['t'] = {'TERMINAL', cl.terminal},
  [''] = {'V-BLOCK', cl.visual},
  [''] = {'S-BLOCK', cl.visual},
  ['Rv'] = {'VIRTUAL'},
  ['rm'] = {'--MORE'},
}

local sep = {
  right_filled = u 'e0b2',
  left_filled = u 'e0b0',
  right = u 'e0b3',
  left = u 'e0b1',
}

local icons = {
  locker = u 'f023',
  unsaved = u 'f693',
  dos = u 'e70f',
  unix = u 'f17c',
  mac = u 'f179',
}

local function mode_label() return mode_map[vim.fn.mode()][1] or 'N/A' end
local function mode_hl() return mode_map[vim.fn.mode()][2] or cl.none end

local function highlight(group, fg, bg, gui)
  local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)
  if gui ~= nil then cmd = cmd .. ' gui=' .. gui end
  vim.cmd(cmd)
end

local function buffer_not_empty()
  if vim.fn.empty(vim.fn.expand '%:t') ~= 1 then return true end
  return false
end

local function diagnostic_exists()
  return vim.tbl_isempty(vim.lsp.buf_get_clients(0))
end

local function wide_enough()
  local squeeze_width = vim.fn.winwidth(0)
  if squeeze_width > 80 then return true end
  return false
end

gls.left = {
  {
    ViMode = {
      provider = function()
        local modehl = mode_hl()
        highlight('GalaxyViMode', cl.bg, modehl)
        highlight('GalaxyViModeInv', modehl, cl.bg)
        return string.format('  %s ', mode_label())
      end,
      separator = sep.left_filled,
      separator_highlight = 'GalaxyViModeInv',
    },
  }, {
    FileIcon = {
      provider = function()
        local fname, ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
        local icon, iconhl = devicons.get_icon(fname, ext)
        if icon == nil then return '' end
        local fg = vim.fn.synIDattr(vim.fn.hlID(iconhl), 'fg')
        highlight('GalaxyFileIcon', fg, cl.bg)
        return ' ' .. icon .. ' '
      end,
      condition = buffer_not_empty,
    },
    FileName = {
      provider = function()
        if not buffer_not_empty() then return '' end
        local fname
        if wide_enough() then
          fname = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.')
        else
          fname = vim.fn.expand '%:t'
        end
        if #fname == 0 then return '' end
        if vim.bo.readonly then fname = fname .. ' ' .. icons.locker end
        if vim.bo.modified then fname = fname .. ' ' .. icons.unsaved end
        return ' ' .. fname .. ' '
      end,
      highlight = {cl.fg, cl.bg},
      separator = sep.left,
      separator_highlight = 'GalaxyViModeInv',
    },
  },
}

gls.right = {
  {
    LspStatus = {
      provider = function()
        local connected = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
        if connected then
          return ' ' .. u 'f817' .. ' '
        else
          return ''
        end
      end,
      highlight = {cl.lsp_active, cl.bg},
      separator = sep.right,
      separator_highlight = 'GalaxyViModeInv',
    },
  }, {
    DiagnosticWarn = {
      provider = function()
        local n = vim.lsp.diagnostic.get_count(0, 'Warning')
        if n == 0 then return '' end
        return string.format(' %s %d ', u 'f071', n)
      end,
      highlight = {'yellow', cl.bg},
    },
    DiagnosticError = {
      provider = function()
        local n = vim.lsp.diagnostic.get_count(0, 'Error')
        if n == 0 then return '' end
        return string.format(' %s %d ', u 'e009', n)
      end,
      highlight = {'red', cl.bg},
    },
  }, {
    FileType = {
      provider = function()
        if not buffer_not_empty() then return '' end
        local icon = icons[vim.bo.fileformat] or ''
        return string.format(' %s %s ', icon, vim.bo.filetype)
      end,
      highlight = {cl.fg, cl.bg},
      separator = sep.right,
      separator_highlight = 'GalaxyViModeInv',
    },
  }, {
    PositionInfo = {
      provider = {
        function()
          return string.format(' %s:%s ', vim.fn.line('.'), vim.fn.col('.'))
        end,
      },
      highlight = 'GalaxyViMode',
      condition = buffer_not_empty,
      separator = sep.right_filled,
      separator_highlight = 'GalaxyViModeInv',
    },
  }, {
    PercentInfo = {
      provider = fileinfo.current_line_percent,
      highlight = 'GalaxyViMode',
      condition = buffer_not_empty,
      separator = sep.right,
      separator_highlight = 'GalaxyViMode',
    },
  },
}

for k, v in pairs(gls.left) do gls.short_line_left[k] = v end
table.remove(gls.short_line_left, 1)

for k, v in pairs(gls.right) do gls.short_line_right[k] = v end
table.remove(gls.short_line_right)
table.remove(gls.short_line_right)
