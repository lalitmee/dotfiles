return {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    config = true,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["g"] = {
                ["o"] = {
                    ["name"] = "+octo.nvim",
                    ["a"] = {
                        ["name"] = "+reaction",
                        ["c"] = {
                            ":Octo reaction confused<CR>",
                            "react-confused",
                        },
                        ["d"] = {
                            ":Octo reaction thumbs_down<CR>",
                            "react-thumbs_down",
                        },
                        ["e"] = { ":Octo reaction eyes<CR>", "react-eyes" },
                        ["h"] = { ":Octo reaction heart<CR>", "react-heart" },
                        ["l"] = { ":Octo reaction laugh<CR>", "react-laugh" },
                        ["r"] = { ":Octo reaction rocket<CR>", "react-rocket" },
                        ["t"] = { ":Octo reaction tada<CR>", "react-tada" },
                        ["u"] = {
                            ":Octo reaction thumbs_up<CR>",
                            "react-thumbs_up",
                        },
                    },
                    ["c"] = {
                        ["name"] = "+comment",
                        ["a"] = { ":Octo comment add<CR>", "add" },
                        ["d"] = { ":Octo comment delete<CR>", "delete" },
                    },
                    ["g"] = { ":Octo gist list<CR>", "list-gist" },
                    ["i"] = {
                        ["name"] = "+issues",
                        ["a"] = { ":Octo issue create<CR>", "create" },
                        ["b"] = { ":Octo issue browser<CR>", "browser" },
                        ["c"] = { ":Octo issue close<CR>", "close" },
                        ["e"] = { ":Octo issue edit<CR>", "edit" },
                        ["l"] = { ":Octo issue list<CR>", "list" },
                        ["o"] = { ":Octo issue reopen<CR>", "reopen" },
                        ["r"] = { ":Octo issue reload<CR>", "reload" },
                        ["s"] = { ":Octo issue search<CR>", "search" },
                        ["u"] = { ":Octo issue url<CR>", "url" },
                    },
                    ["l"] = {
                        ["name"] = "+label",
                        ["a"] = { ":Octo label add<CR>", "add" },
                        ["c"] = { ":Octo label create<CR>", "create" },
                        ["r"] = { ":Octo label remove<CR>", "remove" },
                    },
                    ["p"] = {
                        ["name"] = "+pull-requests",
                        ["a"] = { ":Octo pr create<CR>", "create" },
                        ["b"] = { ":Octo pr browser<CR>", "browser" },
                        ["c"] = { ":Octo pr checkout<CR>", "checkout" },
                        ["C"] = { ":Octo pr close<CR>", "close" },
                        ["d"] = { ":Octo pr diff<CR>", "diff" },
                        ["D"] = { ":Octo pr checks<CR>", "checks" },
                        ["e"] = { ":Octo pr edit<CR>", "edit" },
                        ["g"] = { ":Octo pr commits<CR>", "commits" },
                        ["h"] = { ":Octo pr changes<CR>", "changes" },
                        ["l"] = { ":Octo pr list<CR>", "list" },
                        ["m"] = { ":Octo pr merge<CR>", "merge" },
                        ["o"] = { ":Octo pr reopen<CR>", "reopen" },
                        ["r"] = { ":Octo pr reload<CR>", "reload" },
                        ["R"] = { ":Octo pr ready<CR>", "ready" },
                        ["s"] = { ":Octo pr search<CR>", "search" },
                        ["u"] = { ":Octo pr url<CR>", "url" },
                    },
                    ["r"] = {
                        ["name"] = "+repositories",
                        ["b"] = { ":Octo repo browser<CR>", "browser" },
                        ["f"] = { ":Octo repo fork<CR>", "fork" },
                        ["l"] = { ":Octo repo list<CR>", "list" },
                        ["u"] = { ":Octo repo url<CR>", "url" },
                    },
                    ["R"] = {
                        ["name"] = "+review",
                        ["a"] = { ":Octo reviewer add<CR>", "add-reviewer" },
                        ["b"] = { ":Octo review start<CR>", "start-review" },
                        ["c"] = {
                            ":Octo review comments<CR>",
                            "comments-review",
                        },
                        ["d"] = { ":Octo review discard<CR>", "discard-review" },
                        ["r"] = { ":Octo review resume<CR>", "resume-review" },
                        ["s"] = { ":Octo review submit<CR>", "submit-review" },
                    },
                    ["t"] = {
                        ["name"] = "+thread",
                        ["r"] = { ":Octo thread resolve<CR>", "resolve" },
                        ["u"] = { ":Octo thread unresolve<CR>", "unresolve" },
                    },
                },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}
