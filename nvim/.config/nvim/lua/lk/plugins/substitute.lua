local nnoremap = lk.nnoremap
local xnoremap = lk.xnoremap

require("substitute").setup()

-- substitute
nnoremap("S", function()
  require("substitute").operator()
end)
xnoremap("S", function()
  require("substitute").visual()
end)

-- exchange
nnoremap("X", function()
  require("substitute.exchange").operator()
end)
xnoremap("X", function()
  require("substitute.exchange").visual()
end)
nnoremap("Xc", function()
  require("substitute.exchange").cancel()
end)
