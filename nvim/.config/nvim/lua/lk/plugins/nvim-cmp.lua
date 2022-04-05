local cmp_ok, cmp = lk.safe_require("cmp")
if not cmp_ok then
  return
end

local lspkind_ok, lspkind = lk.safe_require("lspkind")
if not lspkind_ok then
  return
end

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

----------------------------------------------------------------------
-- NOTE: lspkind setup {{{
----------------------------------------------------------------------
require("lspkind").init({
  preset = "codicons",
  mode = "text_symbol",
  symbol_map = lk.style.icons.kind,
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: cmp setup {{{
----------------------------------------------------------------------
cmp.setup({
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "cmp_tabnine" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
    { name = "emoji" },
  }, {
    { name = "buffer" },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = "[BUF]",
        cmdline = "[CMD]",
        cmp_git = "[GIT]",
        cmp_tabnine = "[TBN]",
        copilot = "[COP]",
        emoji = "[EMJ]",
        luasnip = "[SNIP]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        path = "[PATH]",
        spell = "[SPELL]",
        treesitter = "[TREE]",
      },
    }),
  },
  documentation = { border = "rounded" },
  experimental = { native_menu = false, ghost_text = false },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: cmp cmdline setup {{{
----------------------------------------------------------------------
local search_sources = {
  sources = cmp.config.sources({
    {
      name = "buffer",
      options = { keyword_pattern = [=[[^[:blank:]].*]=] },
    },
  }),
}

cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
  }, {
    { name = "buffer" },
  }),
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
