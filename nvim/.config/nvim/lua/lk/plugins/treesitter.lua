require("nvim-treesitter.configs").setup({
  -- ensure_installed = vim.g.enable_treesitter_ft,
  ensure_installed = "maintained",
  highlight = { enable = true },
  matchup = { enable = true },
  autotag = { enable = true },
  indent = { enable = true },
  playground = { enable = true, updatetime = 25, persist_queries = false },
  context_commentstring = { enable = true, enable_autocmd = false },
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
