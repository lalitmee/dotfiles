require'bufferline'.setup {
  options = {
    view = 'multiwindow',
    numbers = 'ordinal',
    number_style = '',
    mappings = false,
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level)
      local icon = level:match('error') and ' ' or ''
      return ' ' .. icon .. count
    end,
    show_buffer_close_icons = true,
    persist_buffer_sort = true,
    separator_style = 'thick',
    -- enforce_regular_tabs = false | true,
    always_show_bufferline = true,
    sort_by = function(buffer_a, buffer_b)
      print(vim.inspect(buffer_a))
      -- add custom logic
      return buffer_a.modified > buffer_b.modified
    end
  }
}
