local highlight = require("lk/highlights")

-- highlight.all({
--   { "IndentBlanklineIndent1", { guifg = "#E06C75", gui = "nocombine" } },
--   { "IndentBlanklineIndent2", { guifg = "#E5C07B", gui = "nocombine" } },
--   { "IndentBlanklineIndent3", { guifg = "#98C379", gui = "nocombine" } },
--   { "IndentBlanklineIndent4", { guifg = "#56B6C2", gui = "nocombine" } },
--   { "IndentBlanklineIndent5", { guifg = "#61AFEF", gui = "nocombine" } },
--   { "IndentBlanklineIndent6", { guifg = "#C678DD", gui = "nocombine" } },
-- })

vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup({
  show_end_of_line = true,
  space_char_blankline = " ",
  char = "│", -- ┆ ┊ 
  show_foldtext = false,
  show_current_context = true,
  show_current_context_start = false,
  show_first_indent_level = true,
  use_treesitter = true,
  -- char_highlight_list = {
  --   "IndentBlanklineIndent1",
  --   "IndentBlanklineIndent2",
  --   "IndentBlanklineIndent3",
  --   "IndentBlanklineIndent4",
  --   "IndentBlanklineIndent5",
  --   "IndentBlanklineIndent6",
  -- },
  filetype_exclude = {
    "dap-repl",
    "startify",
    "dashboard",
    "log",
    "fugitive",
    "gitcommit",
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "NvimTree",
    "git",
    "TelescopePrompt",
    "undotree",
    "flutterToolsOutline",
    "norg",
    "org",
    "orgagenda",
    "", -- for all buffers without a file type
  },
  buftype_exclude = { "terminal", "nofile" },
  context_patterns = {
    "class",
    "function",
    "method",
    "block",
    "list_literal",
    "selector",
    "^if",
    "^table",
    "if_statement",
    "while",
    "for",
  },
})
