local M = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "VimEnter" },
}

M.config = function()
    require("mason").setup({
        ui = {
            border = "rounded",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })

    require("mason-lspconfig").setup({
        ensure_installed = {
            "bashls",
            "cssls",
            "clangd",
            "dockerls",
            "emmet_ls",
            "gopls",
            "jsonls",
            "pyright",
            "rust_analyzer",
            "lua_ls",
            "tsserver",
            "vimls",
        },
    })
end

return M
