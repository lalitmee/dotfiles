local ok, yanky = lk.require("yanky")
if not ok then
  return
end

----------------------------------------------------------------------
-- NOTE: setup {{{
----------------------------------------------------------------------
yanky.setup({
  highlight = {
    timer = 40,
  },
})

-- yanky extension
require("telescope").load_extension("yank_history")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: mappings {{{
----------------------------------------------------------------------
local nmap = lk.nmap
local xmap = lk.xmap

-- put mappings
nmap("P", "<Plug>(YankyPutBefore)", {})
nmap("gP", "<Plug>(YankyGPutBefore)", {})
nmap("gp", "<Plug>(YankyGPutAfter)", {})
nmap("p", "<Plug>(YankyPutAfter)", {})
xmap("P", "<Plug>(YankyPutBefore)", {})
xmap("gP", "<Plug>(YankyGPutBefore)", {})
xmap("gp", "<Plug>(YankyGPutAfter)", {})
xmap("p", "<Plug>(YankyPutAfter)", {})

-- yanking mappings
nmap("y", "<Plug>(YankyYank)", {})
xmap("y", "<Plug>(YankyYank)", {})

-- cycle mappings
nmap("<c-n>", "<Plug>(YankyCycleForward)", {})
nmap("<c-p>", "<Plug>(YankyCycleBackward)", {})
-- }}}
----------------------------------------------------------------------
