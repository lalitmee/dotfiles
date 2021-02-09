local ayu_dark, ayu_mirage = (function()
  local ayu_colors = {
    bg = {dark = '#0F1419', light = '#FAFAFA', mirage = '#212733'},
    comment = {dark = '#5C6773', light = '#ABB0B6', mirage = '#5C6773'},
    markup = {dark = '#F07178', light = '#F07178', mirage = '#F07178'},
    constant = {dark = '#FFEE99', light = '#A37ACC', mirage = '#D4BFFF'},
    operator = {dark = '#E7C547', light = '#E7C547', mirage = '#80D4FF'},
    tag = {dark = '#36A3D9', light = '#36A3D9', mirage = '#5CCFE6'},
    regexp = {dark = '#95E6CB', light = '#4CBF99', mirage = '#95E6CB'},
    string = {dark = '#B8CC52', light = '#86B300', mirage = '#BBE67E'},
    _function = {dark = '#FFB454', light = '#F29718', mirage = '#FFD57F'},
    special = {dark = '#E6B673', light = '#E6B673', mirage = '#FFC44C'},
    keyword = {dark = '#FF7733', light = '#FF7733', mirage = '#FFAE57'},
    error = {dark = '#FF3333', light = '#FF3333', mirage = '#FF3333'},
    accent = {dark = '#F29718', light = '#FF6A00', mirage = '#FFCC66'},
    panel = {dark = '#14191F', light = '#FFFFFF', mirage = '#272D38'},
    guide = {dark = '#2D3640', light = '#D9D8D7', mirage = '#3D4751'},
    line = {dark = '#151A1E', light = '#F3F3F3', mirage = '#242B38'},
    selection = {dark = '#253340', light = '#F0EEE4', mirage = '#343F4C'},
    fg = {dark = '#E6E1CF', light = '#5C6773', mirage = '#D9D7CE'},
    fg_idle = {dark = '#3E4B59', light = '#828C99', mirage = '#607080'},
  }

  local ayu_mappings = {
    bg = ayu_colors.selection,
    fg = ayu_colors.fg,
    normal = ayu_colors.string,
    insert = ayu_colors.tag,
    replace = ayu_colors.markup,
    visual = ayu_colors.special,
    command = ayu_colors.keyword,
    terminal = ayu_colors.regexp,
    lsp_active = ayu_colors.string,
    lsp_inactive = ayu_colors.fg_idle,
  }

  local ayu_dark, ayu_mirage = {}, {}
  for k, v in pairs(ayu_mappings) do
    ayu_dark[k] = v.dark
    ayu_mirage[k] = v.mirage
  end
  return ayu_dark, ayu_mirage
end)()

-- local ayu_dark = {
--   bg = '#0F1419',
--   fg = '#E6E1CF',
--   normal = '#B8CC52',
--   insert = '#36A3D9',
--   replace = '#F07178',
--   visual = '#E6B673',
--   command = '#FF7733',
--   terminal = '#95E6CB',
-- }

-- local ayu_mirage = {
--   bg = '#0F1419',
--   fg = '#E6E1CF',
--   normal = '#B8CC52',
--   insert = '#36A3D9',
--   replace = '#F07178',
--   visual = '#E6B673',
--   command = '#FF7733',
--   terminal = '#95E6CB',
-- }

-- -- Gruvbox
-- local colors = {
--   dark0_hard = '#1d2021',
--   dark0 = '#282828',
--   dark0_soft = '#32302f',
--   dark1 = '#3c3836',
--   dark2 = '#504945',
--   dark3 = '#665c54',
--   dark4 = '#7c6f64',
--   dark4_256 = '#7c6f64',
--   gray_245 = '#928374',
--   gray_244 = '#928374',
--   light0_hard = '#f9f5d7',
--   light0 = '#fbf1c7',
--   light0_soft = '#f2e5bc',
--   light1 = '#ebdbb2',
--   light2 = '#d5c4a1',
--   light3 = '#bdae93',
--   light4 = '#a89984',
--   light4_256 = '#a89984',
--   bright_red = '#fb4934',
--   bright_green = '#b8bb26',
--   bright_yellow = '#fabd2f',
--   bright_blue = '#83a598',
--   bright_purple = '#d3869b',
--   bright_aqua = '#8ec07c',
--   bright_orange = '#fe8019',
--   neutral_red = '#cc241d',
--   neutral_green = '#98971a',
--   neutral_yellow = '#d79921',
--   neutral_blue = '#458588',
--   neutral_purple = '#b16286',
--   neutral_aqua = '#689d6a',
--   neutral_orange = '#d65d0e',
--   faded_red = '#9d0006',
--   faded_green = '#79740e',
--   faded_yellow = '#b57614',
--   faded_blue = '#076678',
--   faded_purple = '#8f3f71',
--   faded_aqua = '#427b58',
--   faded_orange = '#af3a03',
--   none = 'NONE',
-- }
-- colors.bg = vim.fn.synIDattr(vim.fn.hlID('StatusLine'), 'bg') -- Default background
-- colors.fg = colors.light0 -- Default foreground

if vim.g.colors_name == 'ayu' then
  if vim.g.ayucolor == 'mirage' then
    return ayu_mirage
  else
    return ayu_dark
  end
else
  return ayu_dark
end
