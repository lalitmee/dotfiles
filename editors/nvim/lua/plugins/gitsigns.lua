RELOAD('gitsigns')

require('colorbuddy')

local c = require('colorbuddy.color').colors
local Group = require('colorbuddy.group').Group

Group.new('GitSignsAdd', c.green)
Group.new('GitSignsChange', c.yellow)
Group.new('GitSignsDelete', c.red)

require('gitsigns').setup {
  signs = {
    add = {
      hl = 'GitSignsAdd',
      text = '+',
      numhl = 'GitSignsAddNr'
    },
    change = {
      hl = 'GitSignsChange',
      text = '~',
      numhl = 'GitSignsChangeNr'
    },
    delete = {
      hl = 'GitSignsDelete',
      text = '_',
      numhl = 'GitSignsDeleteNr'
    },
    topdelete = {
      hl = 'GitSignsDelete',
      text = '‾',
      numhl = 'GitSignsDeleteNr'
    },
    changedelete = {
      hl = 'GitSignsDelete',
      text = '~',
      numhl = 'GitSignsChangeNr'
    }
  },

  -- Can't decide if I like this or not :)
  numhl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,
    ['n <leader>ghn'] = {
      expr = true,
      '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''
    },
    ['n <leader>ghp'] = {
      expr = true,
      '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''
    },
    ['n <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['n <leader>ghu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>ghr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['n <leader>ghv'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>ghb'] = '<cmd>lua require"gitsigns".blame_line()<CR>'
  }
}
