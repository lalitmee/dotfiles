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
  nvim_tree_follow = true,
  hijack_cursor = true,
  auto_close = false,
  view = { width = 40, side = "right" },
  update_focused_file = {
    enable = true,
    -- for `ahmedkhalf/project.nvim`
    update_cwd = true,
  },
  update_to_buf_dir = {
    enable = false,
  },
  mappings = {
    list = {
      { key = "h", cb = ':lua require"nvim-tree".on_keypress("close_node")<CR>' },
      { key = "l", cb = ':lua require"nvim-tree".on_keypress("edit")<CR>' },
      { key = "v", cb = ':lua require"nvim-tree".on_keypress("vsplit")<CR>' },
      { key = "s", cb = ':lua require"nvim-tree".on_keypress("split")<CR>' },
    },
  },
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
