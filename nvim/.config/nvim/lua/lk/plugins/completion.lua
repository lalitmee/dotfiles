local cmp = require('cmp')
local lspkind = require('lspkind')

local has_any_words_before = function()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
             vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
                 :match('%s') == nil
end

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                        'n', true)
end

-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

-- cmp.setup {
--   mapping = {
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Insert,
--       select = true,
--     },
--
--   formatting = {
--     format = function(entry, vim_item)
--       vim_item.kind = string.format('%s %s',
--                                     lspkind.presets.default[vim_item.kind],
--                                     vim_item.kind)
--       vim_item.menu = ({
--         nvim_lsp = 'ﲳ',
--         nvim_lua = '',
--         treesitter = '',
--         path = 'ﱮ',
--         buffer = '﬘',
--         zsh = '',
--         vsnip = '',
--         spell = '暈',
--       })[entry.source.name]
--
--       return vim_item
--     end,
--   },
-- }

lspkind.init()

cmp.setup {
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

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

    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.complete_info()['selected'] == -1 and
          vim.fn['UltiSnips#CanExpandSnippet']() == 1 then
        press('<C-R>=UltiSnips#ExpandSnippet()<CR>')
      elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
        press('<ESC>:call UltiSnips#JumpForwards()<CR>')
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_any_words_before() then
        press('<Tab>')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
        press('<ESC>:call UltiSnips#JumpBackwards()<CR>')
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },

  -- Youtube:
  --    the order of your sources matter (by default). That gives them priority
  --    you can configure:
  --        keyword_length
  --        priority
  --        max_item_count
  --        (more?)

  sources = {
    { name = 'cmp_tabnine' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'treesitter', keyword_length = 3 },
    { name = 'path' },
    { name = 'ultisnips' },
    { name = 'buffer', keyword_length = 4 },
    { name = 'spell' },
    { name = 'emoji' },
    {
      name = 'look',
      keyword_length = 2,
      opts = { convert_case = true, loud = true },
    },
  },

  -- Youtube: mention that you need a separate snippets plugin
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },

  formatting = {
    -- Youtube: How to set up nice formatting for your sources.
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        cmp_tabnine = '[TN]',
        buffer = '[buf]',
        gh_issues = '[issues]',
        look = '[look]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[api]',
        path = '[path]',
        spell = '[spell]',
        ultisnips = '[snip]',
      },
    },
  },

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = true,
  },
}

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

-- -- nvim-cmp highlight groups.
-- local Group = require('colorbuddy.group').Group
-- local g = require('colorbuddy.group').groups
-- local s = require('colorbuddy.style').styles
--
-- Group.new('CmpItemAbbr', g.Comment)
-- Group.new('CmpItemAbbrDeprecated', g.Error)
-- Group.new('CmpItemAbbrMatchFuzzy', g.CmpItemAbbr.fg:dark(), nil, s.italic)
-- Group.new('CmpItemKind', g.Special)
-- Group.new('CmpItemMenu', g.NonText)
