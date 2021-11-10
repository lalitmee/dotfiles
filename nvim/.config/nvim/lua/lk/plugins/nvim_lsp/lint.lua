local lint = require('lint')

lint.linters_by_ft = {
  bash = { 'shellcheck' },
  css = { 'styleint' },
  html = { 'tidy' },
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  lua = { 'luacheck' },
  python = { 'flake8' },
  scss = { 'styleint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  vim = { 'vint' },
}

vim.cmd [[autocmd TextChanged *.py, *.js, *.ts, *.jsx, *.tsx, *.vim, *.css, *.scss, *.html lua require('lint').try_lint()]]
