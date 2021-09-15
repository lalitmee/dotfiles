local cmp = require 'cmp'

-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ['<C-S-Space>'] = cmp.mapping.complete(),

    -- These mappings are useless. I already use C-n and C-p correctly.
    -- This simply overrides them and makes them do bad things in other buffers.
    -- ["<C-p>"] = cmp.mapping.select_prev_item(),
    -- ["<C-n>"] = cmp.mapping.select_next_item(),
  },

  sources = {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },

  -- formatting = {
  --   format = function(entry, vim_item)
  --     vim_item.kind = lspkind.presets.default[vim_item.kind]
  --     return vim_item
  --   end,
  -- },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind =
          require('lspkind').presets.default[vim_item.kind] .. ' ' ..
              vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        nvim_lua = '[Lua]',
        latex_symbols = '[Latex]',
      })[entry.source.name]
      return vim_item
    end,
  },
}
