return {

    ----------------------------------------------------------------------
    --                           comment.nvim                           --
    ----------------------------------------------------------------------
    {
        "numToStr/Comment.nvim",
        event = { "VeryLazy" },
        config = function()
            require("Comment").setup({
                ignore = "^$",
                pre_hook = function(ctx)
                    local U = require("Comment.utils")

                    local location = nil
                    if ctx.ctype == U.ctype.blockwise then
                        location = require("ts_context_commentstring.utils").get_cursor_location()
                    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                        location = require("ts_context_commentstring.utils").get_visual_start_location()
                    end

                    return require("ts_context_commentstring.internal").calculate_commentstring({
                        key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
                        location = location,
                    })
                end,
            })

            local comment_ft = require("Comment.ft")
            comment_ft.set("lua", { "--%s", "--[[%s]]" })
            comment_ft.set("kdl", { "//%s" })
        end,
    },

    ----------------------------------------------------------------------
    --                          comment frame                           --
    ----------------------------------------------------------------------
    {
        "s1n7ax/nvim-comment-frame",
        opts = {
            keymap = "<localleader>cc",
            multiline_keymap = "<localleader>cC",
        },
        keys = {
            "<localleader>cc",
            "<localleader>cC",
        },
    },

    ----------------------------------------------------------------------
    --                            auto-pairs                            --
    ----------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local auto_pairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")
            local ts_conds = require("nvim-autopairs.ts-conds")

            auto_pairs.setup({
                check_ts = true,
                enable_moveright = true,
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Typing space when (|) -> ( | )
            local brackets = {
                { "(", ")" },
                { "[", "]" },
                { "{", "}" },
            }
            auto_pairs.add_rules({
                Rule(" ", " "):with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({
                        brackets[1][1] .. brackets[1][2],
                        brackets[2][1] .. brackets[2][2],
                        brackets[3][1] .. brackets[3][2],
                    }, pair)
                end),
            })
            for _, bracket in pairs(brackets) do
                auto_pairs.add_rules({
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(function()
                            return false
                        end)
                        :with_move(function(opts)
                            return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                        end)
                        :use_key(bracket[2]),
                })
            end

            auto_pairs.add_rules({
                -- Typing { when {| -> {{ | }} in Vue files
                Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),

                -- Typing = when () -> () => {|}
                Rule("%(.*%)%s*%=$", "> {}", { "typescript", "typescriptreact", "javascript", "vue" })
                    :use_regex(true)
                    :set_end_pair_length(1),

                -- Typing n when the| -> then|end
                Rule("then", "end", "lua"):end_wise(function(opts)
                    return string.match(opts.line, "^%s*if") ~= nil
                end),
            })
        end,
    },

    ----------------------------------------------------------------------
    --                             nvim-ufo                             --
    ----------------------------------------------------------------------
    {
        "kevinhwang91/nvim-ufo",
        event = "BufReadPost",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            local ufo = require("ufo")

            vim.opt.sessionoptions:append("folds")
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            lk.nnoremap("zR", ufo.openAllFolds, { desc = "open all folds" })
            lk.nnoremap("zM", ufo.closeAllFolds, { desc = "close all folds" })
            lk.nnoremap("zr", require("ufo").openFoldsExceptKinds, { desc = "open folds except kinds" })
            lk.nnoremap("zm", require("ufo").closeFoldsWith, { desc = "close folds with" })
            lk.nnoremap("zk", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end, { desc = "preview fold" })

            ufo.setup({
                fold_virt_text_handler = function(virt_text, lnum, end_lnum, width)
                    local suffix = " {...} ┣━━"
                    local lines = ("┫ %d lines ┣━━"):format(end_lnum - lnum)

                    local cur_width = 0
                    for _, section in ipairs(virt_text) do
                        cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
                    end

                    suffix = suffix .. ("━"):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 10)

                    table.insert(virt_text, { suffix, "Normal" })
                    table.insert(virt_text, { lines, "Normal" })
                    return virt_text
                end,
                close_fold_kinds = { "imports" },
                open_fold_hl_timeout = 0,
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },
}
