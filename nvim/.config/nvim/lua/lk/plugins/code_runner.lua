local ok, code_runner = lk.require("code_runner")
if not ok then
  return
end

code_runner.setup({
  startinsert = true,
  term = {
    position = "vert",
    size = 100,
  },
  filetype_path = vim.fn.expand("~/.config/nvim/code_runner.json"),
  project_path = vim.fn.expand("~/.config/nvim/project_manager.json"),
})
