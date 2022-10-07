local ok, mason = lk.require("mason")
if not ok then
    return
end

local nonicon_extension = require("nvim-nonicons.extentions.mason")

mason.setup({
    ui = {
        border = "rounded",
        icons = nonicon_extension.icons,
    },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "ccls",
        "css_lsp",
        "clangd",
        "dockerls",
        "emmet_ls",
        "eslint",
        "gopls",
        "jsonls",
        "pyright",
        "rust_analyzer",
        "sumneko_lua",
        "tsserver",
        "vimls",
    },
})
