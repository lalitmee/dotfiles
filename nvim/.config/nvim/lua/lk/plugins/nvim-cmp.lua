local cmp_ok, cmp = lk.require("cmp")
if not cmp_ok then
    return
end

local lspkind = require("lspkind")
local luasnip = require("luasnip")

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

----------------------------------------------------------------------
-- NOTE: cmp setup {{{
----------------------------------------------------------------------
local function tab(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    else
        fallback()
    end
end

local function s_tab(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end

cmp.setup({
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping({ i = tab }),
        ["<S-Tab>"] = cmp.mapping({ i = s_tab }),
    },
    sources = cmp.config.sources({
        { name = "cmp_tabnine" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        { name = "orgmode" },
    }, {
        { name = "buffer" },
    }),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find("^_+")
                local _, entry2_under = entry2.completion_item.label:find("^_+")
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                    return false
                elseif entry1_under < entry2_under then
                    return true
                end
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            menu = {
                cmp_tabnine = "[TBN]",
                buffer = "[BUF]",
                cmdline = "[CMD]",
                luasnip = "[SNIP]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[API]",
                path = "[PATH]",
            },
        }),
    },
    experimental = { native_menu = false, ghost_text = false },
})
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: cmp cmdline setup {{{
----------------------------------------------------------------------
local search_sources = {
    sources = cmp.config.sources({
        {
            name = "buffer",
            options = { keyword_pattern = [=[[^[:blank:]].*]=] },
        },
    }),
}

cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" },
    }, {
        { name = "buffer" },
    }),
})
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
