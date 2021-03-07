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
      '--no-keep-simple-control-block-one-line',
      '--break-after-functioncall-lp',
      '--break-before-functioncall-rp',
      '--column-limit=80',
      '--double-quote-to-single-quote ',
      '--indent-width=2',
      '--no-single-quote-to-double-quote',
      '--no-use-tab',
      '--spaces-inside-table-braces',
      '--tab-width=2',
      '--chop-down-parameter',
      ' --no-keep-simple-function-one-line',
      '--break-after-functiondef-lp',
      '--break-before-functiondef-rp',
      '--align-table-field',
      '--break-after-table-lb',
      '--break-before-table-rb ',
      '--chop-down-table',
      '--chop-down-kv-table'
      -- '--spaces-inside-functioncall-parens'
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

-- vim.api.nvim_command [[augroup Format]]
-- vim.api.nvim_command [[autocmd! * <buffer>]]
-- vim.api.nvim_command [[autocmd BufWritePost <buffer> FormatWrite]]
-- vim.api.nvim_command [[augroup END]]

vim.api.nvim_exec(
    [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html,*.rs,*.lua FormatWrite
augroup END
]], true
)
