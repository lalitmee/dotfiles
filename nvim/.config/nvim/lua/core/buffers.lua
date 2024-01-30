--  NOTE: track buffers to close
local id = vim.api.nvim_create_augroup("startup", {
    clear = false,
})

local persistbuffer = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = id,
    pattern = { "*" },
    callback = function()
        vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
            buffer = 0,
            once = true,
            callback = function()
                persistbuffer()
            end,
        })
    end,
})

vim.keymap.set("n", "<leader>bu", function()
    local curbufnr = vim.api.nvim_get_current_buf()
    local buflist = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buflist) do
        if
            vim.bo[bufnr].buflisted
            and bufnr ~= curbufnr
            and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1)
        then
            vim.cmd("bd " .. tostring(bufnr))
        end
    end
end, { silent = true, desc = "Close unused buffers" })
