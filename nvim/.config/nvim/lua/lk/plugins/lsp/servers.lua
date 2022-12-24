local clangd = function()
    return {
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
    }
end

local sumneko_lua = function()
    return {
        settings = {
            Lua = {
                format = { enable = false },
                diagnostics = {
                    globals = { "vim", "describe", "it", "before_each", "after_each" },
                },
                completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    -- library = vim.api.nvim_get_runtime_file("", true),
                    -- maxPreload = 2000,
                    -- preloadFileSize = 5000,
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    }
end

local servers = {
    bashls = true,
    clangd = clangd,
    cssls = true,
    dockerls = true,
    emmet_ls = true,
    gopls = true,
    jsonls = true,
    pyright = true,
    remark_ls = true,
    rust_analyzer = true,
    sumneko_lua = sumneko_lua,
    tailwindcss = true,
    tsserver = true,
    vimls = true,
}

return servers
