require'bufferline'.setup {
  options = {
    numbers = 'ordinal',
    number_style = '',
    separator_style = 'thick',
    -- separator_style = os.getenv 'KITTY_WINDOW_ID' and 'slant' or 'padded_slant',
    show_close_icon = false,
    show_buffer_close_icons = false,
    -- diagnostics = 'nvim_lsp',
    -- diagnostics_indicator = function(count, level)
    --   local icon = level:match('error') and ' ' or ''
    --   return ' ' .. icon .. ' ' .. count
    -- end,
    offsets = {
      {
        filetype = 'undotree',
        text = 'Undotree',
        highlight = 'PanelHeading',
        padding = 1,
      },
      {
        filetype = 'NvimTree',
        text = 'Explorer',
        highlight = 'PanelHeading',
        padding = 1,
      },
      {
        filetype = 'DiffviewFiles',
        text = 'Diff View',
        highlight = 'PanelHeading',
        padding = 1,
      },
      {
        filetype = 'flutterToolsOutline',
        text = 'Flutter Outline',
        highlight = 'PanelHeading',
      },
      {
        filetype = 'packer',
        text = 'Packer',
        highlight = 'PanelHeading',
        padding = 1,
      },
    },
  },
}
