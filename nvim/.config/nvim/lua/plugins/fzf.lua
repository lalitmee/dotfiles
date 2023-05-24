return {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    config = function()
        require("fzf-lua").setup({
            winopts = {
                width = 0.95,
                height = 0.95,
                preview = {
                    title_align = "center",
                    scrollbar = "border",
                },
            },
            fzf_opts = {},
            grep = {
                rg_glob = true,
                rg_opts = "--hidden --column --line-number --no-heading"
                    .. " --color=always --smart-case -g '!.git'",
            },
            file_ignore_patterns = { "node_modules", ".git" },
        })
    end,
}
