local command = lk.command
local augroup = lk.augroup
local fmt = string.format
local fn = vim.fn

local PACKER_COMPILED_PATH = fn.stdpath("cache") .. "/packer/packer_compiled.lua"

command({
  "PackerCompiledEdit",
  function()
    vim.cmd(fmt("edit %s", PACKER_COMPILED_PATH))
  end,
})

command({
  "PackerCompiledDelete",
  function()
    vim.fn.delete(PACKER_COMPILED_PATH)
    packer_notify(fmt("Deleted %s", PACKER_COMPILED_PATH))
  end,
})

augroup("PackerSetupInit", {
  {
    events = { "User PackerCompileDone" },
    command = function()
      vim.notify("  Packer compiled done", nil, { title = "Packer" })
    end,
  },
  {
    events = { "User PackerComplete" },
    command = function()
      vim.notify("  Packer completed the job", nil, { title = "Packer" })
    end,
  },
})
