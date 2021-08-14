-- nord theme using colorbuddy
local Color, c, Group, g, s = require('colorbuddy').setup()

Color.new('background', '#3B4252')
Color.new('fg', '#292929')
Color.new('nord_0', '#2E3440')
Color.new('nord_1', '#3B4252')
Color.new('nord_2', '#434C5E')
Color.new('nord_3', '#4C566A')
Color.new('nord_3_light', '#616E88')
Color.new('nord_4', '#D8DEE9')
Color.new('nord_5', '#E5E9F0')
Color.new('nord_6', '#ECEFF4')
Color.new('nord_7', '#8FBCBB')
Color.new('nord_8', '#88C0D0')
Color.new('nord_9', '#81A1C1')
Color.new('nord_10', '#5E81AC')
Color.new('nord_11', '#BF616A')
Color.new('nord_12', '#D08770')
Color.new('nord_13', '#EBCB8B')
Color.new('nord_14', '#A3BE8C')
Color.new('nord_15', '#B48EAD')

Color.new('white', '#D8DEE9')
Color.new('red', '#BF616A')
Color.new('green', '#A3BE8C')
Color.new('yellow', '#EBCB8B')
Color.new('blue', '#81A1C1')
Color.new('aqua', '#A3BE8C')
Color.new('cyan', '#8FBCBB')
Color.new('purple', '#B48EAD')
Color.new('violet', '#B48EAD')
Color.new('orange', '#D08770')

Group.new('Comment', c.nord_3_light, c.none, s.italic)
Group.new('SpecialComment', c.nord_8, c.none, s.NONE)
Group.new('LineNr', c.nord_4:dark():dark(), c.none, s.NONE)
Group.new('CursorLineNr', c.nord_13, c.none, s.NONE)
Group.new('Line', c.nord_12, c.none, s.bold)
Group.new('SignColumn', c.none, c.none, s.NONE)

-- Neovim support
Group.new('IncSearch', c.nord_6, c.nord_10, s.underline)
Group.new('Search', c.nord_1, c.nord_12)

Group.new('NvimTreeFolderIcon', c.nord_11, c.NONE)

-- Group.new('NeogitDiffAdd', c.green:dark(), c.black:light())
-- Group.new('NeogitDiffAddHighlight', c.green:dark(), c.black:light())
-- Group.new('NeogitDiffContextHighlight', nil, c.black:light())
-- Group.new('NeogitDiffDelete', c.red:dark(), c.black:light())
-- Group.new('NeogitDiffDeleteHighlight', c.red:dark(), c.black:light())
-- Group.new('NeogitHunkHeader', c.black, c.blue:dark())
-- Group.new('NeogitHunkHeaderHighlight', c.black, c.blue:dark())

-- git blame
Group.new('gitblame', c.grey:dark(), nil)

-- -- telescope
-- Group.new('TelescopeMatching', c.orange:saturate(.20), c.None, s.bold)
