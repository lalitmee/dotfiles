local nnoremap = lk.nnoremap
local xnoremap = lk.xnoremap

require("substitute").setup()

nnoremap("S", function()
  require("substitute").operator()
end)
xnoremap("S", function()
  require("substitute").visual()
end)
nnoremap("X", function()
  require("substitute.exchange").operator()
end)
xnoremap("X", function()
  require("substitute.exchange").visual()
end)
nnoremap("Xc", function()
  require("substitute.exchange").cancel()
end)
