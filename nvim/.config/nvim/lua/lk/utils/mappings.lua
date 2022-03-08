-----------------------------------------------------------------------------//
-- MAPPINGS
-----------------------------------------------------------------------------//
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
      local ok, wk = lk.safe_require("which-key", { silent = true })
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

function lk.buf_map(bufnr, mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end
