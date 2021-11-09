local lualine = require('lualine')

lualine.setup {
  options = {
    -- theme = 'auto',
    theme = 'solarized_dark',
    separator = { left = '', right = '' },
    -- section_separators = { '', '' },
    -- component_separators = { '', '' },
  },
  sections = {
    lualine_a = { { 'mode', fmt = string.upper } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      { 'filetype', icon_only = true },
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
        diagnostics_color = {
          error = { fg = '#E06C75' },
          warn = { fg = '#FF922B' },
          info = { fg = '#15AABF' },
          hint = { fg = '#fab005' },
        },
        update_in_insert = true,
      },
      {
        -- 'b:coc_current_function',
        'g:coc_status',
      },
      -- { 'LspStatus' },
    },
    lualine_x = { { 'filesize' } },
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
  extensions = { 'fzf', 'fugitive', 'nvim-tree', 'quickfix', 'toggleterm' },
}
