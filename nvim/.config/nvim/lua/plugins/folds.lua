local nvim_ufo = {
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
        lk.nnoremap(
            "zr",
            require("ufo").openFoldsExceptKinds,
            { desc = "open folds except kinds" }
        )
        lk.nnoremap(
            "zm",
            require("ufo").closeFoldsWith,
            { desc = "close folds with" }
        )
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

                suffix = suffix
                    .. ("━"):rep(
                        width - cur_width - vim.fn.strdisplaywidth(lines) - 10
                    )

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
}

local pretty_folds = {
    "anuvyklack/pretty-fold.nvim",
    event = { "BufReadPost" },
    opts = {
        keep_indentation = false,
        fill_char = "━",
        sections = {
            left = {
                "━ ",
                function()
                    return string.rep("*", vim.v.foldlevel)
                end,
                " ━┫",
                "content",
                "┣",
            },
            right = {
                "┫ ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ┣━━",
            },
        },
    },
    enabled = false,
}

local fold_cycle = {
    "jghauser/fold-cycle.nvim",
    keys = { "<CR>" },
    config = function()
        require("fold-cycle").setup()
        lk.nnoremap("<CR>", function()
            require("fold-cycle").open()
        end)
    end,
    enabled = false,
}

return {
    fold_cycle,
    nvim_ufo,
    pretty_folds,
}
