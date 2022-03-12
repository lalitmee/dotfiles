return function()
  local lua_dev = require("lua-dev")
  return lua_dev.setup({
    lspconfig = {
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              "vim",
              "describe",
              "it",
              "before_each",
              "after_each",
              "pending",
              "teardown",
              "packer_plugins",
            },
          },
          completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),

            maxPreload = 2000,
            preloadFileSize = 50000,
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    },
  })
end
