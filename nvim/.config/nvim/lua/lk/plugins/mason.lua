local M = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
}

function M.config()
    local ok, mason = lk.require("mason")
    if not ok then
        return
    end

    mason.setup({
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
            "sumneko_lua",
            "tsserver",
            "vimls",
        },
    })
end

return M
