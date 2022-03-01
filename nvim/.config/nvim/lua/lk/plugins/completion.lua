local cmp = require("cmp")
local lspkind = require("lspkind")

local has_any_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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

    -- ['<c-space>'] = cmp.mapping.complete(),

    -- ['<C-Space>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     if vim.fn['UltiSnips#CanExpandSnippet']() == 1 then
    --       return press('<C-R>=UltiSnips#ExpandSnippet()<CR>')
    --     end
    --
    --     cmp.select_next_item()
    --   elseif has_any_words_before() then
    --     press('<Space>')
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),

    ["<C-n>"] = cmp.mapping(function(fallback)
      if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
        press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
      elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        press("<ESC>:call UltiSnips#JumpForwards()<CR>")
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_any_words_before() then
        press("<Tab>")
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
        press("<ESC>:call UltiSnips#JumpBackwards()<CR>")
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  -- Youtube:
  --    the order of your sources matter (by default). That gives them priority
  --    you can configure:
  --        keyword_length
  --        priority
  --        max_item_count
  --        (more?)
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "cmp_tabnine" },
    { name = "nvim_lua" },
    { name = "ultisnips" },
    { name = "treesitter", keyword_length = 3 },
    { name = "orgmode" },
    { name = "path" },
    { name = "spell" },
    { name = "cmp_git" },
    { name = "emoji" },
    { name = "nvim_lsp_signature_help" },
    { name = "tmux" },
    { name = "npm", keyword_length = 4 },
    { name = "dictionary", keyword_length = 2 },
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
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = "buffer" },
  }),
}

cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 2 } }),
})

-- require('nvim-autopairs.completion.cmp').setup({
--   map_cr = true, --  map <CR> on insert mode
--   map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
--   auto_select = true, -- automatically select the first item
--   insert = false, -- use insert confirm behavior instead of replace
--   map_char = { -- modifies the function or method delimiter by filetypes
--     all = '(',
--     tex = '{',
--   },
-- })
