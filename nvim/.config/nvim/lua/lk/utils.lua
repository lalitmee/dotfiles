_G.lk_utils = {
  -- TODO: once commands and mappings can take functions
  -- as arguments natively remove these globals
  command_callbacks = {},
  mapping_callbacks = {},
}

local fn = vim.fn
local api = vim.api

function lk_utils.echomsg(msg, hl)
  hl = hl or "Title"
  local msg_type = type(msg)
  if msg_type ~= "string" or "table" then
    return
  end
  if msg_type == "string" then
    msg = { { msg, hl } }
  end
  api.nvim_echo(msg, true, {})
end

function lk_utils.total_plugins()
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

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function lk_utils.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      lk_utils.deep_merge(t1[k], t2[k])
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
function lk_utils.profile(filename)
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

function lk_utils.has(feature)
  return vim.fn.has(feature) > 0
end

local function get_defaults(mode)
  return { noremap = true, silent = not mode == "c" }
end

local function validate_opts(opts)
  if not opts then
    return true
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

local mappings_table_name = "lk_utils.mapping_callbacks"
local function make_mapper(mode, _opts)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(_opts)
  return function(lhs, rhs, __opts)
    local opts = __opts and vim.deepcopy(__opts) or {}

    validate_mappings(lhs, rhs, opts)

    -- add functions to a global table keyed by their index
    if type(rhs) == "function" then
      table.insert(lk_utils.mapping_callbacks, rhs)
      rhs = string.format("<cmd>lua %s[%d]()<CR>", mappings_table_name, #lk_utils.mapping_callbacks)
    end

    if opts.buffer then
      -- Remove the buffer from the args sent to the key map function
      local bufnr = opts.buffer
      opts.buffer = nil
      opts = vim.tbl_extend("keep", opts, parent_opts)
      api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    else
      api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend("keep", opts, parent_opts))
    end
  end
end

local map_opts = { noremap = false, silent = true }
lk_utils.nmap = make_mapper("n", map_opts)
lk_utils.xmap = make_mapper("x", map_opts)
lk_utils.imap = make_mapper("i", map_opts)
lk_utils.vmap = make_mapper("v", map_opts)
lk_utils.omap = make_mapper("o", map_opts)
lk_utils.tmap = make_mapper("t", map_opts)
lk_utils.smap = make_mapper("s", map_opts)
lk_utils.cmap = make_mapper("c", { noremap = false, silent = false })

local noremap_opts = { noremap = true, silent = true }
lk_utils.nnoremap = make_mapper("n", noremap_opts)
lk_utils.xnoremap = make_mapper("x", noremap_opts)
lk_utils.vnoremap = make_mapper("v", noremap_opts)
lk_utils.inoremap = make_mapper("i", noremap_opts)
lk_utils.onoremap = make_mapper("o", noremap_opts)
lk_utils.tnoremap = make_mapper("t", noremap_opts)
lk_utils.cnoremap = make_mapper("c", { noremap = true, silent = false })

function lk_utils.map(mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function lk_utils.buf_map(bufnr, mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

function lk_utils.command(args)
  local commands_table_name = "lk_utils.command_callbacks"
  local nargs = args.nargs or 0
  local name = args[1]
  local rhs = args[2]
  local types = (args.types and type(args.types) == "table") and table.concat(args.types, " ") or ""

  if type(rhs) == "function" then
    table.insert(lk_utils.command_callbacks, rhs)
    rhs = string.format(
      "lua %s[%d](%s)",
      commands_table_name,
      #lk_utils.command_callbacks,
      nargs == 0 and "" or "<f-args>"
    )
  end

  vim.cmd(string.format("command! -nargs=%s %s %s %s", nargs, types, name, rhs))
end

function lk_utils.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= "_G" and value and vim.fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

function lk_utils.is_empty(item)
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

function lk_utils.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function lk_utils.warn(msg, name)
  lk_utils.log(msg, "LspDiagnosticsDefaultWarning", name)
end

function lk_utils.error(msg, name)
  lk_utils.log(msg, "LspDiagnosticsDefaultError", name)
end

function lk_utils.info(msg, name)
  lk_utils.log(msg, "LspDiagnosticsDefaultInformation", name)
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

function _G.packer_notify(msg, level)
  vim.notify(msg, level, { title = "Packer" })
end

function _G.plugin_loaded(plugin_name)
  local plugins = _G.packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end
