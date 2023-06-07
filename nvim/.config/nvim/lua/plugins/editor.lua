return {

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
}
