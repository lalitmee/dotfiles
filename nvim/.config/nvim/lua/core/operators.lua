local map = lk.map

-- make some backward-jumping operators inclusive (include character under cursor)
-- Operator-pending mode inclusive backward motions
map("o", "F", "vF", { noremap = true })
map("o", "T", "vT", { noremap = true })
map("o", "b", "vb", { noremap = true })
map("o", "B", "vB", { noremap = true })
map("o", "^", "v^", { noremap = true })
map("o", "0", "v0", { noremap = true })
