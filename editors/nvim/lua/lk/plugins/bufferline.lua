require'bufferline'.setup {
  options = {
    numbers = 'ordinal',
    number_style = '',
    separator_style = 'thick',
    -- show_close_icon = false,
    show_buffer_close_icons = false,
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level)
      local icon = level:match('error') and ' ' or ''
      return ' ' .. icon .. ' ' .. count
    end
  }
}
