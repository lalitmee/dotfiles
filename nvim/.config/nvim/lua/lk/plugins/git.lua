return {
    "rmagatti/igs.nvim",
    keys = {
        -- quickfix
        "<leader>gqA",
        "<leader>gqD",
        "<leader>gqM",
        "<leader>gqS",
        "<leader>gqa",
        "<leader>gqc",
        "<leader>gqd",
        "<leader>gqm",
        "<leader>gqs",

        -- edit
        "<leader>gea",
        "<leader>gem",
        "<leader>ges",
    },
    config = function()
        require("igs").setup()
    end,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["g"] = {
                ["q"] = {
                    ["name"] = "+quickfix",
                    ["a"] = {
                        function()
                            require("igs").qf_all()
                        end,
                        "all-files",
                    },
                    ["A"] = {
                        function()
                            require("igs").qf_all({ all_changes = true })
                        end,
                        "all-changes",
                    },
                    ["c"] = {
                        function()
                            require("igs").qf_conflicts()
                        end,
                        "conflicts",
                    },
                    ["d"] = {
                        function()
                            require("igs").qf_diff_branch({ all_changes = true })
                        end,
                        "diff-branch-changes",
                    },
                    ["D"] = {
                        function()
                            require("igs").qf_diff_branch({
                                all_changes = false,
                            })
                        end,
                        "diff-branch",
                    },
                    ["m"] = {
                        function()
                            require("igs").qf_modified()
                        end,
                        "modified-files",
                    },
                    ["M"] = {
                        function()
                            require("igs").qf_modified({ all_changes = true })
                        end,
                        "modified-changes",
                    },
                    ["s"] = {
                        function()
                            require("igs").qf_added()
                        end,
                        "staged-files",
                    },
                    ["S"] = {
                        function()
                            require("igs").qf_added({ all_changes = true })
                        end,
                        "staged-changes",
                    },
                },
                ["e"] = {
                    ["name"] = "+edit",
                    ["a"] = {
                        function()
                            require("igs").edit_all()
                        end,
                        "all-files",
                    },
                    ["m"] = {
                        function()
                            require("igs").edit_modified()
                        end,
                        "modifed-files",
                    },
                    ["s"] = {
                        function()
                            require("igs").edit_added()
                        end,
                        "added-files",
                    },
                },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}
