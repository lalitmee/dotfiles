local cms = require("checkmate.snippets")
local ls = require("luasnip")

ls.add_snippets("markdown", {
    --------------------------------------------------------------------------------
    -- -- NOTE: .bug {{{
    --------------------------------------------------------------------------------

    cms.todo({
        trigger = ".bug",
        text = "New BUG",
        metadata = {
            bug = "",
            priority = true,
        },
        ls_context = {
            snippetType = "autosnippet",
        },
    }),

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- -- NOTE: @p {{{
    -- -- insert @priority(<type>)
    --------------------------------------------------------------------------------

    cms.metadata({
        trigger = "@p",
        tag = "priority",
        desc = "@priority",
        auto_select = true,
        ls_context = { snippetType = "autosnippet" },
    }),

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- -- NOTE: .i<issue-number> {{{
    --    Expanding ".i500" will result in:
    --    □ New ISSUE @url(https://github.com/bngarren/checkmate.nvim/issues/500) @issue(#500)
    --------------------------------------------------------------------------------

    -- -- simple
    -- cms.todo({
    --     trigger = "%.i(%d+)", -- ".i" followed by a number (captured)
    --     desc = "New ISSUE",
    --     metadata = {
    --         issue = function(captures)
    --             local issue_num = captures[1] or ""
    --             return "#" .. issue_num
    --         end,
    --     },
    --     ls_context = {
    --         snippetType = "snippet",
    --         regTrig = true,
    --     },
    -- }),

    -- advanced
    cms.todo({
        trigger = "%.i(%d+)",
        desc = "New ISSUE",
        metadata = {
            issue = function(captures)
                local issue_num = captures[1] or ""
                return "#" .. issue_num
            end,
            url = function(captures)
                local repo = vim.fn
                    .system("git remote get-url origin")
                    :gsub("\n", "")
                    :gsub("%.git$", "")
                    :gsub("^.*:", "https://github.com/")
                return string.format("%s/issues/%s", repo, captures[1])
            end,
        },
        ls_context = {
            snippetType = "snippet",
            regTrig = true,
        },
    }),

    --------------------------------------------------------------------------------
    -- }}}
    --------------------------------------------------------------------------------
})
