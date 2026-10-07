local function map(lhs, rhs, opts)
    opts = opts or {}
    local mode = opts.mode or "n"
    opts.mode = nil
    vim.keymap.set(mode, lhs, rhs, opts)
end

local wk = require("which-key")

require("neogit").setup({
    disable_commit_confirmation = true,
    integrations = { snacks = true, diffview = true },
    signs = {
        hunk = { "", "" },
        item = { "▷", "▽" },
        section = { "▷", "▽" },
    },
})
map("<leader>gs", ":Neogit<CR>", { desc = "Status", silent = true })
lk.augroup("neogit_au", {
    { event = { "FileType" }, pattern = { "NeogitCommitMessage" }, command = function() vim.cmd("set ft=gitcommit") end },
    { event = { "User" }, pattern = { "NeogitPushComplete" }, command = function() require("neogit").close() end },
})

wk.add({ { "<localleader>g", group = "git" } })
require("gitsigns").setup({
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    numhl = true,
    linehl = false,
    watch_gitdir = { interval = 1000 },
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil,
    current_line_blame = false,
    current_line_blame_opts = { virt_text = true, virt_text_pos = "eol", delay = 500 },
    preview_config = { border = "rounded" },
    current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
})
map("<leader>gdd", ":Gitsigns diffthis<CR>", { desc = "Diffthis" })
map("<leader>gdw", ":Gitsigns toggle_word_diff<CR>", { desc = "Toggle Word Diff" })
map("<leader>gm", ":Gitsigns blame_line<CR>", { desc = "Blame Line" })
map("<leader>gO", function() vim.cmd("silent !gh repo view --web") end, { desc = "Open Repo" })
map("<localleader>gS", ":Gitsigns stage_hunk<CR>", { desc = "stage hunk", silent = true })
map("<localleader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "undo stage Hunk", silent = true })
map("<localleader>gv", ":Gitsigns preview_hunk<CR>", { desc = "preview hunk", silent = true })
map("<localleader>gV", ":Gitsigns preview_hunk_inline<CR>", { desc = "preview hunk inline", silent = true })
map("<localleader>gx", ":Gitsigns reset_hunk<CR>", { desc = "discard hunk", silent = true })
map("<localleader>gX", ":Gitsigns reset_buffer<CR>", { desc = "discard buffer", silent = true })

require("octo").setup({ enable_builtin = true, picker = "snacks" })
map("<leader>go", ":Octo<CR>", { desc = "Octo", silent = true })
map("<leader>gg", ":Guh<CR>", { desc = "Guh (GitHub)", silent = true })
vim.g.diffs = { integrations = { neogit = true, gitsigns = true } }

wk.add({ { "<leader>gw", group = "git-worktree" } })
local worktree_picker = require("plugins.git.worktree.picker")
map("<leader>gwa", worktree_picker.create_worktree_picker, { desc = "Create Worktree (with Branch Picker)", silent = true })
map("<leader>gwd", worktree_picker.delete_worktree_picker, { desc = "Delete Worktree" })
map("<leader>gwl", worktree_picker.switch_worktree_picker, { desc = "List Worktrees", silent = true })
require("plugins.git.worktree.hooks")

require("diffview").setup({
    enhanced_diff_hl = true,
    key_bindings = {
        file_panel = { q = "<Cmd>DiffviewClose<CR>" },
        view = { q = "<Cmd>DiffviewClose<CR>" },
    },
})
map("<leader>gdc", ":DiffviewClose<CR>", { desc = "Diffview Close" })
map("<leader>gdf", ":DiffviewFileHistory %<CR>", { desc = "Current File History" })
map("<leader>gdF", ":DiffviewFileHistory<CR>", { desc = "Diffview File History" })
map("<leader>gdo", ":DiffviewOpen<CR>", { desc = "Diffview Open" })

wk.add({ { "<leader>gy", group = "gist" } })
require("gist").setup({})
map("<leader>gys", ":GistCreate<CR>", { desc = "Create Gist (selection/buffer)", mode = { "n", "v" }, silent = true })
map("<leader>gyp", ":GistCreateFromFile<CR>", { desc = "Create Gist from File", mode = "n", silent = true })
map("<leader>gyl", ":GistsList<CR>", { desc = "List & Search Gists", mode = "n", silent = true })
