local g, bo = vim.g, vim.bo
local api, cmd, fn, lsp = vim.api, vim.cmd, vim.fn, vim.lsp

local M = {}

function M.add(value, str, sep)
  sep = sep or ','
  str = str or ''
  value = type(value) == 'table' and table.concat(value, sep) or value
  return str ~= '' and table.concat({ value, str }, sep) or value
end

function M.concat(value)
  return table.concat(value)
end

function M.apply_options(opts)
  for k, v in pairs(opts) do
    if v == true then
      cmd('set ' .. k)
    elseif v == false then
      cmd(string.format('set no%s', k))
    else
      cmd(string.format('set %s=%s', k, v))
    end
  end
end

function M.apply_globals(opts)
  for k, v in pairs(opts) do
    g[k] = v
  end
end

function M.get_cursor_pos()
  return { vim.fn.line('.'), vim.fn.col('.') }
end

function M.debounce(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id ~= nil then
      vim.fn.timer_stop(timer_id)
    end
    local args = { ... }

    timer_id = vim.fn.timer_start(
                   timeout, function()
          func(args)
          timer_id = nil
        end
               )
  end
end

function M.throttle(func, timeout)
  local timer_id = nil
  return function(...)
    if timer_id == nil then
      func { ... }
      timer_id = vim.fn.timer_start(
                     timeout, function()
            timer_id = nil
          end
                 )
    end
  end
end

function M.format_formatprg()
  local opt_exists, formatprg = pcall(
                                    function()
        return vim.bo.formatprg
      end
                                )
  if opt_exists and #formatprg > 0 then
    local view = vim.fn.winsaveview()
    vim.api.nvim_command('normal gggqG')
    vim.fn.winrestview(view)
    return true
  else
    return false
  end
end

function M.pcall(func)
  local ok, err = pcall(func)
  if not ok then
    print('ERROR:', err)
  end
end

-- Key mapping
function M.map(mode, key, result, opts)
  opts = vim.tbl_extend(
             'keep', opts or {}, { noremap = true, silent = true, expr = false }
         )
  fn.nvim_set_keymap(mode, key, result, opts)
end

-- Buffer local keymap
function M.buf_map(...)
  vim.api.nvim_buf_set_keymap(bufnr, ...)
end

-- Buffer local option
function M.buf_option(...)
  vim.api.nvim_buf_set_option(bufnr, ...)
end

-- Check whether the current buffer is empty
function M.is_buffer_empty()
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

-- Check if the windows width is greater than a given number of columns
function M.has_width_gt(cols)
  return vim.fn.winwidth(0) / 2 > cols
end

function M.show_doc()
  local ft = api.nvim_buf_get_option(api.nvim_get_current_buf(), 'ft')
  if ft == 'vim' or ft == 'help' then
    api.nvim_exec('h ' .. fn.expand('<cword>'), '')
  else
    lsp.buf.signature_help()
  end
end

local current_hovered_word = nil
function M.hover()
  local new_current_hovered_word = fn.expand('<cword>')
  if current_hovered_word ~= new_current_hovered_word then
    lsp.buf.hover()
  end
  current_hovered_word = new_current_hovered_word
end

function M.apply_colorscheme(name, mode)
  M.apply_options(
      {
        termguicolors = true,
        guicursor = 'n-v-c-sm:block,i-ci-ve:ver50-Cursor,r-cr-o:hor50',
        background = mode
      }
  )

  M.apply_globals({ colors_name = name })

  vim.api.nvim_command('colorscheme ' .. name)
end

-- For moments when I don't want my cursor to stay on the tree
function M.move_cursor_from_tree()
  local nr = api.nvim_get_current_buf()
  local buf = api.nvim_buf_get_name(nr)
  if string.find(buf, 'NERD_tree') and nr > 1 then
    cmd('wincmd l')
  end
end

-- Open help vertically and press q to exit
function M.help_tab()
  if bo.buftype == 'help' then
    cmd('wincmd L')
    local nr = api.nvim_get_current_buf()
    api.nvim_buf_set_keymap(
        nr, '', 'q', ':q<CR>', { noremap = true, silent = true }
    )
  end
end

-- Usage:
-- hi(Cursor, { fg = bg_dark, bg = yellow })
function M.hi(group, styles)
  -- local command = string.format("hi! %s", group)
  local command = string.format('hi %s', group)
  if styles.bg then
    command = string.format('%s guibg=%s', command, styles.bg)
  end
  if styles.fg then
    command = string.format('%s guifg=%s', command, styles.fg)
  end
  if styles.cbg then
    command = string.format('%s ctermbg=%s', command, styles.cbg)
  end
  if styles.cfg then
    command = string.format('%s ctermfg=%s', command, styles.cfg)
  end
  if styles.gui then
    command = string.format('%s gui=%s', command, styles.gui)
  end
  cmd(command)
end

-- Usage:
-- highlights({
--      CursorLine   = { bg = bg },
--      Cursor       = { fg = bg_dark, bg = yellow }
-- })
function M.highlights(hi_table)
  for group, styles in pairs(hi_table) do
    M.hi(group, styles)
  end
end

function M.hiLink(src, dest)
  cmd(string.format('hi! link %s %s', src, dest))
end

function M.hiLinks(hi_table)
  for src, dest in pairs(hi_table) do
    M.hiLink(src, dest)
  end
end

-- takes a table of global variable names to toggle
function M.toggle_global_variables(global_variables)
  for _, g_var_name in ipairs(global_variables) do
    if g[g_var_name] == 0 then
      g[g_var_name] = 1
    elseif g[g_var_name] == 1 then
      g[g_var_name] = 0
    else
      print('error, must be 0 or 1')
    end
  end
end

-- helper for defining highlight groups
function M.set_hl(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui
  local link = options.link or false
  local target = options.target

  if not link then
    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
  else
    vim.cmd(string.format('hi! link', group, target))
  end
end

function M.u(code)
  if type(code) == 'string' then
    code = tonumber('0x' .. code)
  end
  local c = string.char
  if code <= 0x7f then
    return c(code)
  end
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

return M
