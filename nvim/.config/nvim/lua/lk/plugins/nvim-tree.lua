vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = '',
    staged = '',
    unmerged = '',
    renamed = '➜',
    untracked = '',
    deleted = '',
  },
  folder = {
    default = '',
    open = '',
    empty = '',
    empty_open = '',
    symlink = '',
  },
}

vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ':t'
vim.g.nvim_tree_ignore = {
  '.DS_Store',
  '.cache',
  '.git',
  'fugitive:',
  'node_modules',
}

lk_utils.nnoremap('<c-n>', [[<cmd>NvimTreeFindFile<CR>]])

vim.cmd [[highlight link NvimTreeIndentMarker Comment]]
vim.cmd [[highlight NvimTreeRootFolder gui=bold,italic guifg=Cyan]]

require('lk.autocommands').augroup('NvimTreeOverrides', {
  {
    events = { 'ColorScheme' },
    targets = { '*' },
    command = 'highlight NvimTreeRootFolder gui=bold,italic guifg=Cyan',
  },
})

require('nvim-tree').setup({
  nvim_tree_follow = true,
  hijack_cursor = true,
  auto_close = false,
  view = { width = 40, side = 'right' },
  mappings = {
    list = {
      { key = 'h', cb = ':lua require"nvim-tree".on_keypress("close_node")<CR>' },
      { key = 'l', cb = ':lua require"nvim-tree".on_keypress("edit")<CR>' },
      { key = 'v', cb = ':lua require"nvim-tree".on_keypress("vsplit")<CR>' },
      { key = 's', cb = ':lua require"nvim-tree".on_keypress("split")<CR>' },
    },
  },
})
