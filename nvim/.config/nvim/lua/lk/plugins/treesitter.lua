require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained',
  highlight = { enable = true },
  autotag = { enable = true },
  indent = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 4000,
    -- disable = { 'lua', 'json' },
  },
  playground = { enable = true, updatetime = 25, persist_queries = false },
  context_commentstring = {
    enable = true,
    config = {
      javascript = {
        __default = '// %s',
        jsx_element = '{/* %s */}',
        jsx_fragment = '{/* %s */}',
        jsx_attribute = '// %s',
        comment = '// %s',
      },
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<localleader>tv',
      node_incremental = '<localleader>tv',
      scope_incremental = ']v',
      node_decremental = '[v',
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = '<localleader>td',
        list_definitions = '<localleader>tl',
        goto_definition_lsp_fallback = '<localleader>tD',
        list_definitions_toc = '<localleader>to',
        goto_next_usage = '<localleader>tn',
        goto_previous_usage = '<localleader>tp',
      },
    },
    smart_rename = {
      enable = true,
      keymaps = { smart_rename = '<localleader>tr' },
    },
  },
  textobjects = {
    lookahead = true,
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@conditional.outer',
        ['iC'] = '@conditional.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = { ['[w'] = '@parameter.inner' },
      swap_previous = { [']w'] = '@parameter.inner' },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { [']m'] = '@function.outer', [']c'] = '@class.outer' },
      goto_next_end = { [']M'] = '@function.outer', [']C'] = '@class.outer' },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
      goto_previous_end = { ['[M'] = '@function.outer', ['[C'] = '@class.outer' },
    },
    tree_docs = {
      enable = true,
      keymaps = {
        doc_node_at_cursor = '<localleader>tc',
        doc_all_in_range = '<localleader>tc',
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['df'] = '@function.outer',
        ['dF'] = '@class.outer',
      },
    },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
    },
  },
})

-- NOTE: fold method using treesitter
-- somehow I don't like it.

-- local parsers = require 'nvim-treesitter.parsers'
-- local configs = parsers.get_parser_configs()
-- local ft_str = table.concat(vim.tbl_map(function(ft)
--   return configs[ft].filetype or ft
-- end, parsers.available_parsers()), ',')

-- vim.cmd('autocmd! Filetype ' .. ft_str ..
--             ' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')
