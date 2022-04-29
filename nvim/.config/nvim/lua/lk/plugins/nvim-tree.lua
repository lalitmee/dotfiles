vim.g.nvim_tree_icons = {
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
}

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_root_folder_modifier = ":t"

-- for `ahmedkhalf/project.nvim`
vim.g.nvim_tree_respect_buf_cwd = 1

require("nvim-tree").setup({
  update_cwd = true,
  hijack_cursor = true,
  view = { width = 40, side = "right" },
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
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
})
