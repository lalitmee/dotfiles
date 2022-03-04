local cmp = require("cmp")
local lspkind = require("lspkind")

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

-- Don't show the dumb matching stuff.
vim.cmd([[set shortmess+=c]])

require("lspkind").init({
  preset = "codicons",
  symbol_map = {
    Class = "   ",
    Color = "   ",
    Constant = "   ",
    Constructor = "   ",
    Default = "   ",
    Enum = " 了 ",
    EnumMember = "   ",
    Event = "   ",
    Field = "   ",
    File = "   ",
    Folder = "   ",
    Function = "   ",
    Interface = " ﰮ  ",
    Keyword = "   ",
    Method = " ƒ  ",
    Module = "   ",
    Operator = " ○  ",
    Property = "   ",
    Reference = "   ",
    Snippet = " ﬌  ",
    Struct = "   ",
    Text = "   ",
    TypeParameter = " ⅀  ",
    Unit = "   ",
    Value = "   ",
    Variable = "   ",
  },
})

cmp.setup({
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<C-n>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          press("<Down>")
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
    }),
    ["<C-p>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          press("<Up>")
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
    }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "cmp_tabnine" },
    { name = "copilot" },
    { name = "nvim_lua" },
    { name = "ultisnips" },
    { name = "treesitter", keyword_length = 3 },
    { name = "orgmode" },
    { name = "path" },
    { name = "spell" },
    { name = "emoji" },
    { name = "nvim_lsp_signature_help" },
    { name = "tmux" },
    { name = "npm", keyword_length = 4 },
  }, {
    { name = "buffer" },
  }),
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = "[BUF]",
        calc = "[CALC]",
        cmdline = "[COM]",
        cmp_git = "[GIT]",
        cmp_tabnine = "[TN]",
        emoji = "[EMOJ]",
        gh_issues = "[GH]",
        look = "[LOOK]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        orgmode = "[ORG]",
        path = "[PATH]",
        spell = "[SPELL]",
        treesitter = "[TS]",
        ultisnips = "[SNIP]",
      },
    }),
  },
  documentation = { border = "rounded" },
  experimental = { native_menu = false, ghost_text = false },
})

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
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 2 } }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
  }, {
    { name = "buffer" },
  }),
})
