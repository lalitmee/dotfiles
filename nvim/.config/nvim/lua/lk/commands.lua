local command = lk.command
local fmt = string.format
local fn = vim.fn

----------------------------------------------------------------------
-- NOTE:pakcer commands {{{
----------------------------------------------------------------------
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

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  lk.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: replacer.nvim commands {{{
----------------------------------------------------------------------
command({
  "ReplacerRunFiles",
  function()
    require("replacer").run()
  end,
})

command({
  "ReplacerRun",
  function()
    require("replacer").run({ rename_files = false })
  end,
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: buffer commands {{{
----------------------------------------------------------------------
command({
  "BufferCloseAllButCurrent",
  function()
    vim.cmd([[:bd|e#|bd#"]])
  end,
})

----------------------------------------------------------------------
-- NOTE: memento commands {{{
----------------------------------------------------------------------
command({
  "RecentBuffers",
  function()
    require("memento").toggle()
  end,
})

command({
  "ClearRecentBuffers",
  function()
    require("memento").clear_history()
  end,
})
-- }}}
----------------------------------------------------------------------

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: telescope commands {{{
----------------------------------------------------------------------
command({
  "TelescopeLiveGrepRaw",
  function()
    require("telescope").extensions.live_grep_raw.live_grep_raw()
  end,
})

command({
  "TelescopeNotifyHistory",
  function()
    require("telescope").extensions.notify.notify()
  end,
})

command({
  "ReloadConfigTelescope",
  function()
    require("lk/utils/reload").reload()
  end,
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: config commands {{{
----------------------------------------------------------------------
command({
  "ReloadConfig",
  function()
    require("lk/utils/reload").reload_config()
  end,
})

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
