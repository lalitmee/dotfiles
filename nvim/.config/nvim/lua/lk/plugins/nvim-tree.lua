vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = '',
    staged = '',
    unmerged = '',
    renamed = '➜',
    untracked = '',
    deleted = ''
  },
  folder = {
    default = '',
    open = '',
    empty = '',
    empty_open = '',
    symlink = ''
  }
}

lk_utils.nnoremap('<c-n>', [[<cmd>NvimTreeToggle<CR>]])

vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_follow = 1 -- show selected file on open
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_width = 60
vim.g.nvim_tree_width_allow_resize = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ':t'
vim.g.nvim_tree_side = 'right'
vim.g.nvim_tree_ignore = {
  '.DS_Store',
  '.cache',
  '.git',
  'fugitive:',
  'node_modules'
}

-- vim.cmd [[highlight link NvimTreeIndentMarker Comment]]
vim.cmd [[highlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta]]

require('lk.autocommands').augroup('NvimTreeOverrides', {
  {
    events = { 'ColorScheme' },
    targets = { '*' },
    command = 'highlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta'
  }
})
