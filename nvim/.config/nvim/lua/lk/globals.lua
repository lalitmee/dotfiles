local core = require("lk/utils/core")

local fn = vim.fn
local api = vim.api
local fmt = string.format
local L = vim.log.levels

----------------------------------------------------------------------
-- NOTE: print contents of the table {{{
-----------------------------------------------------------------------------
P = function(v)
  print(vim.inspect(v))
  return v
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Global namespace {{{
-----------------------------------------------------------------------------
--- Inspired by @tjdevries' astraunauta.nvim/ @TimUntersberger's config
--- store all callbacks in one global table so they are able to survive re-requiring this file
_G.__lk_global_callbacks = __lk_global_callbacks or {}

_G.lk = { _store = __lk_global_callbacks }
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: UI {{{
-----------------------------------------------------------------------------
-- Consistent store of various UI items to reuse throughout my config
lk.style = {
  icons = {
    error = " ",
    hint = "",
    info = " ",
    warn = " ",
    trace = "🖉",
    debug = "🐞",
  },
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Messaging {{{
-----------------------------------------------------------------------------
if vim.notify then
  -- Override of vim.notify to open floating window
  local log = require("plenary.log").new({
    plugin = "notify",
    level = "debug",
    use_console = false,
  })

  vim.notify = function(msg, level, opts)
    log.info(msg, level, opts)
    require("notify")(msg, level, opts)
  end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Debugging {{{
-----------------------------------------------------------------------------
RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- USAGE:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

-- inspect the contents of an object very quickly in your code or from the command-line:
-- usage:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: packer plugins {{{
----------------------------------------------------------------------
local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function lk.plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath("data") .. "/site/pack/packer/start/*", true, true)
    local opt = fn.expand(fn.stdpath("data") .. "/site/pack/packer/opt/*", true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return fn.fnamemodify(path, ":t")
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function _G.plugin_loaded(plugin_name)
  local plugins = _G.packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end

function lk.total_plugins()
  local base_path = fn.stdpath("data") .. "/site/pack/packer/"
  local start = vim.split(fn.globpath(base_path .. "start", "*"), "\n")
  local opt = vim.split(fn.globpath(base_path .. "opt", "*"), "\n")
  local start_count = vim.tbl_count(start)
  local opt_count = vim.tbl_count(opt)
  return {
    total = start_count + opt_count,
    start = start_count,
    lazy = opt_count,
  }
end

function _G.packer_notify(msg, level)
  vim.notify(msg, level, { title = "Packer" })
end

function _G.plugin_loaded(plugin_name)
  local plugins = _G.packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end

-- }}}
----------------------------------------------------------------------

---------------------------------------------------------------------
-- NOTE: Utils {{{
-----------------------------------------------------------------------------
function lk.is_empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "string" then
    return item == ""
  elseif item_type == "table" then
    return vim.tbl_isempty(item)
  end
end

function lk._create(f)
  table.insert(lk._store, f)
  return #lk._store
end

function lk._execute(id, args)
  lk._store[id](args)
end

---Check if a cmd is executable
---@param e string
---@return boolean
function lk.executable(e)
  return fn.executable(e) > 0
end

---Echo a msg to the commandline
---@param msg string | table
---@param hl string
function lk.echomsg(msg, hl)
  hl = hl or "Title"
  local msg_type = type(msg)
  assert(
    msg_type ~= "string" or msg_type ~= "table",
    fmt("message should be a string or list of strings not a %s", msg_type)
  )
  if msg_type == "string" then
    msg = { { msg, hl } }
  end
  vim.api.nvim_echo(msg, true, {})
end

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function lk.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      lk.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

--- Usage:
--- 1. Call `local stop = utils.profile('my-log')` at the top of the file
--- 2. At the bottom of the file call `stop()`
--- 3. Restart neovim, the newly created log file should open
function lk.profile(filename)
  local base = "/tmp/config/profile/"
  fn.mkdir(base, "p")
  local success, profile = pcall(require, "plenary.profile.lua_profiler")
  if not success then
    vim.api.nvim_echo({ "Plenary is not installed.", "Title" }, true, {})
  end
  profile.start()
  return function()
    profile.stop()
    local logfile = base .. filename .. ".log"
    profile.report(logfile)
    vim.defer_fn(function()
      vim.cmd("tabedit " .. logfile)
    end, 1000)
  end
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function lk.has(feature)
  return vim.fn.has(feature) > 0
end

---Check if directory exists using vim's isdirectory function
---@param path string
---@return boolean
function lk.is_dir(path)
  return fn.isdirectory(path) > 0
end

---Check if a vim variable usually a number is truthy or not
---@param value integer
function lk.truthy(value)
  assert(type(value) == "number", fmt("Value should be a number but you passed %s", value))
  return value > 0
end

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function lk.find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---Determine if a value of any type is empty
---@param item any
---@return boolean
function lk.empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "string" then
    return item == ""
  elseif item_type == "table" then
    return vim.tbl_isempty(item)
  end
end

---check if a mapping already exists
---@param lhs string
---@param mode string
---@return boolean
function lk.has_map(lhs, mode)
  mode = mode or "n"
  return vim.fn.maparg(lhs, mode) ~= ""
end

local function validate_opts(opts)
  if not opts then
    return true
  end

  if type(opts) ~= "table" then
    return false, "opts should be a table"
  end

  if opts.buffer and type(opts.buffer) ~= "number" then
    return false, "The buffer key should be a number"
  end

  return true
end

local function validate_mappings(lhs, rhs, opts)
  vim.validate({
    lhs = { lhs, "string" },
    rhs = {
      rhs,
      function(a)
        local arg_type = type(a)
        return arg_type == "string" or arg_type == "function"
      end,
      "right hand side",
    },
    opts = { opts, validate_opts, "mapping options are incorrect" },
  })
end

----------------------------------------------------------------------
-- NOTE: mappings creator {{{
----------------------------------------------------------------------
---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    assert(lhs ~= mode, fmt("The lhs should not be the same as mode for %s", lhs))
    local _opts = opts and vim.deepcopy(opts) or {}

    validate_mappings(lhs, rhs, _opts)

    if _opts.check_existing and lk.has_map(lhs, mode) then
      return
    else
      -- don't pass this invalid key to set keymap
      _opts.check_existing = nil
    end

    -- add functions to a global table keyed by their index
    if type(rhs) == "function" then
      local fn_id = lk._create(rhs)
      rhs = string.format("<cmd>lua lk._execute(%s)<CR>", fn_id)
    end

    if _opts.buffer then
      -- Remove the buffer from the args sent to the key map function
      local bufnr = _opts.buffer
      _opts.buffer = nil
      _opts = vim.tbl_extend("keep", _opts, parent_opts)
      api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, _opts)
    else
      api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend("keep", _opts, parent_opts))
    end
  end
end

local map_opts = { noremap = false, silent = true }
local noremap_opts = { noremap = true, silent = true }

lk.nmap = make_mapper("n", map_opts)
lk.xmap = make_mapper("x", map_opts)
lk.imap = make_mapper("i", map_opts)
lk.vmap = make_mapper("v", map_opts)
lk.omap = make_mapper("o", map_opts)
lk.tmap = make_mapper("t", map_opts)
lk.smap = make_mapper("s", map_opts)
lk.cmap = make_mapper("c", { noremap = false, silent = false })

lk.nnoremap = make_mapper("n", noremap_opts)
lk.xnoremap = make_mapper("x", noremap_opts)
lk.vnoremap = make_mapper("v", noremap_opts)
lk.inoremap = make_mapper("i", noremap_opts)
lk.onoremap = make_mapper("o", noremap_opts)
lk.tnoremap = make_mapper("t", noremap_opts)
lk.snoremap = make_mapper("s", noremap_opts)
lk.cnoremap = make_mapper("c", { noremap = true, silent = false })

local function get_defaults(mode)
  return { noremap = true, silent = not mode == "c" }
end

function lk.map(mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function lk.buf_map(bufnr, mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: command creator {{{
----------------------------------------------------------------------
---Create an nvim command
---@param args table
function lk.command(args)
  local nargs = args.nargs or 0
  local name = args[1]
  local rhs = args[2]
  local types = (args.types and type(args.types) == "table") and table.concat(args.types, " ") or ""

  if type(rhs) == "function" then
    local fn_id = lk._create(rhs)
    rhs = string.format("lua lk._execute(%d%s)", fn_id, nargs > 0 and ", <f-args>" or "")
  end

  vim.cmd(string.format("command! -nargs=%s %s %s %s", nargs, types, name, rhs))
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: source a file {{{
----------------------------------------------------------------------
---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
function lk.source(path, prefix)
  if not prefix then
    vim.cmd(fmt("source %s", path))
  else
    vim.cmd(fmt("source %s/%s", vim.g.vim_dir, path))
  end
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: safe require {{{
----------------------------------------------------------------------
---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function lk.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, L.ERROR, { title = fmt("Error requiring: %s", module) })
  end
  return ok, result
end
-- }}}
----------------------------------------------------------------------
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: autocommand creator {{{
----------------------------------------------------------------------
---@class Autocommand
---@field events string[] list of autocommand events
---@field targets string[] list of autocommand patterns
---@field modifiers string[] e.g. nested, once
---@field command string | function

---@param command Autocommand
local function is_valid_target(command)
  local valid_type = command.targets and vim.tbl_islist(command.targets)
  return valid_type or vim.startswith(command.events[1], "User ")
end

---Create an autocommand
---@param name string
---@param commands Autocommand[]
function lk.augroup(name, commands)
  vim.cmd("augroup " .. name)
  vim.cmd("autocmd!")
  for _, c in ipairs(commands) do
    if c.command and c.events and is_valid_target(c) then
      local command = c.command
      if type(command) == "function" then
        local fn_id = lk._create(command)
        command = fmt("lua lk._execute(%s)", fn_id)
      end
      c.events = type(c.events) == "string" and { c.events } or c.events
      vim.cmd(
        string.format(
          "autocmd %s %s %s %s",
          table.concat(c.events, ","),
          table.concat(c.targets or {}, ","),
          table.concat(c.modifiers or {}, " "),
          command
        )
      )
    else
      vim.notify(fmt("An autocommand in %s is specified incorrectly: %s", name, vim.inspect(name)), L.ERROR)
    end
  end
  vim.cmd("augroup END")
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: qflist util {{{
----------------------------------------------------------------------
-- set qflist and open
function lk.qf_populate(lines, mode)
  if mode == nil or type(mode) == "table" then
    lines = core.foreach(lines, function(item)
      return {
        filename = item,
        lnum = 1,
        col = 1,
        text = item,
      }
    end)
    mode = "r"
  end

  vim.fn.setqflist(lines, mode)

  vim.cmd([[
        copen
        setlocal nobuflisted
        setlocal number
        setlocal signcolumn=no
        setlocal bufhidden=wipe
        wincmd p
    ]])
end
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
