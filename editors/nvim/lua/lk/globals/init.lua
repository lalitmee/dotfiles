P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

local utils = require('lk.utils')

_G.lk_utils = {
  map = utils.map,
  nnoremap = utils.nnoremap,
  xnoremap = utils.xnoremap,
  vnoremap = utils.vnoremap,
  inoremap = utils.inoremap,
  onoremap = utils.onoremap,
  cnoremap = utils.cnoremap,
  tnoremap = utils.tnoremap,
  nmap = utils.nmap,
  vmap = utils.vmap,
  imap = utils.imap,
  xmap = utils.xmap,
  smap = utils.smap,
  omap = utils.omap,
  cmap = utils.cmap,
  tmap = utils.tmap,
  command = utils.command,
  buf_map = utils.buf_map,
  profile = utils.profile,
  deep_merge = utils.deep_merge,
  has = utils.has,
  is_empty = utils.is_empty,
  command_callbacks = {},
  lsp = {},
  plugins_count = utils.total_plugins
}

-- inspect the contents of an object very quickly in your code or from the command-line:
-- usage:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

-- `vim.opt`
require('lk.globals.opt')
