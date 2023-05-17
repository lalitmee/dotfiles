return {
    "danymat/neogen",
    cmd = { "Neogen" },
    opts = {
        snippet_engine = "luasnip",
        enabled = true,
        languages = {
            lua = {
                template = {
                    annotation_convention = "ldoc",
                },
            },
            python = {
                template = {
                    annotation_convention = "google_docstrings",
                },
            },
            rust = {
                template = {
                    annotation_convention = "rustdoc",
                },
            },
            javascript = {
                template = {
                    annotation_convention = "jsdoc",
                },
            },
            typescript = {
                template = {
                    annotation_convention = "tsdoc",
                },
            },
            typescriptreact = {
                template = {
                    annotation_convention = "tsdoc",
                },
            },
        },
    },
    init = function()
        local neogen = require("neogen")
        local wk = require("which-key")
        wk.register({
            ["d"] = {
                ["name"] = "+docstrings",
                ["d"] = { ":Neogen<CR>", "doc-this" },
                ["c"] = {
                    function()
                        neogen.generate({ type = "class" })
                    end,
                    "doc-this-class",
                },
                ["f"] = {
                    function()
                        neogen.generate({ type = "func" })
                    end,
                    "doc-this-function",
                },
                ["t"] = {
                    function()
                        neogen.generate({ type = "type" })
                    end,
                    "doc-this-type",
                },
            },
        }, { mode = "n", prefix = "<localleader>" })
    end,
}
