local M = {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
}

function M.config()
    local ok, fzf_lua = lk.require("fzf-lua")
    if not ok then
        return
    end

    fzf_lua.setup({
        fzf_opts = {},
        grep = {
            rg_glob = true,
            rg_opts = "--hidden --column --line-number --no-heading" .. " --color=always --smart-case -g '!.git'",
        },
    })
end

return M
