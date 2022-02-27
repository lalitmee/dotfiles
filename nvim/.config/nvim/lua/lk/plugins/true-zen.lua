local true_zen = require("true-zen")

-- setup for TrueZen.nvim
true_zen.setup({
  ui = {
    bottom = {
      laststatus = 0,
      ruler = true,
      showmode = true,
      showcmd = true,
      cmdheight = 2,
    },
    top = { showtabline = 1 },
    left = { number = true, relativenumber = true, signcolumn = "yes" },
  },
  modes = {
    ataraxis = {
      left_padding = 32,
      right_padding = 32,
      top_padding = 1,
      bottom_padding = 1,
      ideal_writing_area_width = 0,
      just_do_it_for_me = true,
      keep_default_fold_fillchars = true,
      custome_bg = "",
      bg_configuration = true,
      affected_higroups = {
        NonText = {},
        FoldColumn = {},
        ColorColumn = {},
        VertSplit = {},
        StatusLine = {},
        StatusLineNC = {},
        SignColumn = {},
      },
    },
    focus = { margin_of_error = 5, focus_method = "experimental" },
  },
  integrations = {
    vim_gitgutter = false,
    galaxyline = false,
    tmux = true,
    gitsigns = true,
    nvim_bufferline = true,
    limelight = false,
    vim_airline = false,
    vim_powerline = false,
    vim_signify = false,
    express_line = false,
    lualine = true,
  },
  misc = {
    on_off_commands = false,
    ui_elements_commands = false,
    cursor_by_mode = true,
  },
})
