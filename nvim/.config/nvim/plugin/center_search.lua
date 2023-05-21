local function cetner_search()
    local cmd_type = vim.fn.getcmdtype()
    if cmd_type == "/" or cmd_type == "?" then
        return [[<CR>zz]]
    end
    return [[<CR>]]
end

vim.keymap.set("c", [[<CR>]], cetner_search, { silent = true, expr = true })
