local cmp = require("cmp")
local lspkind = require("lspkind")

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

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
    { name = "tmux" },
    { name = "npm", keyword_length = 4 },
  }, {
    { name = "buffer" },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own.
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
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = "[BUFFER]",
        calc = "[CALC]",
        cmdline = "[COMMAND]",
        cmp_git = "[GIT]",
        cmp_tabnine = "[TABNINE]",
        emoji = "[EMOJI]",
        gh_issues = "[GITHUB ISSUE]",
        look = "[LOOK]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        orgmode = "[ORGMODE]",
        path = "[PATH]",
        spell = "[SPELL]",
        treesitter = "[TREESITTER]",
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
