-- check for isEmpty
local function isnotempty(s)
  return s ~= nil or s == ''
end

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

-- local function treesitter_status()
--   if isnotempty(lua.eval('nvim_treesitter#statusline(90)')) then
--     print('nvim_treesitter#statusline(90)')
--   end
-- end

-- treesitter_status()

require('lualine').setup {
  options = {
    theme = 'nord',
    section_separators = { '', '' },
    component_separators = { '', '' }
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      -- file_icon,
      { 'filename', path = 1 },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        color_added = '#F5ED0F',
        color_modified = '#7DE89A',
        color_removed = '#E06C75'
      },
      {
        'diagnostics',
        sources = { 'coc' },
        symbols = {
          error = ' :',
          warn = ' :',
          info = ' :',
          hint = '💡'
        },
        color_error = '#E06C75',
        color_warn = '#FF922B',
        color_info = '#15AABF',
        color_hint = '#fab005'
      },
      -- { 'os.data(\'%a\')', 'data', require'lsp-status'.status },
      { 'g:coc_status' },
      { 'TreesitterStatus' },
      { 'b:toggle_number' }
    },
    lualine_x = { 'filetype', buf_spaces },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'filetype', buf_spaces },
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'fzf', 'fugitive', 'nvim-tree', 'quickfix' }
}
