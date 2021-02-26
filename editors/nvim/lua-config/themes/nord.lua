-- nord theme using colorbuddy
local Color, colors, Group, groups, styles = require("colorbuddy").setup()

Group.new("IncSearch",colors.nord_6, colors.nord_10, styles.underline)
Group.new("CursorLineNr",   colors.nord_5,       colors.nord_1,    styles.NONE)
-- Group.new("LineNr",         colors.nord_9,       colors.none,    styles.NONE)
