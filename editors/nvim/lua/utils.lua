local M = {}

function M.get_cursor_pos() return {vim.fn.line('.'), vim.fn.col('.')} end

function M.debounce(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id ~= nil then vim.fn.timer_stop(timer_id) end
    local args = {...}

    timer_id = vim.fn.timer_start(timeout, function()
      func(args)
      timer_id = nil
    end)
  end
end

function M.throttle(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id == nil then
      func {...}
      timer_id = vim.fn.timer_start(timeout, function() timer_id = nil end)
    end
  end
end

function M.format_formatprg()
  local opt_exists, formatprg = pcall(function() return vim.bo.formatprg end)
  if opt_exists and #formatprg > 0 then
    local view = vim.fn.winsaveview()
    vim.api.nvim_command('normal gggqG')
    vim.fn.winrestview(view)
    return true
  else
    return false
  end
end

function M.u(code)
  if type(code) == 'string' then code = tonumber('0x' .. code) end
  local c = string.char
  if code <= 0x7f then return c(code) end
  local t = {}
  if code <= 0x07ff then
    t[1] = c(bit.bor(0xc0, bit.rshift(code, 6)))
    t[2] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  elseif code <= 0xffff then
    t[1] = c(bit.bor(0xe0, bit.rshift(code, 12)))
    t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    t[3] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  else
    t[1] = c(bit.bor(0xf0, bit.rshift(code, 18)))
    t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
    t[3] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    t[4] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  end
  return table.concat(t)
end

function _G.dump(...)
  local args = {...}
  if #args == 1 then
    print(vim.inspect(args[1]))
  else
    print(vim.inspect(args))
  end
end

function M.pcall(fn)
  local ok, err = pcall(fn)
  if not ok then print('ERROR:', err) end
end

function M.is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function M.has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

-- -- copied from https://github.com/lucastrvsn/dot/blob/master/.config/nvim/lua/utils.lua
-- function M.add(value, str, sep)
--   sep = sep or ","
--   str = str or ""
--   value = type(value) == "table" and table.concat(value, sep) or value
--   return str ~= "" and table.concat({value, str}, sep) or value
-- end

-- function M.concat(value)
--   return table.concat(value)
-- end

-- -- Apply global options
-- function M.apply_options(opts)
--   for k, v in pairs(opts) do vim.opt[k] = v end
-- end

-- function M.apply_globals(globals)
--   for k, v in pairs(globals) do vim.g[k] = v end
-- end

-- function M.apply_colorscheme(name, mode)
--   M.apply_options({
--     termguicolors = true,
--     guicursor = 'n-v-c-sm:block,i-ci-ve:ver50-Cursor,r-cr-o:hor50',
--     background = mode
--   })

--   M.apply_globals({
--     colors_name = name
--   })

--   vim.api.nvim_command('colorscheme ' .. name)
-- end

-- -- Map keys
-- function M.map(mode, key, fn, opts)
--   vim.api.nvim_set_keymap(mode, key, fn, opts or {})
-- end

-- -- Buffer local keymap
-- function M.buf_map(...)
--   vim.api.nvim_buf_set_keymap(bufnr, ...)
-- end

-- -- Buffer local option
-- function M.buf_option(...)
--   vim.api.nvim_buf_set_option(bufnr, ...)
-- end

-- -- Check whether the current buffer is empty
-- function M.is_buffer_empty()
--   return vim.fn.empty(vim.fn.expand('%:t')) == 1
-- end

-- -- Check if the windows width is greater than a given number of columns
-- function M.has_width_gt(cols)
--   return vim.fn.winwidth(0) / 2 > cols
-- end

return M
