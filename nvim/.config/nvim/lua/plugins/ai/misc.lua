-- Miscellaneous AI Tools
--
-- This file contains additional AI tools that complement CodeCompanion:
-- - GitHub Copilot for inline completions
-- - ChatGPT.nvim for additional chat functionality
-- - WTF.nvim for error diagnosis
-- - MCPHub.nvim for MCP protocol integration

-- [[ mcphub.nvim ]]
require("mcphub").setup({})
vim.keymap.set({ "n", "v" }, "<leader>cm", ":MCPHub<CR>", { desc = "MCP Hub", silent = true })

-- Windsurf AI completion integration
-- Disable default keybindings so we can map them customly.
vim.g.codeium_disable_bindings = 1

-- Disable by default and enable for specific programming languages.
vim.g.codeium_filetypes_disabled_by_default = true
vim.g.codeium_filetypes = {
    c = true,
    cpp = true,
    gitcommit = true,
    go = true,
    javascript = true,
    javascriptreact = true,
    lua = true,
    python = true,
    rust = true,
    typescript = true,
    typescriptreact = true,
    vim = true,
    yaml = true,
}

-- <Tab> accepts the suggestion (blink.cmp's Tab fallback chains to this global
-- mapping), <C-g> is a backup accept.
vim.keymap.set("i", "<Tab>", function()
    return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true, desc = "Windsurf: Accept suggestion" })

vim.keymap.set("i", "<C-g>", function()
    return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true, desc = "Windsurf: Accept suggestion" })

vim.keymap.set("i", "<C-;>", function()
    return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true, desc = "Windsurf: Next suggestion" })

vim.keymap.set("i", "<C-,>", function()
    return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true, desc = "Windsurf: Prev suggestion" })

vim.keymap.set("i", "<C-x>", function()
    return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true, desc = "Windsurf: Clear suggestion" })
