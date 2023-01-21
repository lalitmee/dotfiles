local M = {
    "Exafunction/codeium.vim",
    event = { "VeryLazy" },
}

function M.config()
    vim.keymap.set("i", "<Tab>", function()
        return vim.fn["codeium#Accept"]()
    end, { expr = true })
end

return M
