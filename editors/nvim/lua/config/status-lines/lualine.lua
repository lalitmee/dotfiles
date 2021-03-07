require('lualine').status {
  options = {
    theme = 'nord',
    section_separators = { '', '' },
    component_separators = { '', '' },
    icons_enabled = true
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      {
        'filename',
        full_path = true,
        -- shorten = true,
        file_status = true
      },
      { 'diagnostics', sources = { 'coc' } },
      { 'g:coc_status' },
      { 'b:gitsigns_status' },
      { 'b:coc_current_function' }
      -- { 'diagnostics', sources = { 'nvim_lsp' } },
      -- { 'LspStatus' },
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
