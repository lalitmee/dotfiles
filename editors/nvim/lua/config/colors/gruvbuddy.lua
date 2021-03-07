vim.opt.termguicolors = true

require('colorbuddy').colorscheme('gruvbuddy')
require('colorizer').setup()

local c = require('colorbuddy.color').colors
local Group = require('colorbuddy.group').Group

-- Group.new('NeogitDiffAddHighlight', nil, c.green:dark():dark():dark())
-- Group.new('NeogitDiffDeleteHighlight', nil, c.red:dark())

Group.new(
    'NeogitDiffAddHighlight', c.green:dark():dark():dark(), c.black:light()
)
Group.new('NeogitDiffDeleteHighlight', c.red:dark(), c.black:light())

Group.new('NeogitDiffContextHighlight', nil, c.black:light())
Group.new('NeogitHunkHeader', c.black, c.blue:dark())
Group.new('NeogitHunkHeaderHighlight', c.black, c.blue:dark())

Group.new('gitblame', c.grey:dark(), nil)
