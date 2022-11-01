local fn = vim.fn
local icons = lk.style.icons.lsp
local lsp_utils = require("lk.plugins.lsp.utils")

require("lk.highlights").plugin("lspconfig", {
    { LspInfoBorder = { link = "FloatBorder" } },
})
require("lspconfig.ui.windows").default_options.border = lk.style.border.rounded

----------------------------------------------------------------------
-- NOTE: automatic setting up commands and handlers {{{
----------------------------------------------------------------------
require("lk.plugins.lsp.commands")
require("lk.plugins.lsp.handlers")
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: diagnostic signs {{{
----------------------------------------------------------------------
local function sign(opts)
    fn.sign_define(opts.highlight, {
        text = opts.icon,
        texthl = opts.highlight,
        numhl = opts.highlight .. "Nr",
        culhl = opts.highlight .. "CursorNr",
        linehl = opts.highlight .. "Line",
    })
end

sign({ highlight = "DiagnosticSignError", icon = icons.error })
sign({ highlight = "DiagnosticSignWarn", icon = icons.warn })
sign({ highlight = "DiagnosticSignInfo", icon = icons.info })
sign({ highlight = "DiagnosticSignHint", icon = icons.hint })
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: capabilities {{{
----------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: servers {{{
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: neodev setup {{{
--------------------------------------------------------------------------------
local ok, neodev = lk.require("neodev")
if not ok then
    vim.notify("Something wrong with [neodev]", 2, { title = "[neodev]" })
    return
end
neodev.setup({
    library = { plugins = { "plenary.nvim" } },
})
-- }}}
--------------------------------------------------------------------------------

local servers = {
    bashls = true,
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        -- Required for lsp-status
        init_options = {
            clangdFileStatus = true,
        },
    },
    cssls = true,
    dockerls = true,
    emmet_ls = true,
    gopls = true,
    jsonls = true,
    pyright = true,
    remark_ls = true,
    rust_analyzer = true,
    sumneko_lua = function()
        local settings = {
            settings = {
                Lua = {
                    format = { enable = false },
                    diagnostics = {
                        globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
                    },
                    completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
                    -- workspace = {
                    --   -- Make the server aware of Neovim runtime files
                    --   library = vim.api.nvim_get_runtime_file("", true),
                    --   maxPreload = 2000,
                    --   preloadFileSize = 5000,
                    --   checkThirdParty = false,
                    -- },
                    telemetry = { enable = false },
                },
            },
        }
        return settings
    end,
    tailwindcss = true,
    tsserver = true,
    vimls = true,
}
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: get servers config {{{
----------------------------------------------------------------------
local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local function get_server_config(name)
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = lk.require("cmp_nvim_lsp")
    if not cmp_nvim_lsp_ok then
        return nil
    end
    local conf = servers[name]
    local conf_type = type(conf)
    local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
    config.flags = { debounce_text_changes = 500 }
    config.capabilities = config.capabilities or capabilities or vim.lsp.protocol.make_client_capabilities()
    cmp_nvim_lsp.default_capabilities(config.capabilities)
    config = vim.tbl_deep_extend("force", {
        on_init = custom_init,
        on_attach = lsp_utils.on_attach,
        capabilities = config.capabilities,
        flags = {
            debounce_text_changes = nil,
        },
    }, config)
    return config
end
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: setting servers {{{
----------------------------------------------------------------------
local lsp_ok, lsp = lk.require("lspconfig")
if not lsp_ok then
    return
end
for name, config in pairs(servers) do
    if config then
        lsp[name].setup(get_server_config(name))
    end
end

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
