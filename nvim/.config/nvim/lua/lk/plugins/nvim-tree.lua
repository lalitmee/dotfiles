local width = 60
local height = 40

-- Get the current UI
local ui = vim.api.nvim_list_uis()[1]

require("nvim-tree").setup({
  respect_buf_cwd = true,
  update_cwd = true,
  hijack_cursor = true,
  view = {
    width = width,
    height = height,
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = width,
        height = height,
        col = (ui.width / 2) - (width / 2),
        row = (ui.height / 2) - (height / 2),
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  -- update_to_buf_dir = {
  --   enable = false,
  -- },
  filters = {
    custom = { ".DS_Store", ".cache", ".git", "fugitive:", "node_modules" },
  },
  actions = {
    open_file = {
      window_picker = { enable = false },
    },
  },
  git = {
    enable = false,
  },
  renderer = {
    root_folder_modifier = ":t",
    highlight_git = false,
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "➜",
          untracked = "",
          deleted = "",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
    indent_markers = {
      enable = true,
      icons = {
        corner = "╰",
        edge = "┊",
        item = "┊",
        none = "",
      },
    },
  },
})
