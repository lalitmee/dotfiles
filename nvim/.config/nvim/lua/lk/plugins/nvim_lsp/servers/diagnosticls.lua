-- diagnostic settings
return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "css",
    "scss",
    "markdown",
    "pandoc",
    "sh",
    "python",
    "email",
    "prose",
    "vim",
  },
  init_options = {
    linters = {
      eslint = {
        command = "eslint_d",
        rootPatterns = { ".git", "package.json" },
        debounce = 100,
        args = { "--stdin", "--stdin-filename", "%filepath", "json" },
        sourceName = "eslint",
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "[eslint] ${message} [${ruleId}]",
          security = "severity",
        },
        securities = { [2] = "error", [1] = "warning" },
      },
      markdownlint = {
        command = "markdownlint",
        rootPatterns = { ".git" },
        isStderr = true,
        debounce = 100,
        args = { "--stdin" },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "markdownlint",
        securities = { undefined = "hint" },
        formatLines = 1,
        formatPattern = {
          "^.*:(\\d+)\\s+(.*)$",
          { line = 1, column = -1, message = 2 },
        },
      },
      shellcheck = {
        command = "shellcheck", -- brew install shellcheck
        debounce = 100,
        args = { "--format=gcc", "-" },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "shellcheck",
        formatLines = 1,
        formatPattern = {
          "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
          { line = 1, column = 2, message = 4, security = 3 },
        },
        securities = { error = "error", warning = "warning", note = "info" },
      },
      languagetool = {
        command = "languagetool", -- brew install languagetool
        debounce = 200,
        args = { "-" },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "languagetool",
        formatLines = 2,
        formatPattern = {
          "^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$",
          { line = 1, column = 2, message = { 4, 3 } },
        },
      },
      flake8 = {
        command = "flake8", -- pip install flake8
        debounce = 100,
        args = { "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s", "-" },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "flake8",
        formatLines = 1,
        formatPattern = {
          "(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
          { line = 1, column = 2, security = 3, message = 4 },
        },
        securities = {
          W = "warning",
          E = "error",
          F = "error",
          C = "error",
          N = "error",
        },
      },
      vint = {
        command = "vint",
        debounce = 100,
        args = { "--enable-neovim", "-" },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "vint",
        formatLines = 1,
        formatPattern = {
          "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
          { line = 1, column = 2, message = 3 },
        },
      },
      ["write-good"] = {
        command = "write-good",
        debounce = 100,
        args = { "--text=%text" },
        offsetLine = 0,
        offsetColumn = 1,
        sourceName = "write-good",
        formatLines = 1,
        formatPattern = {
          "(.*)\\s+on\\s+line\\s+(\\d+)\\s+at\\s+column\\s+(\\d+)\\s*$",
          { line = 2, column = 3, message = 1 },
        },
      },
    },
    filetypes = {
      javascript = "eslint",
      javascriptreact = "eslint",
      typescript = "eslint",
      typescriptreact = "eslint",
      markdown = "markdownlint",
      pandoc = "markdownlint",
      sh = "shellcheck",
      prose = "languagetool",
      python = "flake8",
      vim = "vint",
    },
    -- formatters = {
    --   prettierEslint = {
    --     command = 'prettier-eslint',
    --     args = { '--stdin' },
    --     rootPatterns = { '.git' }
    --   },
    --   prettier = {
    --     command = 'prettier',
    --     args = { '--stdin-filepath', '%filename' }
    --   }
    -- },
    -- formatFiletypes = {
    --   css = 'prettier',
    --   javascript = 'prettierEslint',
    --   javascriptreact = 'prettierEslint',
    --   json = 'prettier',
    --   scss = 'prettier',
    --   typescript = 'prettierEslint',
    --   typescriptreact = 'prettierEslint',
    --   lua = 'lua-format'
    -- }
  },
}
