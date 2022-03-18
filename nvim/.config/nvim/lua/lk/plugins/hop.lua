local hop = require("hop")
local nmap = lk.nmap

hop.setup({ winblend = 100 })

local map_otps = { noremap = true, silent = true }

nmap("f", ":HopWordCurrentLineAC<CR>", map_otps)
nmap("F", ":HopWordCurrentLineBC<CR>", map_otps)
