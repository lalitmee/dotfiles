local parsers = {
    "angular",
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "dart",
    "diff",
    "dockerfile",
    "editorconfig",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "graphql",
    "html",
    "http",
    "javascript",
    "jsdoc",
    "json",
    "kdl",
    "liquid",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
}

local treesitter = require("nvim-treesitter")
treesitter.setup()

local installed = treesitter.get_installed()
local to_install = {}
for _, parser in ipairs(parsers) do
    if not vim.list_contains(installed, parser) then
        table.insert(to_install, parser)
    end
end
if #to_install > 0 then
    treesitter.install(to_install)
end

vim.treesitter.language.register("markdown", "octo")
vim.treesitter.language.register("bash", "zsh")
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

local textobjects = require("nvim-treesitter-textobjects")
textobjects.setup({
    select = { lookahead = true, include_surrounding_whitespace = false },
    move = { set_jumps = true },
})

local ts_select = require("nvim-treesitter-textobjects.select")
local ts_swap = require("nvim-treesitter-textobjects.swap")
local ts_move = require("nvim-treesitter-textobjects.move")
local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")

vim.keymap.set({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "aC", function() ts_select.select_textobject("@conditional.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "iC", function() ts_select.select_textobject("@conditional.inner", "textobjects") end)
vim.keymap.set("n", "]w", function() ts_swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "[w", function() ts_swap.swap_previous("@parameter.inner") end)
vim.keymap.set({ "n", "x", "o" }, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]k", function() ts_move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]K", function() ts_move.goto_next_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[k", function() ts_move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[K", function() ts_move.goto_previous_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })
vim.keymap.set("n", "<leader>lf", function() ts_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set("n", "<leader>lc", function() ts_move.goto_next_start("@class.outer", "textobjects") end)

require("treesj").setup({ max_join_length = 500, use_default_keymaps = false })
vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>", { desc = "Split" })
vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>", { desc = "Join" })

local helpers = require("ts-node-action.helpers")
require("ts-node-action").setup({
    javascript = {
        update_expression = function(node)
            local operators = { ["++"] = "+=1", ["+=1"] = "++", ["--"] = "-=1", ["-=1"] = "--" }
            local replacement = {}
            for child in node:iter_children() do
                local text = helpers.node_text(child)
                table.insert(replacement, operators[text] or text)
            end
            return table.concat(replacement, " ")
        end,
        augmented_assignment_expression = function(node)
            local operators = { ["+="] = "++", ["-="] = "--" }
            local replacement = {}
            for child in node:iter_children() do
                local text = helpers.node_text(child)
                table.insert(replacement, operators[text] or text)
            end
            return table.concat(replacement, " ")
        end,
    },
})
vim.keymap.set("n", "<leader>tk", function() require("ts-node-action").node_action() end, { desc = "Trigger Node Action" })
