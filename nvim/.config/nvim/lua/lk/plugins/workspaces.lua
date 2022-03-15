local ok, workspaces = lk.safe_require("workspaces")
if not ok then
  return
end

workspaces.setup({
  hooks = {
    open = { "Telescope find_files" },
  },
})

require("telescope").load_extension("workspaces")

local function add_workspace()
  local workspaces_list = workspaces.get()
  local current_working_dir = vim.fn.getcwd()
  for _, workspace in ipairs(workspaces_list) do
    if workspace.path == current_working_dir then
      return
    end
    vim.cmd([[WorkspacesAdd]])
  end
end

lk.augroup("au_workspace", {
  {
    event = { "VimLeavePre" },
    command = function()
      add_workspace()
    end,
  },
})
