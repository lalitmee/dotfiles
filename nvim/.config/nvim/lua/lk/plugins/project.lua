local ok, project = lk.safe_require("project_nvim")
if not ok then
  return
end

-- setup
project.setup({
  show_hidden = true,
})
