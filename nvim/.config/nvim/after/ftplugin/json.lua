local opt = vim.opt_local

opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.expandtab = true

-- When creating a new line with o, make sure there is a trailing comma on the
-- current line
vim.keymap.set("n", "o", function()
    local line = vim.api.nvim_get_current_line()

    local should_add_comma = string.find(line, "[^,{[]$")
    if should_add_comma then
        return "A,<cr>"
    else
        return "o"
    end
end, { buffer = true, expr = true })
