local M = {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
}

function M.config()
    require("fzf-lua").setup({
        fzf_opts = {},
        grep = {
            rg_glob = true,
            rg_opts = "--hidden --column --line-number --no-heading" .. " --color=always --smart-case -g '!.git'",
        },
    })
end

return M
