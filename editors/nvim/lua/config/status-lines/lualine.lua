-- local checkwidth = function()
--   local squeeze_width = vim.fn.winwidth(0) / 2
--   if squeeze_width > 40 then
--     return true
--   end
--   return false
-- end
-- local function check_active_lsp()
--   local clients = vim.lsp.buf_get_clients()
--   if next(clients) == nil then
--     return false
--   end
--   return true
-- end
--
-- get lsp client
-- local function get_lsp_client(msg)
--   msg = msg or 'No Active Lsp'
--   local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
--   local buf_clients = vim.lsp.buf_get_clients()
--   if next(buf_clients) == nil then
--     return msg
--   end
--   for _, client in ipairs(buf_clients) do
--     local filetypes = client.config.filetypes
--     if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--       return client.name
--     end
--   end
--   return msg
-- end
require('lualine').status {
  options = {
    theme = 'solarized_dark',
    section_separators = { '', '' },
    component_separators = { '', '' },
    icons_enabled = true,
    padding = 1
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      { 'filename', full_path = true, file_status = true },
      { 'diff' },
      {
        'diagnostics',
        -- sources = { 'nvim_lsp' },
        sources = { 'coc' },
        symbols = { error = 'E:', warn = 'W:', info = 'I:' }
      },
      -- { 'LspCurrentFunction' },
      { 'b:coc_current_function' },
      { 'g:coc_status' }
      -- { get_lsp_client }
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
