local M = {
    "Exafunction/codeium.vim",
    event = { "InsertEnter" },
}

M.config = function()
    vim.keymap.set("i", "<Tab>", function()
        return vim.fn["codeium#Accept"]()
    end, { expr = true })

    vim.g.codeium_filetypes = {
        TelescopePrompt = false,
    }
end

return M
