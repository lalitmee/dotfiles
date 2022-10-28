local nls = require("null-ls")
-- local U = require("lk.plugins.lsp.utils")

local fmt = nls.builtins.formatting
local dgn = nls.builtins.diagnostics
local cda = nls.builtins.code_actions

-- Configuring null-ls
nls.setup({
    debug = true,
    sources = {
        ----------------
        -- FORMATTING --
        ----------------
        fmt.trim_whitespace,
        fmt.tidy,
        fmt.trim_newlines,
        fmt.eslint_d,
        -----------------
        -- DIAGNOSTICS --
        -----------------
        dgn.eslint_d,
        dgn.shellcheck,
        dgn.luacheck.with({
            extra_args = {
                "--globals",
                "P",
                "__lk_global_callbacks",
                "after_each",
                "before_each",
                "describe",
                "it",
                "lk",
                "packer_plugins",
                "vim",
                "RELOAD",
                "R",
                "--std",
                "luajit",
            },
        }),
        ------------------
        -- CODE ACTIONS --
        ------------------
        cda.eslint_d,
        cda.shellcheck,
    },
    -- on_attach = function(client, bufnr)
    --     -- U.fmt_on_save(client, bufnr)
    --     U.mappings()
    -- end,
})
