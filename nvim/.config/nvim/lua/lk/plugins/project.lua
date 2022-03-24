local ok, project = lk.safe_require("project_nvim")
if not ok then
  return
end

-- setup
project.setup()

-- telescope extension
require("telescope").load_extension("projects")
