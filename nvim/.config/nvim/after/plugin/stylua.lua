-- Used to run stylua automatically if in a lua file
-- and the file "stylua.toml" exists in the base root of the repo.
--
-- Otherwise doesn't do anything.

if vim.fn.executable("stylua") == 0 then
  vim.notify("StyLua executable not found", "error", { title = "[stylua] Failed" })
  return
end

vim.cmd([[
  augroup StyluaAuto
    autocmd BufWritePre *.lua :lua require("lk.stylua").format()
  augroup END
]])
