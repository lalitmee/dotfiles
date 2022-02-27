vim.cmd([[ autocmd FileType gitcommit setlocal sw=2 sts=2 ts=2 et ]])

vim.cmd([[ set formatoptions-=o ]])

vim.g.vim_jsx_pretty_colorful_config = 1

-- Setup cmp source buffer configuration
local cmp = require("cmp")
cmp.setup.buffer({
  sources = {
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "ultisnips" },
    {
      name = "buffer",
      opts = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = "path" },
  },
})
