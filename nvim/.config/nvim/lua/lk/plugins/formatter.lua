local ok, formatter = lk.safe_require("formatter")
if not ok then
  return
end

local util = require("formatter.util")

----------------------------------------------------------------------
-- NOTE: prettier {{{
----------------------------------------------------------------------
local prettier = function()
  return {
    exe = "prettier",
    args = {
      "--find-config-path",
      "--stdin-filepath",
      string.format('"%s"', util.escape_path(util.get_current_buffer_file_path())),
      "--config-precedencei:file-override",
    },
    stdin = true,
  }
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: rustfmt {{{
----------------------------------------------------------------------
local rustfmt = function()
  return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true }
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: styluafmt {{{
----------------------------------------------------------------------
local styluafmt = function()
  return {
    exe = "stylua",
    args = {
      "--config-path ~/.config/stylua/stylua.toml",
      "-",
    },
    stdin = true,
  }
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: formatter setup {{{
----------------------------------------------------------------------
formatter.setup({
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
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: formatter autocmd {{{
----------------------------------------------------------------------
lk.augroup("formatter_au", {
  {
    event = "BufWritePost",
    pattern = {
      "*.js",
      "*.jsx",
      "*.mjs",
      "*.ts",
      "*.tsx",
      "*.css",
      "*.less",
      "*.scss",
      "*.json",
      "*.graphql",
      "*.md",
      "*.vue",
      "*.yaml",
      "*.html",
      "*.rs",
      "*.lua",
    },
    command = function()
      vim.cmd([[FormatWrite]])
    end,
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
