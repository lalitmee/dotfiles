vim.opt.termguicolors = true

require('colorbuddy').colorscheme('gruvbuddy')
require('colorizer').setup()

local c = require('colorbuddy.color').colors
local s = require('colorbuddy.style').styles
local g = require('colorbuddy.style').groups
local Group = require('colorbuddy.group').Group

Group.new('NeogitDiffAdd', c.green:dark(), c.black:light())
Group.new('NeogitDiffAddHighlight', c.green:dark(), c.black:light())
Group.new('NeogitDiffContextHighlight', nil, c.black:light())
Group.new('NeogitDiffDelete', c.red:dark(), c.black:light())
Group.new('NeogitDiffDeleteHighlight', c.red:dark(), c.black:light())
Group.new('NeogitHunkHeader', c.black, c.blue:dark())
Group.new('NeogitHunkHeaderHighlight', c.black, c.blue:dark())

-- git blame
Group.new('gitblame', c.grey:dark(), nil)

-- Group.new('QuickScopePrimary', c.green:dark(), nil, s.bold)
-- Group.new('QuickScopeSecondary', c.blue:dark(), nil, s.bold)

Group.new('LspLinesDiagBorder', c.white, nil, s.NONE)
Group.new('LineDiagTuncateLine', c.white, nil, s.NONE)

Group.new('IndentBlanklineChar', c.grey, nil, s.NONE)
