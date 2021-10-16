local cmp = require 'cmp'

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

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
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
    ['<C-Space>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if vim.fn['UltiSnips#CanExpandSnippet']() == 1 then
          return press('<C-R>=UltiSnips#ExpandSnippet()<CR>')
        end

        cmp.select_next_item()
      elseif has_any_words_before() then
        press('<Space>')
      else
        fallback()
      end
    end, { 'i', 's' }),
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
    { name = 'ultisnips' },
    { name = 'cmp_tabnine' },
    { name = 'spell' },
    { name = 'treesitter' },
    { name = 'emoji' },
    {
      name = 'look',
      keyword_length = 2,
      opts = { convert_case = true, loud = true },
    },
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
        ultisnips = '[Snippet]',
        nvim_lua = '[Lua]',
        latex_symbols = '[Latex]',
      })[entry.source.name]
      return vim_item
    end,
  },
}

require('nvim-autopairs.completion.cmp').setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
  auto_select = true, -- automatically select the first item
  insert = false, -- use insert confirm behavior instead of replace
  map_char = { -- modifies the function or method delimiter by filetypes
    all = '(',
    tex = '{',
  },
})
