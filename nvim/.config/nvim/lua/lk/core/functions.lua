local g = vim.g
local api = vim.api
local option = api.nvim_buf_get_option

local ok, Job = lk.require("plenary.job")
if not ok then
  return
end

--------------------------------------------------------------------------------
-- NOTE: notify current date and time {{{
--------------------------------------------------------------------------------
function Notify_current_datetime()
  local dt = vim.fn.strftime("%c")
  vim.notify("Current Date Time: " .. dt, 2, { title = "Date & Time" })
end
-- }}}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: yank current file name {{{
--------------------------------------------------------------------------------
function Yank_current_file_name()
  local file_name = vim.api.nvim_buf_get_name(0)
  local input_pipe = vim.loop.new_pipe(false)
  local yanker = Job:new({ writer = input_pipe, command = "xclip" })
  yanker:start()
  input_pipe:write(file_name)
  input_pipe:close()
  yanker:shutdown()
  vim.notify("Yanked: " .. file_name, 2, { title = "File Name Yanker", timeout = 1000 })
end
-- }}}
--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: show current file path {{{
----------------------------------------------------------------------
function Show_current_file_path()
  local file_path = vim.fn.expand("%")
  vim.notify(file_path, 2, { title = "[buffer] file path" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: show current working directry {{{
----------------------------------------------------------------------
function Get_current_working_directory()
  local cwd = vim.fn.getcwd()
  vim.notify(cwd, 2, { title = "[buffer] current working directory" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: debug variables {{{
----------------------------------------------------------------------
function Log_var()
  local word_under_cursor = vim.fn.expand("<cword>")
  local filetype = vim.bo.filetype
  if filetype == "lua" then
    vim.cmd(string.format("norm!oprint('%s', %s)", word_under_cursor, word_under_cursor))
  elseif
    filetype == "javascript"
    or filetype == "typescript"
    or filetype == "javascriptreact"
    or filetype == "typescriptreact"
  then
    vim.cmd(string.format("norm!oconsole.log({%s})", word_under_cursor))
  end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: save and execute {{{
----------------------------------------------------------------------
function Save_and_execute()
  local filetype = vim.bo.filetype
  local filepath = vim.fn.expand("%")
  if filetype == "lua" then
    vim.cmd([[
      silent! write
      luafile %
    ]])
  elseif filetype == "vim" then
    vim.cmd([[
      silent! write
      source %
    ]])
  else
    vim.cmd([[
      silent! write
    ]])
  end
  vim.notify(filepath, 2, { title = " Save and Execute" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: plenary reload module {{{
----------------------------------------------------------------------
function Reload(module)
  require("plenary.reload").reload_module(module)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: smart dd {{{
----------------------------------------------------------------------
function Smart_dd()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end

lk.map("n", "dd", Smart_dd, { noremap = true, expr = true })
-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: BufOnly {{{
--------------------------------------------------------------------------------
function BufOnly()
  local del_non_modifiable = g.bufonly_delete_non_modifiable or false
  local cur = api.nvim_get_current_buf()
  local deleted, modified = 0, 0
  for _, n in ipairs(api.nvim_list_bufs()) do
    -- If the iter buffer is modified one, then don't do anything
    if option(n, "modified") then
      -- iter is not equal to current buffer
      -- iter is modifiable or del_non_modifiable == true
      -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
      modified = modified + 1
    elseif n ~= cur and (option(n, "modifiable") or del_non_modifiable) then
      api.nvim_buf_delete(n, {})
      deleted = deleted + 1
    end
  end
  vim.notify(deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)", 2, { title = " BufOnly" })
end

lk.command("BufOnly", "lua BufOnly()", {})
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
