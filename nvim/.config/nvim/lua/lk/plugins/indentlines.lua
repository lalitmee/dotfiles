-- vim.g.indent_blankline_char = '▏'
vim.g.indent_blankline_char = '│'
vim.g.indent_blankline_show_foldtext = false
vim.g.indent_blankline_show_first_indent_level = true
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_filetype_exclude =
    {
      '', -- for all buffers without a file type
      'NeogitStatus',
      'NvimTree',
      'TelescopePrompt',
      'dashboard',
      'dotooagenda',
      'flutterToolsOutline',
      'fugitive',
      'git',
      'gitcommit',
      'help',
      'json',
      'log',
      'lspinfo',
      'markdown',
      'packer',
      'peekaboo',
      'startify',
      'todoist',
      'txt',
      'undotree',
      'vimwiki',
      'vista'
    }
vim.g.indent_blankline_context_patterns =
    {
      '^if',
      '^table',
      'block',
      'class',
      'for',
      'function',
      'if_statement',
      'list_literal',
      'method',
      'selector',
      'while'
    }
