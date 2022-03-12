require("indent_blankline").setup({
  space_char_blankline = " ",
  char = "", -- │ ┊ ┆
  show_foldtext = false,
  show_current_context = true,
  show_current_context_start = false,
  show_first_indent_level = true,
  use_treesitter = true,
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
