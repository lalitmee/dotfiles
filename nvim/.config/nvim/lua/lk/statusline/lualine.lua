require('lualine').setup {
  options = {
    theme = 'auto',
    section_separators = { '', '' },
    component_separators = { '', '' },
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      { 'filetype', disable_text = true },
      { 'filename', path = 1 },
      {
        'diagnostics',
        sources = { 'coc' },
        -- sources = { 'nvim_lsp' },
        symbols = {
          error = ' :',
          warn = ' :',
          info = ' :',
          hint = '💡',
        },
        color_error = { fg = '#E06C75' },
        color_warn = { fg = '#FF922B' },
        color_info = { fg = '#15AABF' },
        color_hint = { fg = '#fab005' },
        update_in_insert = true,
      },
      { 'b:coc_current_function', 'g:coc_status' },
      -- { 'lsp_progress' },
    },
    lualine_x = {},
    lualine_y = { { 'progress' } },
    lualine_z = { { 'location' } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 0 } },
    lualine_x = { 'filetype' },
    lualine_z = { 'location' },
  },
  extensions = { 'fzf', 'fugitive', 'nvim-tree', 'quickfix' },
}
