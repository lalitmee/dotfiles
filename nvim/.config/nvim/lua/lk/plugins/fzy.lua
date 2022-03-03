local ok, fzy = lk.safe_require("fzy")
if not ok then
  return
end

local command = lk.command

command({
  "FzyFiles",
  function()
    fzy.execute("fd", fzy.sinks.edit_file)
  end,
})

command({
  "FzyBufferActions",
  function()
    fzy.actions.buffers()
  end,
})

command({
  "FzyLspTags",
  function()
    fzy.try(fzy.actions.lsp_tags, fzy.actions.buf_tags)
  end,
})

command({
  "FzyGitFiles",
  function()
    fzy.execute("git ls-files", fzy.sinks.edit_file)
  end,
})

command({
  "FzyQuickfix",
  function()
    fzy.actions.quickfix()
  end,
})

command({
  "FzyBLines",
  function()
    fzy.actions.buf_lines()
  end,
})

command({
  "FzyRg",
  function()
    fzy.execute("ag --nobreak --noheading .", fzy.sinks.edit_live_grep)
  end,
})
