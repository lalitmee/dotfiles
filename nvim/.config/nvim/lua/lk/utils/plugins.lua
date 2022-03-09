local M = {}

local fmt = string.format
local fn = vim.fn
M.is_work = vim.env.WORK ~= nil
M.is_home = not M.is_work

---A thin wrapper around vim.notify to add packer details to the message
---@param msg string
function M.packer_notify(msg, level)
  vim.notify(msg, level, { title = "Packer" })
end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
-- NOTE: install packer as an opt plugin since it's loaded conditionally on my local machine
-- it needs to be installed as optional so the install dir is consistent across machines
function M.bootstrap_packer()
  local install_path = fmt("%s/site/pack/packer/opt/packer.nvim", fn.stdpath("data"))
  if fn.empty(fn.glob(install_path)) > 0 then
    M.packer_notify("Downloading packer.nvim...")
    M.packer_notify(fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }))
    vim.cmd("packadd! packer.nvim")
    require("packer").sync()
  else
    vim.cmd(fmt("packadd! %s", "packer.nvim"))
  end
end

return M
