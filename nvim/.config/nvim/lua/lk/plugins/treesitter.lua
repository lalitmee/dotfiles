----------------------------------------------------------------------
-- NOTE: norg setup {{{
----------------------------------------------------------------------
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

-- These two are optional and provide syntax highlighting
-- for Neorg tables and the @document.meta tag
parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main",
  },
}

parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main",
  },
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: treesitter setup {{{
----------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  -- ensure_installed = vim.g.enable_treesitter_ft,
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = { "org" },
    additional_vim_regex_highlighting = { "org" },
  },
  matchup = { enable = true },
  autotag = { enable = true },
  indent = { enable = true, disable = { "css" } },
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
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
