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
        tmux = "tmux",
    },
    filename = {
        [".gitignore"] = "gitconfig",
        Podfile = "ruby",
        Brewfile = "ruby",
        Caddyfile = "conf",
        config = "conf",
        lfrc = "sh",
        sxhkdrc = "sxhkdrc",
        [".env"] = "dosini",
        ["tmux.conf.local"] = "tmux",
    },
    pattern = {
        [".*git/config"] = "gitconfig", -- Included in the plugin
        ["*.env.*"] = "dosini",
        [".{jscs,jshint,eslint,babel}rc"] = "json",
    },
})

