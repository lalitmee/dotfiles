local ok, formatter = lk.safe_require("formatter")
if not ok then
  return
end

local util = require("formatter.util")

----------------------------------------------------------------------
-- NOTE: clang-format {{{
----------------------------------------------------------------------
local clang_format = require("formatter.filetypes.cpp").clangformat
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: prettier {{{
----------------------------------------------------------------------
local prettier = function()
  return {
    exe = "prettierd",
    args = {
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end
-- local prettier = function()
--   return {
--     exe = "prettierd",
--     args = {
--       -- "--find-config-path",
--       -- "--stdin-filepath",
--       string.format('"%s"', util.escape_path(util.get_current_buffer_file_path())),
--       -- util.get_current_buffer_file_path(),
--       -- "--config-precedencei:file-override",
--     },
--     stdin = true,
--   }
-- end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: rustfmt {{{
----------------------------------------------------------------------
local rustfmt = require("formatter.filetypes.rust")
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
    c = { clang_format },
    cpp = { clang_format },
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
    event = { "BufWritePost" },
    pattern = {
      "*.c",
      "*.cpp",
      "*.css",
      "*.graphql",
      "*.html",
      "*.js",
      "*.json",
      "*.jsx",
      "*.less",
      "*.lua",
      "*.md",
      "*.mjs",
      "*.rs",
      "*.scss",
      "*.ts",
      "*.tsx",
      "*.vue",
      "*.yaml",
    },
    command = function()
      vim.cmd([[FormatWrite]])
    end,
  },
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
