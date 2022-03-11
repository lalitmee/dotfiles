-- Used to run stylua automatically if in a lua file
-- and the file "stylua.toml" exists in the base root of the repo.
--
-- Otherwise doesn't do anything.

if vim.fn.executable("stylua") == 0 then
  vim.notify("StyLua executable not found", "error", { title = "[stylua] Failed" })
  return
end

lk.augroup("StyLuaAuto", {
  {
    event = "BufWritePre",
    pattern = "*.lua",
    command = function()
      require("lk.stylua").format()
    end,
  },
})
