local status_ok, lspsaga = lk.safe_require("lspsaga")
if not status_ok then
  vim.notify("Lspsaga not found", "error", { title = "[Lspsaga] Error" })
  return
end

lspsaga.setup({
  border_style = "round",
})

_G.auto_hover = true
_G.last_cursor_moved = vim.loop.now()
function AutoHover()
  -- don't bother if mode isn't normal and auto hover is disabled.
  if vim.fn.mode() ~= "n" or not _G.auto_hover then
    return
  end

  local timer = vim.loop.new_timer()
  local job = function()
    -- if should ignore or mode is no longer normal. ignore
    if vim.loop.now() - last_cursor_moved < 3000 or vim.fn.mode() ~= "n" then
      return
    end
    local hover = require("lspsaga.hover")
    if not hover.has_saga_hover() then
      hover.render_hover_doc()
    end
  end

  -- Start the timer job
  timer:start(3000, 0, vim.schedule_wrap(job))
end

-- lk.augroup("LspSagaAutoCmds", {
--   {
--     events = { "LspsagaHover" },
--     targets = { "FileType" },
--     command = "nnoremap <buffer><nowait><silent> <Esc> <cmd>close!<cr>",
--   },
-- })

vim.api.nvim_exec(
  [[
    augroup lspsaga_filetypes
      autocmd!
      autocmd FileType LspsagaHover nnoremap <buffer><nowait><silent> <Esc> <cmd>close!<cr>
      autocmd CursorMoved <buffer> lua last_cursor_moved = vim.loop.now()
      autocmd CursorHold <buffer> lua AutoHover()
    augroup END
  ]],
  ""
)
