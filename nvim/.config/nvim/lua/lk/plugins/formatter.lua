local prettier = function()
  return {
    exe = "prettier",
    args = {
      "--find-config-path",
      "--stdin-filepath",
      vim.api.nvim_buf_get_name(0),
      "--config-precedencei:file-override",
    },
    stdin = true,
  }
end

local rustfmt = function()
  return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true }
end

local styluafmt = function()
  return {
    exe = "stylua",
    args = {
      "--config-path " .. os.getenv("XDG_CONFIG_HOME") .. "/stylua/stylua.toml",
      "-",
    },
    stdin = true,
  }
end

require("formatter").setup({
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
    lua = { styluafmt },
  },
})

vim.api.nvim_exec(
  [[
      augroup Format
          autocmd!
          autocmd BufWritePost *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html,*.rs, *.lua FormatWrite
      augroup END
  ]],
  true
)

-- lk.augroup("FormatterAutoCmd", {
--   {
--     event = "BufWritePre",
--     buffer = 0,
--     pattern = {
--       "*.js",
--       "*.jsx",
--       "*.mjs",
--       "*.ts",
--       "*.tsx",
--       "*.css",
--       "*.less",
--       "*.scss",
--       "*.json",
--       "*.graphql",
--       "*.md",
--       "*.vue",
--       "*.yaml",
--       "*.html",
--       "*.rs",
--       "*.lua",
--     },
--     command = function()
--       vim.cmd [[FormatWrite]]
--     end,
--   },
-- })
