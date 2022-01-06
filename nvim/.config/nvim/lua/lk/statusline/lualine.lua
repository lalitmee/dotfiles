local lualine = require('lualine')

lualine.setup {
  options = {
    theme = 'auto',
    -- theme = 'gruvbox',
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
      { 'b:coc_current_function', 'g:coc_status' },
      { 'diff' },
    },
    lualine_x = { { 'filesize' } },
    lualine_y = { { 'progress' } },
    lualine_z = { { 'location' }, { 'tabs' } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 0 } },
    lualine_x = { 'filetype' },
    lualine_z = { 'location' },
  },
  -- tabline = {
  --   lualine_a = { 'buffers' },
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = { 'tabs' },
  -- },
  extensions = { 'fzf', 'fugitive', 'nvim-tree', 'quickfix', 'toggleterm' },
}
