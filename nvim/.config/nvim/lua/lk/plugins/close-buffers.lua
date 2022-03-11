require("close_buffers").setup({
  preserve_window_layout = { "this", "nameless" },
  next_buffer_cmd = function(windows)
    local bufnr = vim.api.nvim_get_current_buf()
    for _, window in ipairs(windows) do
      vim.api.nvim_win_set_buf(window, bufnr)
    end
  end,
})
