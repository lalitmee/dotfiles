local ok, project = lk.safe_require("project_nvim")
if not ok then
  return
end

-- setup
project.setup({
  detection_methods = { "pattern", "lsp" },
  show_hidden = true,
  silent_chdir = false,
})
