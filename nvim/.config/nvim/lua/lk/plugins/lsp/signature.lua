require("lsp_signature").setup({
  bind = true,
  fix_pos = false,
  auto_close_after = 15, -- close after 15 seconds
  hint_enable = false,
  handler_opts = { border = "rounded" },
})
