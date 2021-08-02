-- vim.g.material_style = 'default'
-- vim.g.material_style = 'darker'
vim.g.material_style = 'palenight'
-- vim.g.material_style = 'deep ocean'
-- vim.g.material_style = 'oceanic'
-- vim.g.material_style = 'lighter'

vim.g.material_italics = 1
vim.g.material_borders = true
vim.g.material_italic_keywords = true
vim.g.material_italic_comments = true
-- vim.g.material_italic_functions = true
-- vim.g.material_italic_variables = true

require('colorbuddy').colorscheme('material')

local c = require('colorbuddy.color').colors
local Group = require('colorbuddy.group').Group

Group.new('NeogitDiffAdd', c.green:dark(), c.black:light())
Group.new('NeogitDiffAddHighlight', c.green:dark(), c.black:light())
Group.new('NeogitDiffContextHighlight', nil, c.black:light())
Group.new('NeogitDiffDelete', c.red:dark(), c.black:light())
Group.new('NeogitDiffDeleteHighlight', c.red:dark(), c.black:light())
Group.new('NeogitHunkHeader', c.black, c.blue:dark())
Group.new('NeogitHunkHeaderHighlight', c.black, c.blue:dark())
