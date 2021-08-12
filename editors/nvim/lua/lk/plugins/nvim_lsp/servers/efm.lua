local prettier = { formatCommand = 'prettier' }

local eslint = {
  lintCommand = 'eslint_d --stdin --stdin-filename ${INPUT} -f unix',
  lintStdin = true,
  lintIgnoreExitCode = true,
}

local shellcheck = {
  lintCommand = 'shellcheck -f gcc -x -',
  lintStdin = true,
  lintFormats = {
    '%f:%l:%c: %trror: %m',
    '%f:%l:%c: %tarning: %m',
    '%f:%l:%c: %tote: %m',
  },
}

local shfmt = {
  -- brew install shfmt
  formatCommand = 'shfmt -ci -s -bn',
  formatStdin = true,
}

local luaformat = {
  -- luarocks install --server=https://luarocks.org/dev luaformatter
  formatCommand = 'lua-format -i ${--tab-width:tabSize} ${--indent-width:tabSize} --spaces-inside-table-braces --single-quote-to-double-quote',
  formatStdin = true,
}

local vint = {
  -- brew install vint --HEAD
  lintCommand = 'vint --enable-neovim -',
  -- stdin needs vint >= 0.4
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
}

local checkmake = { lintCommand = 'checkmake', lintStdin = true }

-- brew install yamllint
local yamllint = { lintCommand = 'yamllint -f parsable -', lintStdin = true }

local flake8 = {
  lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
}

local phpstan = {
  lintCommand = './vendor/bin/phpstan analyze --error-format raw --no-progress',
}

local bladeFormatter = {
  formatCommand = 'blade-formatter --stdin',
  formatStdin = true,
}

local rustywind = {
  -- yarn global add rustywind
  formatCommand = 'rustywind --stdin',
  formatStdin = true,
}

local languages = {
  blade = { bladeFormatter },
  graphql = { prettier },
  html = { prettier },
  javascript = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  json = { prettier },
  less = { prettier },
  lua = { luaformat },
  make = { checkmake },
  css = { prettier },
  markdown = { prettier },
  php = { phpstan },
  python = { flake8 },
  sass = { prettier },
  scss = { prettier },
  sh = { shellcheck, shfmt },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  vim = { vint },
  yaml = { yamllint },
}

local tailwind_fts = require'lspinstall/servers'.tailwindcss.default_config
                         .filetypes
for _, filetype in ipairs(tailwind_fts) do
  if languages[filetype] then
    table.insert(languages[filetype], rustywind)
  else
    languages[filetype] = { rustywind }
  end
end

return {
  filetypes = vim.tbl_keys(languages),
  init_options = { documentFormatting = false },
  settings = { rootMarkers = { '.git/' }, languages = languages },
}
