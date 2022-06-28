local map = lk.map

local opts = { noremap = true, silent = true }

map("n", "<C-c>", "<cmd>PickColor<cr>", opts)
map("i", "<C-c>", "<cmd>PickColorInsert<cr>", opts)

-- only need setup() if you want to change progress bar icons
require("color-picker").setup({
  -- ["icons"] = { "ﱢ", "" },
  -- ["icons"] = { "ﮊ", "" },
  -- ["icons"] = { "", "ﰕ" },
  ["icons"] = { "ﱢ", "" },
  -- ["icons"] = { "", "" },
  -- ["icons"] = { "", "" },
})
