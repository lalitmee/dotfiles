local M = {
    "windwp/nvim-autopairs",
}

function M.config()
    local ok, auto_pairs = lk.require("nvim-autopairs")
    if not ok then
        return
    end

    auto_pairs.setup({
        disable_filetype = { "TelescopePrompt", "vim" },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
