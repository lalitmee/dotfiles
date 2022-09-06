local core = require("lk/utils/core")

local fn = vim.fn
local api = vim.api
local fmt = string.format
local l = vim.log.levels

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

_G.lk = {
  _store = __lk_global_callbacks,

  -- for UI elements like the winbar and statusline that need global references
  ui = {},
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Mappings {{{
----------------------------------------------------------------------
---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == "string" and { label = opts } or opts and vim.deepcopy(opts) or {}
    if opts.label then
      local ok, wk = lk.require("which-key", { silent = true })
      if ok then
        wk.register({ [lhs] = opts.label }, { mode = mode })
      end
      opts.label = nil
    end
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts, parent_opts))
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive commandline mapping
lk.nmap = make_mapper("n", map_opts)
-- A recursive select mapping
lk.xmap = make_mapper("x", map_opts)
-- A recursive terminal mapping
lk.imap = make_mapper("i", map_opts)
-- A recursive operator mapping
lk.vmap = make_mapper("v", map_opts)
-- A recursive insert mapping
lk.omap = make_mapper("o", map_opts)
-- A recursive visual & select mapping
lk.tmap = make_mapper("t", map_opts)
-- A recursive visual mapping
lk.smap = make_mapper("s", map_opts)
-- A recursive normal mapping
lk.cmap = make_mapper("c", { remap = true, silent = false })
-- A non recursive normal mapping
lk.nnoremap = make_mapper("n", noremap_opts)
-- A non recursive visual mapping
lk.xnoremap = make_mapper("x", noremap_opts)
-- A non recursive visual & select mapping
lk.vnoremap = make_mapper("v", noremap_opts)
-- A non recursive insert mapping
lk.inoremap = make_mapper("i", noremap_opts)
-- A non recursive operator mapping
lk.onoremap = make_mapper("o", noremap_opts)
-- A non recursive terminal mapping
lk.tnoremap = make_mapper("t", noremap_opts)
-- A non recursive select mapping
lk.snoremap = make_mapper("s", noremap_opts)
-- A non recursive commandline mapping
lk.cnoremap = make_mapper("c", { silent = false })

local function get_defaults(mode)
  return { noremap = true, silent = not mode == "c" }
end

function lk.map(mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.keymap.set(mode, lhs, rhs, opts)
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: UI {{{
-----------------------------------------------------------------------------
-- Consistent store of various UI items to reuse throughout my config
lk.style = {
  icons = {
    lsp = {
      error = "",
      hint = "",
      info = "",
      warn = "",
    },
    notify = {
      debug = "",
      error = "",
      info = "",
      trace = "🖉",
      warn = "",
    },
    kind = {
      Class = "",
      Color = "",
      Constant = "",
      Constructor = "",
      Default = "",
      Enum = "了",
      EnumMember = "",
      Event = "",
      Field = "",
      File = "",
      Folder = "",
      Function = "",
      Interface = "ﰮ",
      Keyword = "",
      Method = "ƒ",
      Module = "",
      Operator = "○",
      Property = "",
      Reference = "",
      Snippet = "﬌",
      Struct = "",
      Text = "",
      TypeParameter = "⅀",
      Unit = "",
      Value = "",
      Variable = "",
    },
    git = {
      Add = " ",
      Mod = " ",
      Remove = " ",
      Ignore = " ",
      Rename = " ",
      Diff = " ",
      Repo = " ",
    },
    documents = {
      File = " ",
      Files = " ",
      Folder = " ",
      OpenFolder = " ",
    },
    ui = {
      BigCircle = " ",
      BigUnfilledCircle = " ",
      BookMark = " ",
      Bug = " ",
      Calendar = " ",
      Check = " ",
      ChevronRight = "",
      Circle = " ",
      Close = " ",
      Code = " ",
      Comment = " ",
      Dashboard = " ",
      Fire = " ",
      Gear = " ",
      History = " ",
      Lightbulb = " ",
      List = " ",
      Lock = " ",
      NewFile = " ",
      Note = " ",
      Package = " ",
      Pencil = " ",
      Project = " ",
      Search = " ",
      SignIn = " ",
      Table = " ",
      Telescope = " ",
    },
    misc = {
      ellipsis = "…",
      up = "⇡",
      down = "⇣",
      line = "ℓ", -- ''
      indent = "Ξ",
      tab = "⇥",
      bug = "", -- 'ﴫ'
      question = "",
      lock = "",
      circle = "",
      project = "",
      dashboard = "",
      history = "",
      comment = "",
      robot = "ﮧ",
      lightbulb = "",
      search = "",
      code = "",
      telescope = "",
      gear = "",
      package = "",
      list = "",
      sign_in = "",
      check = "",
      fire = "",
      note = "",
      bookmark = "",
      pencil = "",
      tools = "",
      caret_right = "",
      chevron_right = "",
      double_chevron_right = "»",
      table = "",
      calendar = "",
      block = "▌",
    },
  },
  border = {
    line = {
      { "🭽", "FloatBorder" },
      { "▔", "FloatBorder" },
      { "🭾", "FloatBorder" },
      { "▕", "FloatBorder" },
      { "🭿", "FloatBorder" },
      { "▁", "FloatBorder" },
      { "🭼", "FloatBorder" },
      { "▏", "FloatBorder" },
    },
  },
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: Messaging {{{
-----------------------------------------------------------------------------
-- if vim.notify then
--   -- Override of vim.notify to open floating window
--   local log = require("plenary.log").new({
--     plugin = "notify",
--     level = "debug",
--     use_console = false,
--   })
--
--   -- vim.notify = function(msg, level, opts)
--   --   log.info(msg, level, opts)
--   --   require("notify")(msg, level, opts)
--   -- end
-- end
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
  elseif item_type == "number" then
    return item <= 0
  elseif item_type == "table" then
    return vim.tbl_isempty(item)
  end
  return false
end

---check if a mapping already exists
---@param lhs string
---@param mode string
---@return boolean
function lk.has_map(lhs, mode)
  mode = mode or "n"
  return vim.fn.maparg(lhs, mode) ~= ""
end

function lk.has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

---Reload lua modules
---@param path string
---@param recursive string
function lk.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= "_G" and value and fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

----------------------------------------------------------------------
-- NOTE: command creator {{{
----------------------------------------------------------------------
---Create an nvim command
---@param name any
---@param rhs string|fun(args: string, fargs: table, bang: boolean)
---@param opts table
function lk.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
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
function lk.require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then
      result = opts.message .. "\n" .. result
    end
    vim.notify(result, l.ERROR, { title = fmt("Error requiring: %s", module) })
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
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function lk.augroup(name, commands)
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
      group = id,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
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

function lk.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T
---@return T
function lk.fold(callback, list, accum)
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum, "The accumulator must be returned on each iteration")
  end
  return accum
end

-- vim:foldmethod=marker
