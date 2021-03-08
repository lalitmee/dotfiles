vim.opt.termguicolors = true

require('colorbuddy').colorscheme('gruvbuddy')
require('colorizer').setup()

local c = require('colorbuddy.color').colors
local s = require('colorbuddy.style').styles
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

-- git blame
Group.new('gitblame', c.grey:dark(), nil)

-- barbar highlight groups
Group.new('BufferCurrent', c.orange, nil, s.bold)
Group.new('BufferCurrentIndex', c.orange, nil, s.bold)
Group.new('BufferCurrentMod', c.red:dark(), nil, s.bold)
Group.new('BufferCurrentSign', nil, nil, s.bold)

-- Group.new('PMenuSel', c.black, c.pink, s.NONE)
-- Group.new('PMenu', c.black, c.yellow, s.NONE)
