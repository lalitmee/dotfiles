-- local devicons = require('nvim-web-devicons')
local function buf_spaces()
  return 'Spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth') .. ' '
end

-- local function file_icon()
--   local filename = vim.fn.fnamemodify(vim.fn.expand('%t'), ':t')
--   local extension = vim.fn.fnamemodify(vim.fn.expand('%t'), ':e')
--   local icon = devicons.get_icon(filename, extension)
--   return icon
-- end

-- local function lsp_status()
--   if #vim.lsp.buf_get_clients() > 0 then
--     return require('lsp-status').status()
--   end
-- end

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    section_separators = { '', '' },
    component_separators = { '', '' },
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      -- { file_icon },
      { 'filename', path = 1 },
      -- {
      --   'diff',
      --   symbols = { added = ' ', modified = ' ', removed = ' ' },
      --   color_added = '#F5ED0F',
      --   color_modified = '#7DE89A',
      --   color_removed = '#E06C75',
      -- },
      {
        'diagnostics',
        sources = { 'coc' },
        symbols = {
          error = ' :',
          warn = ' :',
          info = ' :',
          hint = '💡',
        },
        color_error = '#E06C75',
        color_warn = '#FF922B',
        color_info = '#15AABF',
        color_hint = '#fab005',
      },
      -- { 'os.data(\'%a\')', 'data', require'lsp-status'.status },
      { 'g:coc_status' },
      { 'lsp_progress' },
    },
    lualine_x = { 'filetype', buf_spaces },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
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
