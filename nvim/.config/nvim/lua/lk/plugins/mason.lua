local ok, mason = lk.safe_require("mason")
if not ok then
  return
end

mason.setup({
  ui = {
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
    "ccls",
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
