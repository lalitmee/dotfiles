require'bufferline'.setup {
  options = {
    numbers = 'ordinal',
    number_style = '',
    separator_style = 'thin',
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level)
      local icon = level:match('error') and ' ' or ''
      return ' ' .. icon .. ' ' .. count
    end
  }
}
