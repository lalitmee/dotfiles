local ok, treesj = lk.require("treesj")
if not ok then
    return
end

treesj.setup({})

local opts = { silent = true }

lk.nnoremap("gS", [[<cmd>TSJSplit<CR>]], opts)
lk.nnoremap("gJ", [[<cmd>TSJJoin<CR>]], opts)
