local nvim_cmp = {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        {
            "hrsh7th/cmp-nvim-lua",
            ft = { "lua" },
        },
        -- {
        --     "tzachar/cmp-tabnine",
        --     build = "./install.sh",
        -- },
        {
            "roobert/tailwindcss-colorizer-cmp.nvim",
            ft = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
            },
            enabled = false,
        },
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local luasnip = require("luasnip")
        local neogen = require("neogen")
        local compare = require("cmp.config.compare")

        -- Don't show the dumb matching stuff.
        vim.opt.shortmess:append("c")

        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0
                and vim.api
                        .nvim_buf_get_lines(0, line - 1, line, true)[1]
                        :sub(col, col)
                        :match("%s")
                    == nil
        end

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = {
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-n>"] = cmp.mapping(
                    cmp.mapping.select_next_item(),
                    { "i", "c" }
                ),
                ["<C-p>"] = cmp.mapping(
                    cmp.mapping.select_prev_item(),
                    { "i", "c" }
                ),
                -- ["<Tab>"] = cmp.mapping({ i = tab }),
                -- ["<S-Tab>"] = cmp.mapping({ i = s_tab }),
                ["<Tab>"] = nil,
                ["<S-Tab>"] = nil,
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Replace,
                                select = false,
                            })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-j>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif neogen.jumpable() then
                        neogen.jump_next()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                    "c",
                }),
                ["<C-k>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    elseif neogen.jumpable(true) then
                        neogen.jump_prev()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                    "c",
                }),
            },
            sources = cmp.config.sources({
                {
                    name = "nvim_lsp",
                    keyword_length = 3,
                    max_item_count = 30,
                },
                { name = "nvim_lua" },
                { name = "luasnip" },
                {
                    name = "cmp_tabnine",
                    keyword_length = 3,
                },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
            sorting = {
                priority_weight = 2,
                comparators = {
                    compare.score,
                    compare.recently_used,
                    compare.offset,
                    compare.exact,
                    compare.kind,
                    compare.sort_text,
                    compare.length,
                    compare.order,
                },
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = {
                format = lspkind.cmp_format({
                    menu = {
                        buffer = "[BUF]",
                        cmp_tabnine = "[TBN]",
                        luasnip = "[SNIP]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[API]",
                        path = "[PATH]",
                    },
                }),
            },
            experimental = { ghost_text = false },
        })
        -- require("cmp").config.formatting = {
        --     format = require("tailwindcss-colorizer-cmp").formatter,
        -- }

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        -- cmp.setup.cmdline(":", {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = cmp.config.sources({
        --         { name = "path" },
        --     }, {
        --         { name = "cmdline" },
        --     }),
        -- })

        -- -- Set configuration for specific filetype.
        -- cmp.setup.filetype("gitcommit", {
        --     sources = cmp.config.sources({
        --         { name = "cmp_git" },
        --     }, {
        --         { name = "buffer" },
        --     }),
        -- })
    end,
}

local codeium = {
    "Exafunction/codeium.vim",
    event = { "InsertEnter" },
    config = function()
        vim.keymap.set("i", "<Tab>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true })

        vim.g.codeium_filetypes = {
            TelescopePrompt = false,
        }
    end,
}

return {
    nvim_cmp,
    codeium,
}