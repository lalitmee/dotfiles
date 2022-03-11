require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
    -- disable = { "org" },
    additional_vim_regex_highlighting = { "org" },
  },
  matchup = { enable = true },
  autotag = { enable = true },
  indent = { enable = true },
  playground = { enable = true, updatetime = 25, persist_queries = false },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<localleader>tv",
      node_incremental = "<localleader>tv",
      scope_incremental = "]v",
      node_decremental = "[v",
    },
  },
  textobjects = {
    lookahead = true,
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aC"] = "@conditional.outer",
        ["iC"] = "@conditional.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["[w"] = "@parameter.inner" },
      swap_previous = { ["]w"] = "@parameter.inner" },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]m"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]M"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = { ["[M"] = "@function.outer", ["[C"] = "@class.outer" },
    },
    tree_docs = {
      enable = true,
      keymaps = {
        doc_node_at_cursor = "<localleader>tc",
        doc_all_in_range = "<localleader>tc",
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer",
      },
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
