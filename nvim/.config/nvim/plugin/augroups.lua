local augroup = lk.augroup
local tnoremap = lk.tnoremap
local fn = vim.fn
local fmt = string.format

----------------------------------------------------------------------
-- NOTE: command line autocommands {{{
----------------------------------------------------------------------
--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
  --- Track the timer object and stop any previous timers before setting
  --- a new one so that each change waits for 10secs and that 10secs is
  --- deferred each time
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if fn.mode() == "n" then
        vim.cmd([[echon '']])
      end
    end, 10000)
  end
end

augroup("commandline_au", {
  {
    event = { "CmdlineLeave", "CmdlineChanged" },
    pattern = { ":" },
    command = clear_commandline(),
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: terminal autocommands {{{
----------------------------------------------------------------------
augroup("terminal_au", {
  {
    event = { "TermOpen" },
    pattern = { "term://*" },
    command = function()
      if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
        local opts = { silent = false, buffer = 0 }
        tnoremap("<esc>", [[<C-\><C-n>]], opts)
        tnoremap("jk", [[<C-\><C-n>]], opts)
        tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
        tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
        tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
        tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
        tnoremap("<BS>", [[<BS>]], opts)
      end
      vim.cmd([[startinsert]])
    end,
  },
  {
    event = { "TermEnter" },
    pattern = { "term://*" },
    command = function()
      vim.cmd([[startinsert]])
    end,
  },
  {
    event = { "TermLeave", "TermClose" },
    pattern = { "term://*" },
    command = function()
      vim.cmd([[stopinsert]])
    end,
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: highlight on yank {{{
----------------------------------------------------------------------
augroup("yank_au", {
  {
    -- don't execute silently in case of errors
    event = { "TextYankPost" },
    command = function()
      vim.highlight.on_yank({
        timeout = 500,
        on_visual = false,
        higroup = "IncSearch",
      })
    end,
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
