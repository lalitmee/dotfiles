vim.opt.termguicolors = true

-- Color.new('white',     '#f2e5bc')
-- Color.new('red',       '#cc6666')
-- Color.new('pink',      '#fef601')
-- Color.new('green',     '#99cc99')
-- Color.new('yellow',    '#f8fe7a')
-- Color.new('blue',      '#81a2be')
-- Color.new('aqua',      '#8ec07c')
-- Color.new('cyan',      '#8abeb7')
-- Color.new('purple',    '#8e6fbd')
-- Color.new('violet',    '#b294bb')
-- Color.new('orange',    '#de935f')
-- Color.new('brown',     '#a3685a')

-- Color.new('seagreen',  '#698b69')
-- Color.new('turquoise', '#698b69')

-- gruvbuddy
require('colorbuddy').colorscheme('gruvbuddy')

require('colorizer').setup()

local c = require('colorbuddy.color').colors
local s = require('colorbuddy.style').styles
local Group = require('colorbuddy.group').Group

-- git blame
Group.new('gitblame', c.grey:dark(), nil)

-- Group.new('QuickScopePrimary', c.green:dark(), nil, s.bold)
-- Group.new('QuickScopeSecondary', c.blue:dark(), nil, s.bold)

Group.new('LspLinesDiagBorder', c.white, nil, s.NONE)
Group.new('LineDiagTuncateLine', c.white, nil, s.NONE)

Group.new('IndentBlanklineChar', c.grey, nil, s.NONE)

-- javascript
Group.new('Keyword', c.purple:light(), nil, s.italic)
Group.new('Identifier', c.red, nil, s.italic)
