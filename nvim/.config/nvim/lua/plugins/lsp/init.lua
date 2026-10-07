local lsp_utils = require("plugins.lsp.utils")
local wk = require("which-key")

require("lazydev").setup({
    library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
})

require("mason").setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls", "clangd", "cssls", "dockerls", "emmet_ls", "gopls", "jsonls",
        "lua_ls", "marksman", "pyright", "rust_analyzer", "tailwindcss", "taplo", "vimls",
    },
    automatic_enable = false,
})

wk.add({ { "<leader>l", group = "lsp", mode = { "n", "v" } } })
local lsp_maps = {
    { "<leader>la", vim.lsp.buf.code_action, "Code Action" },
    { "<leader>ld", vim.lsp.buf.definition, "Definition" },
    { "<leader>lD", vim.lsp.buf.declaration, "Declaration" },
    { "<leader>lh", vim.lsp.buf.hover, "Hover Doc" },
    { "<leader>li", "<cmd>LspInfo<CR>", "Lsp Info" },
    { "<leader>lI", vim.lsp.buf.implementation, "Implementation" },
    { "<leader>ll", function() vim.cmd("edit " .. vim.lsp.get_log_path()) end, "Lsp Log" },
    { "<leader>lm", "<cmd>Mason<CR>", "Lsp Installer Info" },
    { "<leader>lr", vim.lsp.buf.rename, "Rename" },
    { "<leader>lR", vim.lsp.buf.references, "References" },
    { "<leader>ls", vim.lsp.buf.document_symbol, "Document Symbols" },
    { "<leader>lt", vim.lsp.buf.type_definition, "Type Definition" },
    { "<leader>lw", vim.lsp.buf.workspace_symbol, "Workspace Symbols" },
}
for _, mapping in ipairs(lsp_maps) do
    vim.keymap.set("n", mapping[1], mapping[2], { desc = mapping[3] })
end

require("plugins.lsp.keys")
require("plugins.lsp.handlers")
require("plugins.lsp.diagnostics")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))
capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
capabilities.textDocument.codeLens = { dynamicRegistration = false }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

if vim.lsp.inline_completion then
    vim.lsp.inline_completion.enable(true)
end

vim.lsp.config("*", { root_markers = { ".git" } })
vim.lsp.config("tsgo", {
    cmd = { "tsgo", "--lsp", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
})

local base_config = { on_attach = lsp_utils.on_attach, capabilities = capabilities }
for server_name, server_config in pairs(require("plugins.lsp.servers")) do
    if server_config ~= false then
        local config = type(server_config) == "table" and vim.tbl_deep_extend("force", base_config, server_config)
            or base_config
        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
    end
end

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
local slow_format_filetypes = {}
for _, filetype in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact", "liquid" }) do
    slow_format_filetypes[filetype] = true
end

require("conform").setup({
    formatters = {
        curlylint = { command = "curlylint", args = { "-f", "stylish" } },
        shfmt = { command = "shfmt", prepend_args = { "-i", "4", "-ci", "-sr" } },
        mdformat = { command = "mdformat", args = { "--number", "false" } },
    },
    formatters_by_ft = {
        ["*"] = { "trim_newlines", "trim_whitespace" },
        css = { "prettierd" }, dart = { "dart_format" }, go = { "gofmt", "goimports", "golines" },
        html = { "prettierd" }, javascript = { "prettierd" }, javascriptreact = { "prettierd" },
        json = { "prettierd" }, liquid = { "curlylint" }, lua = { "stylua" },
        markdown = { "markdownlint", "mdformat" }, python = { "black" }, rust = { "rustfmt" },
        scss = { "prettierd" }, sh = { "shfmt" }, svg = { "prettierd" }, toml = { "taplo" },
        typescript = { "prettierd" }, typescriptreact = { "prettierd" }, yaml = { "yamlfmt" },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
        end
        local function on_format(err)
            if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
        end
        return { timeout_ms = 200, lsp_fallback = true }, on_format
    end,
    format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return { lsp_fallback = true }
        end
    end,
})

for _, mapping in ipairs({
    { "<leader>bf", "<cmd>Format<cr>", "Format" },
    { "<leader>be", "<cmd>FormatEnable<cr>", "Format Enable" },
    { "<leader>bk", "<cmd>FormatDisable<cr>", "Format Disable" },
}) do
    vim.keymap.set("n", mapping[1], mapping[2], { desc = mapping[3], silent = true })
end

lk.command("Format", function(args)
    local range
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
end, { desc = "Disable autoformat-on-save", bang = true })
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            lsp_utils.on_attach(client, bufnr)
            lk.nnoremap("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end,
                { buffer = bufnr, desc = "Rust Hover Actions" })
            lk.nnoremap("<leader>la", function() vim.cmd.RustLsp("codeAction") end,
                { buffer = bufnr, desc = "Rust Code Action" })
        end,
        default_settings = {
            ["rust-analyzer"] = {
                inlayHints = { locationLinks = true },
                diagnostics = { enable = true, experimental = { enable = true } },
                hover = { actions = { enable = true } }, procMacro = { enable = true },
                cargo = { allFeatures = true }, checkOnSave = true,
                check = { command = "clippy", extraArgs = { "--no-deps" } },
            },
        },
    },
}

if vim.env.HOME == "/home/lalitmee" then
    local flutter_capabilities = vim.lsp.protocol.make_client_capabilities()
    flutter_capabilities.textDocument.completion.completionItem.snippetSupport = true
    local ok_blink, blink = pcall(require, "blink.cmp")
    if ok_blink then flutter_capabilities = blink.get_lsp_capabilities(flutter_capabilities) end
    require("flutter-tools").setup({
        ui = { border = "rounded", notification_style = "native" },
        decorations = { statusline = { app_version = true, device = true } },
        widget_guides = { enabled = true },
        closing_tags = { highlight = "Comment", prefix = " // ", enabled = true },
        dev_log = { enabled = true, notify_errors = false, open_cmd = "botright 15split", focus_on_open = false },
        outline = { open_cmd = "botright 40vsplit", auto_open = false },
        lsp = {
            capabilities = flutter_capabilities,
            on_attach = function(client, bufnr)
                lsp_utils.on_attach(client, bufnr)
                vim.lsp.document_color.enable(true, { bufnr = bufnr }, { style = "■" })
                wk.add({
                    { "<localleader>f", group = "flutter", buffer = bufnr },
                    { "<localleader>fr", "<cmd>FlutterRun<cr>", desc = "Run App", buffer = bufnr },
                    { "<localleader>fq", "<cmd>FlutterQuit<cr>", desc = "Quit App", buffer = bufnr },
                    { "<localleader>fR", "<cmd>FlutterRestart<cr>", desc = "Hot Restart", buffer = bufnr },
                    { "<localleader>fl", "<cmd>FlutterReload<cr>", desc = "Hot Reload", buffer = bufnr },
                    { "<localleader>fd", "<cmd>FlutterDevices<cr>", desc = "Select Device", buffer = bufnr },
                    { "<localleader>fe", "<cmd>FlutterEmulators<cr>", desc = "Select Emulator", buffer = bufnr },
                    { "<localleader>fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Toggle Outline", buffer = bufnr },
                    { "<localleader>fL", "<cmd>FlutterDevLogToggle<cr>", desc = "Toggle Dev Log", buffer = bufnr },
                    { "<localleader>fc", "<cmd>FlutterLogClear<cr>", desc = "Clear Dev Log", buffer = bufnr },
                    { "<localleader>fv", "<cmd>FlutterVisualDebug<cr>", desc = "Toggle Visual Debug", buffer = bufnr },
                })
            end,
            settings = {
                showTodos = true, completeFunctionCalls = true, renameFilesWithClasses = "prompt",
                enableSnippets = true, updateImportsOnRename = true,
            },
        },
    })
end
