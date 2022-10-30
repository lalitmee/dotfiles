local ok, open = lk.require("open")
if not ok then
    return
end

open.setup({})

vim.keymap.set("n", "gf", require("open").open_cword)
