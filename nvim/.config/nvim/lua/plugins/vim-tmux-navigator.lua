return {
    "christoomey/vim-tmux-navigator",
    keys = {
        "<C-h>",
        "<C-j>",
        "<C-k>",
        "<C-l>",
    },
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    init = function()
        local wk = require("which-key")
        wk.register({
            ["w"] = {
                ["h"] = { ":<C-U>TmuxNavigateLeft<CR>", "window-left" },
                ["j"] = { ":<C-U>TmuxNavigateDown<CR>", "window-down" },
                ["k"] = { ":<C-U>TmuxNavigateUp<CR>", "window-up" },
                ["l"] = { ":<C-U>TmuxNavigateRight<CR>", "window-right" },
                ["p"] = { ":<C-U>TmuxNavigatePrevious<CR>", "window-previous" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}
