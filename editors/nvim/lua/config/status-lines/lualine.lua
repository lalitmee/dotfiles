require('lualine').setup {
  options = {
    theme = 'solarized_dark',
    section_separators = { '', '' },
    component_separators = { '', '' },
    icons_enabled = true,
    padding = 1
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = {
      {
        'branch',
        icon = ''
      }
    },
    lualine_c = {
      { 'filename', full_path = true, file_status = true },
      { 'diff' },
      {
        'diagnostics',
        sources = { 'coc' },
        symbols = { error = 'E:', warn = 'W:', info = 'I:' }
      },
      -- { 'LspStatus' }
      { 'b:coc_current_function' },
      {
        'g:coc_status',
        'b:coc_git_blame',
        'g:coc_git-status',
        'b:coc_git_status'
      }
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'fzf' }
}
