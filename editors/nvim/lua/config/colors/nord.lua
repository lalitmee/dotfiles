-- nord theme using colorbuddy
local Color, colors, Group, groups, styles = require('colorbuddy').setup()

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

Group.new('Comment', colors.nord_3_light, colors.none, styles.italic)
Group.new('SpecialComment', colors.nord_8, colors.none, styles.NONE)
Group.new('LineNr', colors.nord_4:dark():dark(), colors.none, styles.NONE)
Group.new('CursorLineNr', colors.nord_13, colors.none, styles.NONE)
Group.new('Line', colors.nord_12, colors.none, styles.bold)
Group.new('SignColumn', colors.none, colors.none, styles.NONE)

-- Neovim support
Group.new('IncSearch', colors.nord_6, colors.nord_10, styles.underline)
Group.new('Search', colors.nord_1, colors.nord_12)

Group.new('NvimTreeFolderIcon', colors.nord_11, colors.NONE)

-- Neogit
Group.new('NeogitDiffAddHighlight', colors.green:dark():dark():dark(), colors.black:light())
Group.new('NeogitDiffDeleteHighlight', colors.red:dark(), colors.black:light())

Group.new('NeogitDiffContextHighlight', nil, colors.black:light())
Group.new('NeogitHunkHeader', colors.black, colors.blue:dark())
Group.new('NeogitHunkHeaderHighlight', colors.black, colors.blue:dark())

-- git blame
Group.new('gitblame', colors.grey:dark(), nil)

-- barbar highlight groups
Group.new('BufferCurrent', colors.orange, nil, styles.bold)
Group.new('BufferCurrentIndex', colors.orange, nil, styles.bold)
Group.new('BufferCurrentMod', colors.red:dark(), nil, styles.bold)
Group.new('BufferCurrentSign', nil, nil, styles.bold)
