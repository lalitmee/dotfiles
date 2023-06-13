if not vim.filetype then
    return
end

vim.g.do_filetype_lua = 1

vim.filetype.add({
    extension = {
        lock = "yaml",
        md = "markdown",
        snippets = "snippets",
        conf = "conf",
        gitcommit = "gitcommit",
        tmux = "conf",
    },
    filename = {
        [".gitignore"] = "gitconfig",
        Podfile = "ruby",
        Brewfile = "ruby",
        Caddyfile = "conf",
        lfrc = "sh",
        sxhkdrc = "sxhkdrc",
        [".env"] = "sh",
    },
    pattern = {
        [".*git/config"] = "gitconfig", -- Included in the plugin
        ["*.env.*"] = "env",
        [".{jscs,jshint,eslint,babel}rc"] = "json",
    },
})
