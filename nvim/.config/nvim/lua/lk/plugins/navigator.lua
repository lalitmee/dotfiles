local ok, navigator = lk.safe_require("Navigator")
if not ok then
  return
end

navigator.setup()

----------------------------------------------------------------------
-- NOTE: commands {{{
----------------------------------------------------------------------
local command = lk.command

command({
  "NavigateLeft",
  function()
    navigator.left()
  end,
})

command({
  "NavigateDown",
  function()
    navigator.down()
  end,
})

command({
  "NavigateUp",
  function()
    navigator.up()
  end,
})

command({
  "NavigateRight",
  function()
    navigator.right()
  end,
})

command({
  "NavigatePrevious",
  function()
    navigator.previous()
  end,
})

-- }}}
----------------------------------------------------------------------
