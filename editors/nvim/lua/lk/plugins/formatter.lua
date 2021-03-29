-- I will use this until formatting from LSP is stable.
local prettier = function()
  return {
    exe = 'prettier',
    args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
    stdin = true
  }
end

local rustfmt = function()
  return { exe = 'rustfmt', args = { '--emit=stdout' }, stdin = true }
end

local luafmt = function()
  return {
    exe = 'lua-format',
    args = {
      '--align-args',
      '--align-parameter',
      '--align-table-field',
      '--break-after-functioncall-lp',
      '--break-after-functiondef-lp',
      '--break-after-table-lb',
      '--break-before-functioncall-rp',
      '--break-before-functiondef-rp',
      '--break-before-table-rb ',
      '--chop-down-kv-table',
      '--chop-down-parameter',
      '--chop-down-table',
      '--column-limit=120',
      '--column-table-limit=80',
      '--double-quote-to-single-quote ',
      '--indent-width=2',
      '--line-breaks-after-function-body=1',
      '--no-keep-simple-control-block-one-line',
      '--no-keep-simple-function-one-line',
      '--no-single-quote-to-double-quote',
      '--no-use-tab',
      '--spaces-before-call=1',
      '--spaces-inside-table-braces',
      '--tab-width=1'
    },
    stdin = true
  }
end

require('formatter').setup(
    {
      logging = false,
      filetype = {
        javascript = { prettier },
        javascriptreact = { prettier },
        typescript = { prettier },
        typescriptreact = { prettier },
        css = { prettier },
        less = { prettier },
        sass = { prettier },
        scss = { prettier },
        json = { prettier },
        graphql = { prettier },
        markdown = { prettier },
        vue = { prettier },
        yaml = { prettier },
        html = { prettier },
        rust = { rustfmt },
        lua = { luafmt }
      }
    }
)

vim.api.nvim_exec(
    [[
      augroup Format
          autocmd!
          autocmd BufWritePost * FormatWrite
      augroup END
  ]], true
)
