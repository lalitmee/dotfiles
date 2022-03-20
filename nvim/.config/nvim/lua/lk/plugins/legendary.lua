local legendary = require("legendary")

local noremap = lk.nnoremap

legendary.setup({
  include_builtin = true,
  auto_register_which_key = true,
})

noremap("<C-p>", "<cmd>lua require('legendary').find()<CR>")
