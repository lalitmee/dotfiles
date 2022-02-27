local lualine = require('lualine')

-- NOTE: default
lualine.setup {
  options = {
    theme = 'auto',
    -- theme = 'cobalt2',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', fmt = string.upper } },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = {
      { 'filetype', icon_only = true },
      { 'filename', path = 1 },
      {
        'diagnostics',
        -- sources = { 'coc' },
        sources = { 'nvim_diagnostic' },
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
      { 'lsp_progress' },
      { 'diff' },
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

-- -- NOTE: slanted gaps
-- local colors = { white = '#1f2335', red = '#db4b4b' }
--
-- local empty = require('lualine.component'):extend()
-- function empty:draw(default_highlight)
--   self.status = ''
--   self.applied_separator = ''
--   self:apply_highlights(default_highlight)
--   self:apply_section_separators()
--   return self.status
-- end
--
-- -- Put proper separators and gaps between components in sections
-- local function process_sections(sections)
--   for name, section in pairs(sections) do
--     local left = name:sub(9, 10) < 'x'
--     for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
--       table.insert(section, pos * 2,
--                    { empty, color = { fg = colors.white, bg = colors.white } })
--     end
--     for id, comp in ipairs(section) do
--       if type(comp) ~= 'table' then
--         comp = { comp }
--         section[id] = comp
--       end
--       comp.separator = left and { right = '' } or { left = '' }
--     end
--   end
--   return sections
-- end
--
-- local function search_result()
--   if vim.v.hlsearch == 0 then
--     return ''
--   end
--   local last_search = vim.fn.getreg('/')
--   if not last_search or last_search == '' then
--     return ''
--   end
--   local searchcount = vim.fn.searchcount { maxcount = 9999 }
--   return
--       last_search .. '(' .. searchcount.current .. '/' .. searchcount.total ..
--           ')'
-- end
--
-- local function modified()
--   if vim.bo.modified then
--     return '+'
--   elseif vim.bo.modifiable == false or vim.bo.readonly == true then
--     return '-'
--   end
--   return ''
-- end
--
-- require('lualine').setup {
--   options = {
--     -- theme = 'auto',
--     theme = 'solarized_dark',
--     component_separators = '',
--     section_separators = { left = '', right = '' },
--   },
--   sections = process_sections {
--     lualine_a = { 'mode' },
--     lualine_b = {
--       { 'branch', icon = '' },
--       { 'filename', file_status = false, path = 1 },
--       { modified, color = { bg = colors.red } },
--       {
--         '%w',
--         cond = function()
--           return vim.wo.previewwindow
--         end,
--       },
--       {
--         '%r',
--         cond = function()
--           return vim.bo.readonly
--         end,
--       },
--       {
--         '%q',
--         cond = function()
--           return vim.bo.buftype == 'quickfix'
--         end,
--       },
--     },
--     lualine_c = {
--       {
--         'diagnostics',
--         sources = { 'coc' },
--         -- sources = { 'nvim_lsp' },
--         symbols = {
--           error = ' :',
--           warn = ' :',
--           info = ' :',
--           hint = '💡',
--         },
--         diagnostics_color = {
--           error = { fg = '#E06C75' },
--           warn = { fg = '#FF922B' },
--           info = { fg = '#15AABF' },
--           hint = { fg = '#fab005' },
--         },
--         update_in_insert = true,
--       },
--     },
--     lualine_x = {},
--     lualine_y = { search_result, 'filetype' },
--     lualine_z = { '%l:%c', '%p%%/%L' },
--   },
--   inactive_sections = { lualine_c = { '%f %y %m' }, lualine_x = {} },
-- }
