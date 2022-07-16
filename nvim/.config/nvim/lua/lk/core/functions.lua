local ok, Job = lk.safe_require("plenary.job")
if not ok then
  return
end

--------------------------------------------------------------------------------
-- NOTE: notify current date and time {{{
--------------------------------------------------------------------------------
function Notify_current_datetime()
  local dt = vim.fn.strftime("%c")
  vim.notify("Current Date Time: " .. dt, "info", { title = "Date & Time" })
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
  vim.notify("Yanked: " .. file_name, "info", { title = "File Name Yanker", timeout = 1000 })
end
-- }}}
--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: show current file path {{{
----------------------------------------------------------------------
function Show_current_file_path()
  local file_path = vim.fn.expand("%")
  vim.notify(file_path, "info", { title = "[buffer] file path" })
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: show current working directry {{{
----------------------------------------------------------------------
function Get_current_working_directory()
  local cwd = vim.fn.getcwd()
  vim.notify(cwd, "info", { title = "[buffer] current working directory" })
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
  vim.notify(filepath, "info", { title = "Save and Execute" })
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

-- vim:foldmethod=marker
