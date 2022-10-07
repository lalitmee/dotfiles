local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

signs.setup({
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "│",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "│",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "_",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  numhl = true,
  linehl = false,
  watch_gitdir = { interval = 1000 },
  sign_priority = 6,
  update_debounce = 200,
  status_formatter = nil,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 500,
  },
  current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
  keymaps = {
    noremap = true,
    buffer = true,
    ["n <leader>ghn"] = {
      expr = true,
      "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
    },
    ["n <leader>ghp"] = {
      expr = true,
      "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
    },
    ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["n <leader>ghv"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n <leader>ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
  },
})
