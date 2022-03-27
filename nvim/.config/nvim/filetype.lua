if not vim.filetype then
  return
end

vim.g.do_filetype_lua = 1

vim.filetype.add({
  extension = {
    lock = "yaml",
    pn = "potion",
    md = "markdown",
    snippets = "snippets",
    conf = "conf",
  },
  filename = {
    [".gitignore"] = "conf",
    Podfile = "ruby",
    Brewfile = "ruby",
    Caddyfile = "conf",
    lfrc = "sh",
    [".env"] = "sh",
  },
  pattern = {
    ["*.gradle"] = "groovy",
    ["*.env.*"] = "env",
    [".*git/config"] = "gitconfig", -- Included in the plugin
    ["*.env.*"] = "env",
    ["*.conf"] = "conf",
    [".{jscs,jshint,eslint,babel}rc"] = "json",
    ["*.md"] = "markdown",
  },
})
