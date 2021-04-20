local function buf_spaces()
  return 'Spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth') .. ' '
end

-- local function file_icon()
--   local filename = vim.fn.fnamemodify(vim.fn.expand('%t'), ':t')
--   local extension = vim.fn.fnamemodify(vim.fn.expand('%t'), ':e')
--   return require'nvim-web-devicons'.get_icon(filename, extension,
--                                              { default = true })
-- end

-- local function lsp_status()
--   if #vim.lsp.buf_get_clients() > 0 then
--     return require('lsp-status').status()
--   end
-- end

require('lualine').setup {
  options = {
    -- theme = 'solarized_dark',
    -- theme = 'onedark',
    theme = 'tokyonight',
    section_separators = { '', '' },
    component_separators = { '', '' }
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      -- file_icon,
      { 'filename', shorten = true },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        color_added = '#F5ED0F',
        color_modified = '#7DE89A',
        color_removed = '#E06C75'
      },
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        symbols = { error = ' :', warn = ' :', info = ' :' },
        color_error = '#E06C75',
        color_warn = '#FF922B',
        color_info = '#15AABF'
      }
      -- { lsp_status }
    },
    lualine_x = { { 'filetype', upper = true }, buf_spaces },
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
  extensions = { 'fzf', 'fugitive', 'nvim-tree' }
}
